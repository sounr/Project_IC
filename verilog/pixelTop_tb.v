`timescale 1ns / 1ps

module pixelTop_tb;
   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic clk =0;
   logic reset =0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;
   
   logic [7:0]TIFF_header[133:0];

   //------------------------------------------------------------
   // Pixel
   //------------------------------------------------------------
   parameter real    dv_pixel = 0;  //Set the expected photodiode current (0-1)
   parameter integer rows = 256;          // Number of rows
   parameter integer columns = 256;       // Number of columns
   parameter integer c_read = rows;
   parameter OUTFILE = "output.tiff";
   
   //File location for output C:\project_IC\project_IC.sim\sim_1\behav\xsim
    
    tri[8*columns - 1:0]        pixelDataOut;
    logic [rows-1:0]            readArray;
    
   //Instanciate the pixel array
      pixelTop #(.rows(rows), .columns(columns), .c_read(c_read)) pa1(
        .clk(clk),
        .reset(reset), 
        .pixelDataOut(pixelDataOut),
        .read(read),
        .readArray(readArray)
        );   
    //
    integer i = 0; 
    integer fd;
    
    always@(negedge clk) begin
        if (readArray !== 0) begin
            for(i = 0; i<rows; i=i+1)begin
                $fwrite(fd, "%c", pixelDataOut[(8*i) +:8]);
            end
       end
    end
   
    always@(read) begin
    if (read == 'b1)begin
    
        fd = $fopen(OUTFILE, "wb");
        if (fd) $display("file was opened successfully : %0d", fd);
        else    $display("file was NOT opened successfully : %0d", fd);
        for(i=0; i<8; i++) begin
            $fwrite(fd, "%c", TIFF_header[i][7:0]);      // write the header
            //$fwrite(fd, "%b ", TIFF_header[i+1][7:0]);
        end
    end
    else if (read == 'b0) begin  
        for(i=8; i<134; i++) begin
            $fwrite(fd, "%c", TIFF_header[i][7:0]);      // write the header
        end
        $fclose(fd);
    end 
    end
    
//TODO: READ from file => to register => in pixelArray Generate register for pv_pixel, convert this value to decimal and divide on 256
//      read file in pixelArray when reset is high
   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------

   initial
     begin
    TIFF_header[ 0] = 'h4d;
    TIFF_header[ 1] = 'h4d;
    TIFF_header[ 2] = 'h00;
    TIFF_header[ 3] = 'h2a;
    TIFF_header[ 4] = 'h00;
    TIFF_header[ 5] = 'h01;
    TIFF_header[ 6] = 'h00;
    TIFF_header[ 7] = 'h08;
    
    TIFF_header[ 8] = 'h00; TIFF_header[ 9] = 'h0a; TIFF_header[10] = 'h00; TIFF_header[11] = 'hfe;
    TIFF_header[12] = 'h00; TIFF_header[13] = 'h04; TIFF_header[14] = 'h00; TIFF_header[15] = 'h00;
    TIFF_header[16] = 'h00; TIFF_header[17] = 'h01; TIFF_header[18] = 'h00; TIFF_header[19] = 'h00;
    TIFF_header[20] = 'h00; TIFF_header[21] = 'h00; TIFF_header[22] = 'h01; TIFF_header[23] = 'h00; 
    TIFF_header[24] = 'h00; TIFF_header[25] = 'h03;

    TIFF_header[26] = 'h00; TIFF_header[27] = 'h00; TIFF_header[28] = 'h00; TIFF_header[29] = 'h01;
    TIFF_header[30] = 'h01; TIFF_header[31] = 'h00; TIFF_header[32] = 'h00; TIFF_header[33] = 'h00;
    TIFF_header[34] = 'h01; TIFF_header[35] = 'h01; TIFF_header[36] = 'h00; TIFF_header[37] = 'h03;
    TIFF_header[38] = 'h00; TIFF_header[39] = 'h00; TIFF_header[40] = 'h00; TIFF_header[41] = 'h01;
    TIFF_header[42] = 'h01; TIFF_header[43] = 'h00;

    TIFF_header[44] = 'h00; TIFF_header[45] = 'h00; TIFF_header[46] = 'h01; TIFF_header[47] = 'h02;
    TIFF_header[48] = 'h00; TIFF_header[49] = 'h03; TIFF_header[50] = 'h00; TIFF_header[51] = 'h00;
    TIFF_header[52] = 'h00; TIFF_header[53] = 'h01; TIFF_header[54] = 'h00; TIFF_header[55] = 'h08;
    TIFF_header[56] = 'h00; TIFF_header[57] = 'h00; TIFF_header[58] = 'h01; TIFF_header[59] = 'h03;
    TIFF_header[60] = 'h00; TIFF_header[61] = 'h03;
    
    TIFF_header[62] = 'h00; TIFF_header[63] = 'h00; TIFF_header[64] = 'h00; TIFF_header[65] = 'h01;
    TIFF_header[66] = 'h00; TIFF_header[67] = 'h01; TIFF_header[68] = 'h00; TIFF_header[69] = 'h00;
    TIFF_header[70] = 'h01; TIFF_header[71] = 'h06; TIFF_header[72] = 'h00; TIFF_header[73] = 'h03;
    TIFF_header[74] = 'h00; TIFF_header[75] = 'h00; TIFF_header[76] = 'h00; TIFF_header[77] = 'h01;
    TIFF_header[78] = 'h00; TIFF_header[79] = 'h01;
     
    TIFF_header[80] = 'h00; TIFF_header[81] = 'h00; TIFF_header[82] = 'h01; TIFF_header[83] = 'h11;
    TIFF_header[84] = 'h00; TIFF_header[85] = 'h04; TIFF_header[86] = 'h00; TIFF_header[87] = 'h00;
    TIFF_header[88] = 'h00; TIFF_header[89] = 'h01; TIFF_header[90] = 'h00; TIFF_header[91] = 'h00;
    TIFF_header[92] = 'h00; TIFF_header[93] = 'h08; TIFF_header[94] = 'h01; TIFF_header[95] = 'h15;
    TIFF_header[96] = 'h00; TIFF_header[97] = 'h03;
      
    TIFF_header[98] = 'h00; TIFF_header[99] = 'h00; TIFF_header[100] = 'h00; TIFF_header[101] = 'h01;
    TIFF_header[102] = 'h00; TIFF_header[103] = 'h01; TIFF_header[104] = 'h00; TIFF_header[105] = 'h00;
    TIFF_header[106] = 'h01; TIFF_header[107] = 'h17; TIFF_header[108] = 'h00; TIFF_header[109] = 'h04;
    TIFF_header[110] = 'h00; TIFF_header[111] = 'h00; TIFF_header[112] = 'h00; TIFF_header[113] = 'h01;
    TIFF_header[114] = 'h00; TIFF_header[115] = 'h01;
       
    TIFF_header[116] = 'h00; TIFF_header[117] = 'h00; TIFF_header[118] = 'h01; TIFF_header[119] = 'h1c;
    TIFF_header[120] = 'h00; TIFF_header[121] = 'h03; TIFF_header[122] = 'h00; TIFF_header[123] = 'h00;
    TIFF_header[124] = 'h00; TIFF_header[125] = 'h01; TIFF_header[126] = 'h00; TIFF_header[127] = 'h01; 
    TIFF_header[128] = 'h00; TIFF_header[129] = 'h00; TIFF_header[130] = 'h00; TIFF_header[131] = 'h00;
    TIFF_header[132] = 'h00; TIFF_header[133] = 'h00;
    
       
        
        reset = 1;

        #clk_period  reset=0;
        
        $dumpfile("pixelTop_tb.vcd");
        $dumpvars(0,pixelTop_tb);
        
        #sim_end
            
          $stop;
          


     end
endmodule
