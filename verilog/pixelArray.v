//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : yo at 2021-7-21
// ===================================================================
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//====================================================================


`timescale 1 ns / 1 ps

//====================================================================
// Testbench for pixelSensor
// - clock
// - instanciate pixel
// - State Machine for controlling pixel sensor
// - Model the ADC and ADC
// - Readout of the databus
// - Stuff neded for testbench. Store the output file etc.
//====================================================================

module pixelArray #(parameter rows = 2, 
                    parameter columns = 2, 
                    parameter dv_pixel = 0.01)                   
(
                  input logic               VBN1,
                  input logic               RAMP,
                  input logic               RESET,
                  input logic               erase,
                  input logic               expose,
                  input logic               convert,
                  inout [8*columns-1:0]     DATA,
                  input logic [rows-1:0]    readArray
                      );
genvar     i;
genvar     j;
//0.25
generate
    for(i = 0; i < rows; i++) begin : row
        for(j = 0; j < columns; j++) begin : column
            PIXEL_SENSOR #(.dv_pixel(dv_pixel + 0.00195*(j+i))) ps(VBN1, RAMP, RESET, erase, expose, readArray[i], DATA[7 + 8*j:8*j]);
        end
    end
endgenerate
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////
////Reading picture
/////////////////////////////////////////////////////////////////////////////////////////////////
////Parameters
//parameter INFILE = "C:/project_IC/project_IC.sim/sim_1/behav/xsim/infile.tiff",
//parameter sizeOfLengthReal = 65536)    // image data : 65536 bytes: 256 * 256 
////Variables and register
//integer fd;
//integer temp_TIFF   [0 : rows*columns - 1]; 
//logic [7:0] dv_pixel[rows*columns-1:0];
//logic [7 : 0]   picture_mem [0 : sizeOfLengthReal-1];// memory to store  8-bit data image

//int file,c,n,m,i;
//string filename;
//int      q[$];
                    



////Reading from file and writing to packed dv_pixel : add to generate:  dv_pixel[columns*i+j-1]
//always@(RESET) begin
//    if (RESET == 'b1)begin
////        fd = $fopen(INFILE, "r");
////        if (fd) $display("file was opened successfully (input): %0d", fd);
////        else    $display("file was NOT opened successfully (input): %0d", fd);
////        $readmemb(INFILE,picture_mem,0,sizeOfLengthReal-1); // read file from INFILE
//        file = $fopen(INFILE,"r");
//        //while (!$feof(file)) begin
//        for(i=0; i<((256*256)+100) ; i++)begin
//            c = $fgetc(file);
//            //if (c != " " && c != "\n") begin
//                q.push_back(c);
//                //$display(" %0dth Char is = %s ",i++,c);
//            //end
//        end 
 
//        foreach (q[i]) $display ("q[%0d] = %h",i,q[i]);
        
////        for(i=8; i<((rows*columns)+8) ; i++) begin
////            temp_TIFF[i] = picture_mem[i][7:0]; 
////            //$fwrite(dv_pixel[i], "%b", fd);
////            $display(dv_pixel[i], "%h", fd);
////            $fread(fd, "%c", dv_pixel[(8*i) +:8]);
////        end
        
        
        
//        for(i=0; i<rows; i=i+1) begin
//            for(j=0; j<columns; j=j+1) begin
//                //$fwrite(dv_pixel[columns*i+j-1], "%b", fd);
//                dv_pixel[columns*i+j] = q[columns*(rows-i-1)+j+8];
//                //$display ("q[%0d] = %s ",i,dv_pixel[i]);
//            end
//        end
//        $fclose(file);
//    end
//end
    
//


//Instanciate the pixelArray

/*
PIXEL_SENSOR   ps00(VBN1, RAMP, RESET, erase, expose, readArray[0], DATA[7 downto 0]);
PIXEL_SENSOR   ps01(VBN1, RAMP, RESET, erase, expose, readArray[0], DATA[15 downto 8]);
PIXEL_SENSOR   ps10(VBN1, RAMP, RESET, erase, expose, readArray[1], DATA[7 downto 0]);
PIXEL_SENSOR   ps11(VBN1, RAMP, RESET, erase, expose, readArray[1], DATA[15 downto 8]);
*/

/*
data out look at column 1 data 0...1...n
...
data out look at column n data 0...1...n
*/

