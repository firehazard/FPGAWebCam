#ChipScope Core Inserter Project File Version 3.0
#Thu Feb 10 02:06:23 PST 2005
Project.device.designInputFile=z\:\\2\\lab2hw\\temac\\temac1_top.ngc
Project.device.designOutputFile=z\:\\2\\lab2hw\\temac\\temac1_top.ngc
Project.device.deviceFamily=3
Project.device.enableRPMs=true
Project.device.outputDirectory=z\:\\2\\lab2hw\\temac\\_ngo
Project.device.useSRL16=true
Project.filter.dimension=19
Project.filter<0>=*fifo*write*
Project.filter<10>=*gmii*er*
Project.filter<11>=*gmii*dv*
Project.filter<12>=*gmii*clk*
Project.filter<13>=*gmii*rx*
Project.filter<14>=*gmii*rx*clk*
Project.filter<15>=*gmii*rx*dv
Project.filter<16>=*gmii*
Project.filter<17>=*rx*
Project.filter<18>=*rx*val*
Project.filter<1>=*rx*data*
Project.filter<2>=*rx*clk*
Project.filter<3>=*pccamvalid*
Project.filter<4>=
Project.filter<5>=*fifowrite*
Project.filter<6>=*pccamdata*
Project.filter<7>=*start*
Project.filter<8>=*hstart*
Project.filter<9>=*camclk*
Project.icon.boundaryScanChain=0
Project.icon.disableBUFGInsertion=false
Project.icon.enableExtTriggerIn=false
Project.icon.enableExtTriggerOut=false
Project.icon.triggerInPinName=
Project.icon.triggerOutPinName=
Project.unit.dimension=3
Project.unit<0>.clockChannel=rx_clk_int
Project.unit<0>.clockEdge=Rising
Project.unit<0>.dataChannel<0>=rx_data_int<0>
Project.unit<0>.dataChannel<1>=rx_data_int<1>
Project.unit<0>.dataChannel<2>=rx_data_int<2>
Project.unit<0>.dataChannel<3>=rx_data_int<3>
Project.unit<0>.dataChannel<4>=rx_data_int<4>
Project.unit<0>.dataChannel<5>=rx_data_int<5>
Project.unit<0>.dataChannel<6>=rx_data_int<6>
Project.unit<0>.dataChannel<7>=rx_data_int<7>
Project.unit<0>.dataChannel<8>=rx_data_valid_int
Project.unit<0>.dataChannel<9>=rx_clk_int
Project.unit<0>.dataDepth=4096
Project.unit<0>.dataEqualsTrigger=true
Project.unit<0>.dataPortWidth=10
Project.unit<0>.enableGaps=false
Project.unit<0>.enableStorageQualification=true
Project.unit<0>.enableTimestamps=false
Project.unit<0>.timestampDepth=0
Project.unit<0>.timestampWidth=0
Project.unit<0>.triggerChannel<0><0>=camera_incoming_fifowriteen
Project.unit<0>.triggerChannel<0><10>=rx_clk_int
Project.unit<0>.triggerChannel<0><11>=
Project.unit<0>.triggerChannel<0><12>=
Project.unit<0>.triggerChannel<0><13>=
Project.unit<0>.triggerChannel<0><14>=
Project.unit<0>.triggerChannel<0><15>=
Project.unit<0>.triggerChannel<0><16>=
Project.unit<0>.triggerChannel<0><17>=
Project.unit<0>.triggerChannel<0><18>=
Project.unit<0>.triggerChannel<0><19>=
Project.unit<0>.triggerChannel<0><1>=rx_data_valid_int
Project.unit<0>.triggerChannel<0><2>=rx_data_int<0>
Project.unit<0>.triggerChannel<0><3>=rx_data_int<1>
Project.unit<0>.triggerChannel<0><4>=rx_data_int<2>
Project.unit<0>.triggerChannel<0><5>=rx_data_int<3>
Project.unit<0>.triggerChannel<0><6>=rx_data_int<4>
Project.unit<0>.triggerChannel<0><7>=rx_data_int<5>
Project.unit<0>.triggerChannel<0><8>=rx_data_int<6>
Project.unit<0>.triggerChannel<0><9>=rx_data_int<7>
Project.unit<0>.triggerConditionCountWidth=0
Project.unit<0>.triggerMatchCount<0>=1
Project.unit<0>.triggerMatchCountWidth<0><0>=0
Project.unit<0>.triggerMatchType<0><0>=1
Project.unit<0>.triggerPortCount=1
Project.unit<0>.triggerPortIsData<0>=true
Project.unit<0>.triggerPortWidth<0>=11
Project.unit<0>.triggerSequencerLevels=16
Project.unit<0>.triggerSequencerType=1
Project.unit<0>.type=ilapro
Project.unit<1>.clockChannel=gmii_rx_clk_bufg
Project.unit<1>.clockEdge=Rising
Project.unit<1>.dataChannel<0>=gmii_rx_clk_bufg
Project.unit<1>.dataChannel<10>=gmii_rx_er_reg
Project.unit<1>.dataChannel<1>=gmii_rx_dv_reg
Project.unit<1>.dataChannel<2>=gmii_rxd_reg<0>
Project.unit<1>.dataChannel<3>=gmii_rxd_reg<1>
Project.unit<1>.dataChannel<4>=gmii_rxd_reg<2>
Project.unit<1>.dataChannel<5>=gmii_rxd_reg<3>
Project.unit<1>.dataChannel<6>=gmii_rxd_reg<4>
Project.unit<1>.dataChannel<7>=gmii_rxd_reg<5>
Project.unit<1>.dataChannel<8>=gmii_rxd_reg<6>
Project.unit<1>.dataChannel<9>=gmii_rxd_reg<7>
Project.unit<1>.dataDepth=4096
Project.unit<1>.dataEqualsTrigger=true
Project.unit<1>.dataPortWidth=11
Project.unit<1>.enableGaps=false
Project.unit<1>.enableStorageQualification=true
Project.unit<1>.enableTimestamps=false
Project.unit<1>.timestampDepth=0
Project.unit<1>.timestampWidth=0
Project.unit<1>.triggerChannel<0><0>=gmii_rx_clk_bufg
Project.unit<1>.triggerChannel<0><10>=gmii_rx_er_reg
Project.unit<1>.triggerChannel<0><1>=gmii_rx_dv_reg
Project.unit<1>.triggerChannel<0><2>=gmii_rxd_reg<0>
Project.unit<1>.triggerChannel<0><3>=gmii_rxd_reg<1>
Project.unit<1>.triggerChannel<0><4>=gmii_rxd_reg<2>
Project.unit<1>.triggerChannel<0><5>=gmii_rxd_reg<3>
Project.unit<1>.triggerChannel<0><6>=gmii_rxd_reg<4>
Project.unit<1>.triggerChannel<0><7>=gmii_rxd_reg<5>
Project.unit<1>.triggerChannel<0><8>=gmii_rxd_reg<6>
Project.unit<1>.triggerChannel<0><9>=gmii_rxd_reg<7>
Project.unit<1>.triggerConditionCountWidth=0
Project.unit<1>.triggerMatchCount<0>=1
Project.unit<1>.triggerMatchCountWidth<0><0>=0
Project.unit<1>.triggerMatchType<0><0>=1
Project.unit<1>.triggerPortCount=1
Project.unit<1>.triggerPortIsData<0>=true
Project.unit<1>.triggerPortWidth<0>=11
Project.unit<1>.triggerSequencerLevels=16
Project.unit<1>.triggerSequencerType=1
Project.unit<1>.type=ilapro
Project.unit<2>.clockChannel=camclk
Project.unit<2>.clockEdge=Rising
Project.unit<2>.dataChannel<0>=camera_pccamdata<0>
Project.unit<2>.dataChannel<1>=camera_pccamdata<1>
Project.unit<2>.dataChannel<2>=camera_pccamdata<2>
Project.unit<2>.dataChannel<3>=camera_pccamdata<3>
Project.unit<2>.dataChannel<4>=camera_pccamdata<4>
Project.unit<2>.dataChannel<5>=camera_pccamdata<5>
Project.unit<2>.dataChannel<6>=camera_pccamdata<6>
Project.unit<2>.dataChannel<7>=camera_pccamdata<7>
Project.unit<2>.dataChannel<8>=camera_incoming_fifowriteen
Project.unit<2>.dataDepth=8192
Project.unit<2>.dataEqualsTrigger=true
Project.unit<2>.dataPortWidth=9
Project.unit<2>.enableGaps=false
Project.unit<2>.enableStorageQualification=true
Project.unit<2>.enableTimestamps=false
Project.unit<2>.timestampDepth=0
Project.unit<2>.timestampWidth=0
Project.unit<2>.triggerChannel<0><0>=camera_pccamdata<0>
Project.unit<2>.triggerChannel<0><1>=camera_pccamdata<1>
Project.unit<2>.triggerChannel<0><2>=camera_pccamdata<2>
Project.unit<2>.triggerChannel<0><3>=camera_pccamdata<3>
Project.unit<2>.triggerChannel<0><4>=camera_pccamdata<4>
Project.unit<2>.triggerChannel<0><5>=camera_pccamdata<5>
Project.unit<2>.triggerChannel<0><6>=camera_pccamdata<6>
Project.unit<2>.triggerChannel<0><7>=camera_pccamdata<7>
Project.unit<2>.triggerChannel<0><8>=camera_pccamvalid
Project.unit<2>.triggerConditionCountWidth=0
Project.unit<2>.triggerMatchCount<0>=1
Project.unit<2>.triggerMatchCountWidth<0><0>=0
Project.unit<2>.triggerMatchType<0><0>=1
Project.unit<2>.triggerPortCount=1
Project.unit<2>.triggerPortIsData<0>=true
Project.unit<2>.triggerPortWidth<0>=9
Project.unit<2>.triggerSequencerLevels=16
Project.unit<2>.triggerSequencerType=1
Project.unit<2>.type=ilapro