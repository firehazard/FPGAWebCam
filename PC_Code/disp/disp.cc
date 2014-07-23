// Must include pcap.h first!

#include "pcap.h"

#ifdef WIN32
#include <windows.h>
#endif

#include <GL/gl.h>
#include <GL/glut.h>

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pcap.h"

// Basic image type
#include "image.h"

// WinPcap defines
#define BYTEZERO(X) (u_char)((X) & 0xFF)
#define BYTEONE(X) (u_char)(((X) >> 8) & 0xFF)

#define MAX_XMIT_LEN (1600)
pcap_t *adhandle;
u_char myMAC[] = {0x00,0x11,0x95,0x1E,0x11,0x39};
u_char fpgaMAC[] = {0x00,0x11,0x11,0x66,0x77,0x7A};
                                         


// OpenGL defines
//#define MAX_INITIAL_WINDOW_WIDTH   800
//#define MAX_INITIAL_WINDOW_HEIGHT  600
#define MAX_INITIAL_WINDOW_WIDTH   200
#define MAX_INITIAL_WINDOW_HEIGHT  150
#define XSTART_INIT 150
#define XSTOP_INIT 250
#define YSTART_INIT 100
#define YSTOP_INIT 200
#define START_INIT 0
#define STOP_INIT 1

#define Min(a,b) (((a)<(b))?(a):(b))
#define Max(a,b) (((a)>(b))?(a):(b))

#define ESC 0x1b

image_t *image;
unsigned char *pix_ptr = 0;
unsigned char grayval = 0;

int xsize = MAX_INITIAL_WINDOW_WIDTH;
int ysize = MAX_INITIAL_WINDOW_HEIGHT;


int window_width = MAX_INITIAL_WINDOW_WIDTH;
int window_height = MAX_INITIAL_WINDOW_HEIGHT;

long packetcounter;
int currentRow;
int xstart, ystart, xstop, ystop, start, stop;

//int mouse_left_down, mouse_left_x, mouse_left_y;
//int mouse_middle_down, mouse_middle_x, mouse_middle_y;

// Prototypes
void sendControlPacketToFPGA();

void
Redraw(void)
// Fixed to display right side up...
{

	glViewport(0, 0, window_width, window_height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, window_width, 0, window_height, -1, 1);
	glRasterPos2i((window_width-xsize)>>1,window_height - ((window_height-ysize)>>1));
	glPixelZoom(1.0,-1.0);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, image->width);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

    switch (image->components) {
    case 1:
	glDrawPixels(xsize,ysize, GL_LUMINANCE,
		     GL_UNSIGNED_BYTE, image->pixels);
	break;
//    case 2:
//	glDrawPixels(transfer_w, transfer_h, GL_LUMINANCE_ALPHA,
//		     GL_UNSIGNED_BYTE, image->pixels);
	break;
    case 3:
//	glDrawPixels(transfer_w, transfer_h, GL_RGB, GL_UNSIGNED_BYTE,
	glDrawPixels(xsize, ysize, GL_RGB, GL_UNSIGNED_BYTE,
		     image->pixels);
	break;
//    case 4:
//	glDrawPixels(transfer_w, transfer_h, GL_RGBA, GL_UNSIGNED_BYTE,
//		     image->pixels);
//	break;
    }

    glFinish();
    glutSwapBuffers();
}

/*
void
Reshape(GLsizei w, GLsizei h)
{
    origin_x += (w - window_width) / 2;
    origin_y += (h - window_height) / 2;

    window_width  = w;
    window_height = h;
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, w, 0, h, -1, 1);

    glutPostRedisplay();
}
*/

// key is the ascii key pressed
// x,y are the mouse coords when teh key was pressed
void
Keypress(unsigned char key, int x, int y)
{
    int width = image->width;
    int height = image->height;

    y = window_height - y;

    switch (key) {
    case ESC:
    case 'Q':
    case 'q':
	exit(0);

	case 'x':
		xsize -= 4; 
		if(xsize<4) xsize = 4;

		xstart=XSTART_INIT;
		xstop=xstart+xsize;
		break;

	case 'X':
		xsize += 4; 
		if(xsize>MAX_INITIAL_WINDOW_WIDTH) xsize = MAX_INITIAL_WINDOW_WIDTH;
		
		xstart=XSTART_INIT;
		xstop=xstart+xsize;
		
		break;

	case 'y':
		ysize -= 4; 
		if(ysize<4) ysize = 4;

		ystart=YSTART_INIT;
		ystop=ystart+ysize;
		break;

	case 'Y':
		ysize += 4; 
		if(ysize>MAX_INITIAL_WINDOW_HEIGHT) ysize = MAX_INITIAL_WINDOW_HEIGHT;
		
		ystart=YSTART_INIT;
		ystop=ystart+ysize;
		break;

	case ' ':
		//printf("space bar - start/stop\n");
		stop=start;
		start=(start ? 0 : 1);
		break;
    default:
	break;
    }

	sendControlPacketToFPGA();

}

/*
void
Mousepress(int button, int state, int x, int y)
{
    if (button == GLUT_LEFT_BUTTON) {
	mouse_left_x    = x;
	mouse_left_y    = y;
	mouse_left_down = (state == GLUT_DOWN);
    }
    if (button == GLUT_MIDDLE_BUTTON) {
	mouse_middle_x    = x;
	mouse_middle_y    = y;
	mouse_middle_down = (state == GLUT_DOWN);
    }
}
*/

/*
void
Mousemove(int x, int y)
{
    int width = image->width;
    int height = image->height;

    if (mouse_left_down) {
	origin_x += (x - mouse_left_x);
	origin_x  = Max(origin_x, 1 - width * zoom); 
	origin_x  = Min(origin_x, window_width - 1);

	origin_y += (mouse_left_y - y);
	origin_y  = Max(origin_y, 1 - height * zoom); 
	origin_y  = Min(origin_y, window_height - 1);

	mouse_left_x = x;
	mouse_left_y = y;
    }
    if (mouse_middle_down) {
	mouse_middle_x = x;
	mouse_middle_y = y;
    }

    glutPostRedisplay();
}
*/

// Initialize WinPcap 
int InitWinPcap(){
pcap_if_t *alldevs;
pcap_if_t *d;
int inum;
int i=0,j=0;
char errbuf[PCAP_ERRBUF_SIZE];


	/* Retrieve the device list on the local machine */
	if (pcap_findalldevs_ex(PCAP_SRC_IF_STRING, NULL, &alldevs, errbuf) == -1)
	{
		fprintf(stderr,"Error in pcap_findalldevs: %s\n", errbuf);
		exit(1);
	}
    
    /* Print the list */
    for(d=alldevs; d; d=d->next)
    {
        printf("%d. %s", ++i, d->name);
        if (d->description)
            printf(" (%s)\n", d->description);
        else
            printf(" (No description available)\n");
    }
	
    if(i==0)
    {
        printf("\nNo interfaces found! Make sure WinPcap is installed.\n");
        return -1;
    }
    
    printf("Enter the interface number (1-%d):",i);
    scanf("%d", &inum);
    
    if(inum < 1 || inum > i)
    {
        printf("\nInterface number out of range.\n");
        /* Free the device list */
        pcap_freealldevs(alldevs);
        return -1;
    }
	
    /* Jump to the selected adapter */
    for(d=alldevs, i=0; i< inum-1 ;d=d->next, i++);
    
	/* Open the device */
	if ( (adhandle= pcap_open(d->name,			// name of the device
							  65536,			// portion of the packet to capture. 
												// 65536 guarantees that the whole packet will be captured on all the link layers
							  PCAP_OPENFLAG_PROMISCUOUS, 	// promiscuous mode
							  1000,				// read timeout = 1 sec
							  NULL,				// authentication on the remote machine
							  errbuf			// error buffer
							  ) ) == NULL)
	{
		fprintf(stderr,"\nUnable to open the adapter. %s is not supported by WinPcap\n", d->name);
		/* Free the device list */
		pcap_freealldevs(alldevs);
		return -1;
	}    
    printf("\nlistening on %s...\n", d->description);	
    /* At this point, we don't need any more the device list. Free it */
    pcap_freealldevs(alldevs);
	return 0;
}


// Here's where you should capture packets and decode
void Idle(void){

	

	struct pcap_pkthdr *header;
	u_char *pkt_data;
	struct tm *ltime;
	char timestr[16];
	int res;



	res = pcap_next_ex( adhandle, &header, &pkt_data);
	if(res!=1){ 
		printf("Received packet... Didn't get one\n");		
		return;
	}
	// res = 1 : read packet no problem
	// res = 0 : timeout (no packets)
	
	// temporary - just for speed issues
	/*
	memset(image->pixels,grayval++,image->components * image->height * image->width);	 
	glutPostRedisplay();
	return;
	*/
	// end temporary


	// increment packet counter
	packetcounter++;

	// convert the timestamp to readable format 
	ltime=localtime(&header->ts.tv_sec);
	strftime( timestr, sizeof timestr, "%H:%M:%S", ltime);
		
	printf("Received packet number %d\n",packetcounter);
	printf("%s,%.6d len:%d\n", timestr, header->ts.tv_usec, header->len);

	if(memcmp(pkt_data,myMAC,6)!=0){
		printf("ERROR: Ignored packet not sent to me.\n\n");
		return;
	}

	if(memcmp(pkt_data+6,fpgaMAC,6)!=0){
		printf("ERROR: Ignored packet not sent from fpga.\n\n");
		return;
	}

	u_char type = *(pkt_data+13);
	if(type==0){		// Data packet
		printf("Data packet\n");

		// copy in one row of pixels from the packet
		int bufferStart = currentRow*window_width;
		memcpy(image->pixels+bufferStart, pkt_data+14, window_width);
	
		// increment the row we're looking at
		currentRow++;
	} else {		// control packet
		printf("Control packet - VSync\n");
		// control packet means VSync
		currentRow=0;
		
		// read in the signals
		int tmp=0;

		pkt_data
		

	}


	
	// Here's where we parse the data...
	// I'm just going to display it. 
	if(pix_ptr + header->len - 12 < image->pixels + xsize*ysize*image->components){
		memcpy(pix_ptr, pkt_data+12, header->len - 12);
		pix_ptr += header->len - 12;
	}
	else {
		// Filled buffer, so display.
		pix_ptr = image->pixels;
		glutPostRedisplay();		
	}
	
}

// This displays a ramping grayscale image
/*
 void Idle(void){
	memset(image->pixels,grayval++,image->components * image->height * image->width);	 
	glutPostRedisplay();		
 }*/

int
main(int argc, char **argv)
{
	packetcounter=0;
	xstart=XSTART_INIT;
	xstop=XSTOP_INIT;
	ystart=YSTART_INIT;
	ystop=YSTOP_INIT;
	start=START_INIT;
	stop=STOP_INIT;
	currentRow=0;

	if(InitWinPcap()) return -1;

    glutInit(&argc, argv);

	// Make an empty image
	// Grayscale
	image = image_alloc (MAX_INITIAL_WINDOW_WIDTH, MAX_INITIAL_WINDOW_HEIGHT, 1);
	// RGB
	// image = image_alloc (MAX_INITIAL_WINDOW_WIDTH, MAX_INITIAL_WINDOW_HEIGHT, 3);
	memset(image->pixels, 128, image->components * image->height * image->width);
	pix_ptr = image->pixels;

	// Create window
    glutInitWindowSize(MAX_INITIAL_WINDOW_WIDTH, MAX_INITIAL_WINDOW_HEIGHT);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutCreateWindow("display");
  
	// Callbacks
    glutDisplayFunc(Redraw);
    glutKeyboardFunc(Keypress);
	glutIdleFunc(Idle);

    //glutReshapeFunc(Reshape);
    //glutMouseFunc(Mousepress);
    //glutMotionFunc(Mousemove);
		
    glutMainLoop();

    return 0;
}


//////////////

void sendControlPacketToFPGA(){
	u_char xmt_pkt_data[MAX_XMIT_LEN];
	int len=64;
	// copy source and destination addresses
	int pos=0;
	memcpy(xmt_pkt_data, fpgaMAC,6);
	pos+=6;
	memcpy(xmt_pkt_data + 6, myMAC,6);	
	pos+=6;
	xmt_pkt_data[pos++] = 0; // type/length bytes
	xmt_pkt_data[pos++] = 0;
	
	// begin data segment
	xmt_pkt_data[pos++] = 0xFF; // dummy value, to be used as marker in future?

	xmt_pkt_data[pos++] = BYTEONE(xstart);
	xmt_pkt_data[pos++] = BYTEZERO(xstart);
	xmt_pkt_data[pos++] = BYTEONE(xstop);
	xmt_pkt_data[pos++] = BYTEZERO(xstop);
	xmt_pkt_data[pos++] = BYTEONE(ystart);
	xmt_pkt_data[pos++] = BYTEZERO(ystart);
	xmt_pkt_data[pos++] = BYTEONE(ystop);
	xmt_pkt_data[pos++] = BYTEZERO(ystop);
	xmt_pkt_data[pos++] = (u_char)start;
	xmt_pkt_data[pos++] = (u_char)stop;	

	// fill up the rest of the packet to get it to minimum length
	for(;pos<len;xmt_pkt_data[pos++]=0);

	printf("Sending control packet...\n");
	// send the packet
	if (pcap_sendpacket(adhandle, xmt_pkt_data, len) != 0)	{
		fprintf(stderr,"\nError sending the control packet: \n", pcap_geterr(adhandle));
		return;
	}	
}