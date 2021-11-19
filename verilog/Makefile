
ps:
	iverilog -g2012 -o pixelSensor -c pixelSensor.fl
	vvp -n pixelSensor

psfsm:
	iverilog -g2012 -o pixelSensorFsm -c pixelSensorFsm.fl
	vvp -n pixelSensorFsm

psarr:
	iverilog -g2012 -o pixelArray -c pixelArray.fl
	vvp -n pixelArray

pstop:
	iverilog -g2012 -o pixelTop -c pixelTop.fl
	vvp -n pixelTop

ysarr: synth1
	dot pixelArray.dot -Tpng > pixelArray.png

synth1:
	yosys pixelArray.ys

ysTop: synth2
	dot pixelTop.dot -Tpng > pixelTop.png

synth2:
	yosys pixelTop.ys


ysfsm: synth
	dot pixelSensorFsm.dot -Tpng > pixelSensorFsm.png

synth:
	yosys pixelSensorFsm.ys


test: ps psfsm synth
