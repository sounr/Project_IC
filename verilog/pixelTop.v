`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2021 01:43:25
// Design Name: 
// Module Name: pixelTop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//TODO:  FIX PIXEL TOP > ADD SHIFT REGISTER > WRITE TO FILE > READ FROM FILE + WRITE TO PIXEL ARRAY/SENSORS
module pixelTop #(parameter rows = 2, parameter columns = 2, parameter c_read = rows, parameter dv_pixel = 0.01)
(
    input logic clk,
    input logic reset,
    output logic [rows*8-1:0]pixelDataOut,
    output logic read,
    output logic [rows-1:0]readArray
    );
//analog signals    
   logic                        anaBias1;
   logic                        anaRamp;
//   logic                        reset;

   //Digital
   logic                        erase;
   logic                        expose;
   //logic                        read;
   //logic [rows-1:0]             readArray;
   logic                        convert;
   wire [8*columns - 1:0]         DATA; //  We need this to be a wire, because we're tristating it   

   pixelArray #(.rows(rows), .columns(columns)) pa1(
        .VBN1(anaBias1),
        .RAMP(anaRamp), 
        .RESET(reset), 
        .erase(erase), 
        .expose(expose), 
        .convert(convert), 
        .DATA(DATA),
        .readArray(readArray)
        );    

   pixelSensorFsm #(.rows(rows), .columns(columns), .c_read(c_read)) fsm1(
        .clk(clk),
        .reset(reset),
        .erase(erase),
        .expose(expose),
        .read(read),
        .convert(convert),
        .readArray(readArray));
        
        
    int     i;
        
   //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
   logic[(8*rows)-1:0] data;

   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   assign DATA = read ? 2048'bZ: data;


int                digRamp; 
   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus. Assert convert_stop to return control to main state machine.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data = 0;
      end
      if(convert) begin
        digRamp = digRamp +  1;
        for(i = 0; i<rows; i++)begin
            data[(8*i) +:8] =  digRamp;
        end
      end
      else begin
         data = 0;
      end
   end // always @ (posedge clk or reset)
   
   /////////////////////////////////

   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut = 0;
      end
      else begin
         if(read)
           pixelDataOut <= DATA;
      end
   end
     
endmodule
