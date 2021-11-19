`timescale 1ns / 1ps

module pixelArray_tb;
   //------------------------------------------------------------
   // Testbench clock & reset
   //------------------------------------------------------------
   logic clk =0;
   logic reset =0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;

   //------------------------------------------------------------
   // Pixel
   //------------------------------------------------------------
   parameter real    dv_pixel = 1;  //Set the expected photodiode current (0-1)
   parameter integer rows = 2;          // Number of rows
   parameter integer columns = 2;       // Number of columns
    
   //Analog signals
   logic                        anaBias1;
   logic                        anaRamp;
// logic                        reset;

   //Digital
   logic                        erase;
   logic                        expose;
   logic                        read;
   logic [rows-1:0]             readArray;
   logic                        convert;
   tri[8*columns - 1:0]         DATA; //  We need this to be a wire, because we're tristating it   

   //Instanciate the pixel array
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
   //------------------------------------------------------------
   // State Machine
   //------------------------------------------------------------
   parameter ERASE=0, EXPOSE=1, CONVERT=2, READ=3, IDLE=4;


   logic [2:0]         state, next_state;   //States
   integer             counter;             //Delay counter in state machine
   bit [1:0]           Row_number;

   //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read = rows-1;
   

// Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read <= 0;
          readArray <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read <= 0;
         readArray <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           read <= 0;
           readArray <= 0;
           expose <= 0;
           convert = 1;
        end
        READ: begin
           erase <= 0;
           read <= 1;
           if (readArray == 0)begin
                readArray <= 1;
                Row_number = 0;
           end
           else begin
                readArray <= (1 << Row_number);      //Rightshift operation of row
           end
           /*if (counter < 10 )begin
           readArray <= 01;      //Rightshift operation of row
           end
           else begin
           readArray <= 10;
           end*/
           expose <= 0;
           convert <= 0;
        end
        IDLE: begin
           erase <= 0;
           read <= 0;
           readArray <= 0;
           expose <= 0;
           convert <= 0;

        end
      endcase // case (state)
   end // always @ (state)


   // Control the state transitions.
   //TODO: The counter should probably be an always_comb. Might be a good idea
   //to also reset the counter from the state machine, i.e provide the count
   //down value, and trigger on 0
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                 next_state <= READ;
                 state <= IDLE;
              end
           end
           READ: begin
             Row_number += 1;               //increments row reading by one each clock
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
                //Row_number = 0;
             end
           end
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)

   //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
   logic[7+8*(rows-1):0] data;

   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   assign DATA = read ? 16'bZ: data;


byte                digRamp; 
   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus. Assert convert_stop to return control to main state machine.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data = 0;
      end
      if(convert) begin
        digRamp +=  1;

        data[7:0] =  digRamp;
        data[15:8] =  digRamp;
      end
      else begin
         data = 0;
      end
   end // always @ (posedge clk or reset)
   
   /////////////////////////////////
      logic [15:0] pixelDataOut;
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut = 0;
      end
      else begin
         if(read)
           pixelDataOut <= DATA;
      end
   end

   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   initial
     begin
        reset = 1;

        #clk_period  reset=0;

        $dumpfile("pixelArray_tb.vcd");
        $dumpvars(0,pixelArray_tb);

        #sim_end
          $stop;


     end
endmodule
