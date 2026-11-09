module top_music_box(
    input clk,
    input button_power, // S1 Butonu (Pin 3) - Çal / Durdur
    input button_next,  // S2 Butonu (Pin 4) - Sonraki Şarkı
    output buzzer_out  
);

    reg [31:0] duration_counter = 0;
    wire next_note_sig = (duration_counter >= 6750000);

    reg [7:0] note_index = 0;
    reg [4:0] song_select = 0;
    
    reg is_playing = 1; // Cihaz açıldığında şarkı otomatik çalmaya başlasın
    
    reg btn_power_prev = 1;
    reg btn_next_prev = 1;
    reg [23:0] debounce_counter_power = 0;
    reg [23:0] debounce_counter_next = 0;
    
    reg [31:0] clk_counter = 0;
    reg buzzer_state = 0;

    always @(posedge clk) begin
        // --- 1. BUTON: AÇ/KAPA (PLAY/PAUSE) MANTIĞI ---
        if (debounce_counter_power > 0) begin
            debounce_counter_power <= debounce_counter_power - 1;
        end else begin
            if (button_power == 0 && btn_power_prev == 1) begin
                is_playing <= ~is_playing; // Çalıyorsa durdur, duruyorsa çal
                debounce_counter_power <= 24'h1FFFFF; 
            end
            btn_power_prev <= button_power;
        end

        // --- 2. BUTON: ŞARKI DEĞİŞTİRME MANTIĞI ---
        if (debounce_counter_next > 0) begin
            debounce_counter_next <= debounce_counter_next - 1;
        end else begin
            if (button_next == 0 && btn_next_prev == 1) begin
                if (song_select >= 15) 
                    song_select <= 0;
                else
                    song_select <= song_select + 1;
                
                note_index <= 0;
                duration_counter <= 0;
                is_playing <= 1; // Şarkı değişince sessizdeyse bile çalmaya başlasın
                debounce_counter_next <= 24'h1FFFFF;
            end
            btn_next_prev <= button_next;
        end
        
        // --- NOTA İLERLEME (Sadece is_playing 1 ise ilerler) ---
        if (is_playing) begin
            if (next_note_sig) begin
                duration_counter <= 0;
                
                if (note_index >= 85)
                    note_index <= 0;
                else
                    note_index <= note_index + 1;
            end else begin
                duration_counter <= duration_counter + 1;
            end
        end
    end

    reg [15:0] active_frequency;

    always @(*) begin
        case (song_select)
            0: begin
                case (note_index)
                    0: active_frequency = 392;
                    1: active_frequency = 0;
                    2: active_frequency = 392;
                    3, 4, 5: active_frequency = 440;
                    6: active_frequency = 0;
                    7, 8, 9: active_frequency = 392;
                    10: active_frequency = 0;
                    11, 12, 13: active_frequency = 523;
                    14: active_frequency = 0;
                    15, 16, 17, 18, 19: active_frequency = 494;
                    20, 21: active_frequency = 0;
                    22: active_frequency = 392;
                    23: active_frequency = 0;
                    24: active_frequency = 392;
                    25, 26, 27: active_frequency = 440;
                    28: active_frequency = 0;
                    29, 30, 31: active_frequency = 392;
                    32: active_frequency = 0;
                    33, 34, 35: active_frequency = 587;
                    36: active_frequency = 0;
                    37, 38, 39, 40, 41: active_frequency = 523;
                    42, 43: active_frequency = 0;
                    44: active_frequency = 392;
                    45: active_frequency = 0;
                    46: active_frequency = 392;
                    47, 48, 49: active_frequency = 784;
                    50: active_frequency = 0;
                    51, 52, 53: active_frequency = 659;
                    54: active_frequency = 0;
                    55, 56, 57: active_frequency = 523;
                    58: active_frequency = 0;
                    59, 60: active_frequency = 494;
                    61: active_frequency = 0;
                    62, 63: active_frequency = 440;
                    64, 65: active_frequency = 0;
                    66: active_frequency = 698;
                    67: active_frequency = 0;
                    68: active_frequency = 698;
                    69, 70, 71: active_frequency = 659;
                    72: active_frequency = 0;
                    73, 74, 75: active_frequency = 523;
                    76: active_frequency = 0;
                    77, 78, 79: active_frequency = 587;
                    80: active_frequency = 0;
                    81, 82, 83, 84, 85: active_frequency = 523;
                    default: active_frequency = 0;
                endcase
            end
            
            1: begin
                case (note_index)
                    0, 1, 2, 3: active_frequency = 392;
                    4: active_frequency = 0;
                    5, 6, 7, 8: active_frequency = 392;
                    9: active_frequency = 0;
                    10, 11, 12, 13: active_frequency = 392;
                    14: active_frequency = 0;
                    15, 16, 17: active_frequency = 311;
                    18: active_frequency = 0;
                    19, 20: active_frequency = 466;
                    21, 22, 23, 24: active_frequency = 392;
                    25: active_frequency = 0;
                    26, 27, 28: active_frequency = 311;
                    29: active_frequency = 0;
                    30, 31: active_frequency = 466;
                    32, 33, 34, 35, 36, 37: active_frequency = 392;
                    38, 39: active_frequency = 0;
                    40, 41, 42, 43: active_frequency = 587;
                    44: active_frequency = 0;
                    45, 46, 47, 48: active_frequency = 587;
                    49: active_frequency = 0;
                    50, 51, 52, 53: active_frequency = 587;
                    54: active_frequency = 0;
                    55, 56, 57: active_frequency = 622;
                    58: active_frequency = 0;
                    59, 60: active_frequency = 466;
                    61, 62, 63, 64: active_frequency = 370;
                    65: active_frequency = 0;
                    66, 67, 68: active_frequency = 311;
                    69: active_frequency = 0;
                    70, 71: active_frequency = 466;
                    72, 73, 74, 75, 76, 77: active_frequency = 392;
                    78, 79, 80, 81, 82, 83, 84, 85: active_frequency = 0;
                    default: active_frequency = 0;
                endcase
            end
            
            2: begin
                case (note_index)
                    0, 1, 2: active_frequency = 494;
                    3: active_frequency = 0;
                    4, 5, 6: active_frequency = 659;
                    7: active_frequency = 0;
                    8, 9: active_frequency = 784;
                    10: active_frequency = 0;
                    11, 12, 13: active_frequency = 740;
                    14: active_frequency = 0;
                    15, 16, 17, 18, 19: active_frequency = 659;
                    20: active_frequency = 0;
                    21, 22, 23: active_frequency = 988;
                    24: active_frequency = 0;
                    25, 26, 27, 28, 29, 30, 31: active_frequency = 880;
                    32: active_frequency = 0;
                    33, 34, 35, 36, 37, 38, 39: active_frequency = 740;
                    40: active_frequency = 0;
                    41, 42, 43: active_frequency = 659;
                    44: active_frequency = 0;
                    45, 46: active_frequency = 784;
                    47: active_frequency = 0;
                    48, 49, 50: active_frequency = 740;
                    51: active_frequency = 0;
                    52, 53, 54, 55, 56: active_frequency = 622;
                    57: active_frequency = 0;
                    58, 59, 60: active_frequency = 698;
                    61: active_frequency = 0;
                    62, 63, 64, 65, 66, 67, 68, 69: active_frequency = 494;
                    70, 71, 72: active_frequency = 0;
                    73, 74, 75: active_frequency = 494;
                    76: active_frequency = 0;
                    77, 78, 79: active_frequency = 659;
                    80: active_frequency = 0;
                    81, 82: active_frequency = 784;
                    83: active_frequency = 0;
                    84, 85: active_frequency = 740;
                    default: active_frequency = 0;
                endcase
            end
            
            3: begin 
                case (note_index)
                    0, 1: active_frequency = 294; 
                    2: active_frequency = 0;
                    3, 4: active_frequency = 392; 
                    5: active_frequency = 0;
                    6, 7: active_frequency = 440; 
                    8: active_frequency = 0;
                    9, 10, 11, 12: active_frequency = 466; 
                    13: active_frequency = 0;
                    14, 15, 16, 17: active_frequency = 587; 
                    18: active_frequency = 0;
                    19, 20: active_frequency = 523;  
                    21: active_frequency = 0;
                    22, 23: active_frequency = 466; 
                    24: active_frequency = 0;
                    25, 26, 27, 28: active_frequency = 440; 
                    29: active_frequency = 0;
                    30, 31: active_frequency = 466; 
                    32: active_frequency = 0;
                    33, 34, 35, 36: active_frequency = 392; 
                    37: active_frequency = 0;
                    38, 39: active_frequency = 466; 
                    40: active_frequency = 0;
                    41, 42: active_frequency = 440;
                    43: active_frequency = 0;
                    44, 45: active_frequency = 392; 
                    46: active_frequency = 0;
                    47, 48, 49, 50: active_frequency = 370;
                    51: active_frequency = 0;
                    52, 53: active_frequency = 392; 
                    54: active_frequency = 0;
                    55, 56, 57, 58, 59: active_frequency = 294;
                    60, 61: active_frequency = 0;
                    62, 63: active_frequency = 392;
                    64: active_frequency = 0;
                    65, 66: active_frequency = 440;
                    67: active_frequency = 0;
                    68, 69, 70, 71: active_frequency = 466;
                    72: active_frequency = 0;
                    73, 74, 75, 76: active_frequency = 587; 
                    77: active_frequency = 0;
                    78, 79, 80, 81: active_frequency = 698;
                    82: active_frequency = 0;
                    83, 84, 85: active_frequency = 622; 
                    default: active_frequency = 0;
                endcase
            end   
            
            4: begin
                case (note_index)
                    0: active_frequency = 494;   
                    1: active_frequency = 466;   
                    2: active_frequency = 494;   
                    3: active_frequency = 554;   
                    4: active_frequency = 494;   
                    5: active_frequency = 466;   
                    6, 7: active_frequency = 370; 
                    8, 9: active_frequency = 330; 
                    10, 11: active_frequency = 311; 
                    12, 13: active_frequency = 330; 
                    14, 15: active_frequency = 0;   
                    16: active_frequency = 494;  
                    17: active_frequency = 466;  
                    18: active_frequency = 494;  
                    19: active_frequency = 554;  
                    20: active_frequency = 494;  
                    21: active_frequency = 466;  
                    22, 23: active_frequency = 370; 
                    24, 25: active_frequency = 330; 
                    26, 27: active_frequency = 311; 
                    28, 29: active_frequency = 330; 
                    30, 31: active_frequency = 0;   
                    32: active_frequency = 659;  
                    33: active_frequency = 622;  
                    34: active_frequency = 659;  
                    35: active_frequency = 740;  
                    36: active_frequency = 659;  
                    37: active_frequency = 622;  
                    38, 39: active_frequency = 523; 
                    40, 41: active_frequency = 494; 
                    42, 43: active_frequency = 440; 
                    44, 45: active_frequency = 494; 
                    46, 47: active_frequency = 0;   
                    48: active_frequency = 494;  
                    49: active_frequency = 466;  
                    50: active_frequency = 494;  
                    51: active_frequency = 554;  
                    52: active_frequency = 494;  
                    53: active_frequency = 466;  
                    54, 55: active_frequency = 370; 
                    56, 57: active_frequency = 330; 
                    58, 59: active_frequency = 311; 
                    60, 61: active_frequency = 330; 
                    62, 63: active_frequency = 0;   
                    64, 65, 66: active_frequency = 494; 
                    67: active_frequency = 0;           
                    68, 69, 70: active_frequency = 554; 
                    71: active_frequency = 0;           
                    72, 73, 74, 75: active_frequency = 659; 
                    76, 77, 78: active_frequency = 622; 
                    79: active_frequency = 0;           
                    80, 81, 82, 83, 84, 85: active_frequency = 494;  
                    default: active_frequency = 0;
                endcase
            end
            
            5: begin
                case (note_index)
                    0, 1, 2: active_frequency = 294; 
                    3: active_frequency = 0;         
                    4, 5, 6: active_frequency = 370; 
                    7: active_frequency = 0;         
                    8, 9, 10, 11, 12, 13, 14: active_frequency = 440; 
                    15: active_frequency = 0;        
                    16, 17: active_frequency = 494; 
                    18, 19: active_frequency = 440; 
                    20, 21, 22: active_frequency = 392; 
                    23: active_frequency = 0;       
                    24, 25, 26: active_frequency = 370; 
                    27: active_frequency = 0;       
                    28, 29, 30, 31, 32, 33, 34: active_frequency = 330; 
                    35: active_frequency = 0;       
                    36, 37, 38: active_frequency = 392; 
                    39: active_frequency = 0;       
                    40, 41, 42: active_frequency = 370; 
                    43: active_frequency = 0;       
                    44, 45, 46: active_frequency = 330; 
                    47: active_frequency = 0;       
                    48, 49, 50, 51: active_frequency = 294; 
                    52: active_frequency = 0;       
                    53, 54: active_frequency = 330; 
                    55, 56: active_frequency = 370; 
                    57, 58, 59: active_frequency = 392; 
                    60: active_frequency = 0;       
                    61, 62, 63: active_frequency = 440; 
                    64: active_frequency = 0;       
                    65, 66, 67: active_frequency = 554; 
                    68: active_frequency = 0;       
                    69, 70, 71, 72, 73, 74, 75, 76, 77, 78: active_frequency = 587; 
                    79, 80, 81, 82, 83, 84, 85: active_frequency = 0; 
                    default: active_frequency = 0;
                endcase
            end
            
            6: begin
                case (note_index)
                    0: active_frequency = 659;      
                    1: active_frequency = 622;      
                    2: active_frequency = 659;      
                    3: active_frequency = 622;      
                    4: active_frequency = 659;      
                    5: active_frequency = 494;      
                    6: active_frequency = 587;      
                    7: active_frequency = 523;      
                    8, 9, 10, 11: active_frequency = 440; 
                    12: active_frequency = 0;       
                    13, 14: active_frequency = 261; 
                    15, 16: active_frequency = 330; 
                    17, 18: active_frequency = 440; 
                    19, 20, 21: active_frequency = 494; 
                    22: active_frequency = 0;       
                    23, 24: active_frequency = 330; 
                    25, 26: active_frequency = 415; 
                    27, 28: active_frequency = 494; 
                    29, 30, 31: active_frequency = 523; 
                    32: active_frequency = 0;       
                    33, 34: active_frequency = 330; 
                    35: active_frequency = 659;     
                    36: active_frequency = 622;     
                    37: active_frequency = 659;     
                    38: active_frequency = 622;     
                    39: active_frequency = 659;     
                    40: active_frequency = 494;     
                    41: active_frequency = 587;     
                    42: active_frequency = 523;     
                    43, 44, 45: active_frequency = 440; 
                    46: active_frequency = 0;       
                    47, 48: active_frequency = 261; 
                    49, 50: active_frequency = 330; 
                    51, 52: active_frequency = 440; 
                    53, 54, 55: active_frequency = 494; 
                    56: active_frequency = 0;       
                    57, 58: active_frequency = 330; 
                    59, 60: active_frequency = 523; 
                    61, 62: active_frequency = 494; 
                    63, 64, 65, 66: active_frequency = 440; 
                    67, 68: active_frequency = 0;   
                    69: active_frequency = 659;     
                    70: active_frequency = 622;     
                    71: active_frequency = 659;     
                    72: active_frequency = 622;     
                    73: active_frequency = 659;     
                    74: active_frequency = 494;     
                    75: active_frequency = 587;     
                    76: active_frequency = 523;     
                    77, 78, 79, 80: active_frequency = 440; 
                    81, 82, 83, 84, 85: active_frequency = 0; 
                    default: active_frequency = 0;
                endcase
            end
            
            7: begin
                case (note_index)
                    0, 1: active_frequency = 466; 
                    2: active_frequency = 0;      
                    3, 4, 5, 6: active_frequency = 784; 
                    7: active_frequency = 0;      
                    8, 9: active_frequency = 698; 
                    10, 11: active_frequency = 784; 
                    12, 13: active_frequency = 698; 
                    14, 15, 16, 17: active_frequency = 622; 
                    18: active_frequency = 0;      
                    19, 20: active_frequency = 587; 
                    21, 22: active_frequency = 622; 
                    23, 24, 25, 26, 27: active_frequency = 698; 
                    28: active_frequency = 0;      
                    29, 30, 31, 32: active_frequency = 466; 
                    33: active_frequency = 0;      
                    34, 35, 36: active_frequency = 587; 
                    37, 38, 39, 40, 41: active_frequency = 523; 
                    42: active_frequency = 0;      
                    43, 44, 45, 46, 47: active_frequency = 466; 
                    48: active_frequency = 0;      
                    49, 50, 51: active_frequency = 415; 
                    52, 53, 54: active_frequency = 392; 
                    55, 56, 57: active_frequency = 349; 
                    58, 59, 60, 61: active_frequency = 392; 
                    62: active_frequency = 0;      
                    63, 64, 65, 66: active_frequency = 622; 
                    67: active_frequency = 0;      
                    68, 69, 70, 71: active_frequency = 523; 
                    72: active_frequency = 0;      
                    73, 74, 75, 76, 77: active_frequency = 466; 
                    78: active_frequency = 0;      
                    79, 80, 81: active_frequency = 415; 
                    82, 83: active_frequency = 392; 
                    84, 85: active_frequency = 349; 
                    default: active_frequency = 0;
                endcase
            end
            
            8: begin
                case (note_index)
                    0: active_frequency = 659;      
                    1: active_frequency = 0;        
                    2: active_frequency = 659;      
                    3: active_frequency = 0;        
                    4: active_frequency = 659;      
                    5: active_frequency = 0;        
                    6: active_frequency = 523;      
                    7: active_frequency = 659;      
                    8: active_frequency = 0;        
                    9, 10, 11: active_frequency = 784; 
                    12: active_frequency = 0;       
                    13, 14, 15: active_frequency = 392; 
                    16: active_frequency = 0;       
                    17, 18, 19: active_frequency = 523; 
                    20: active_frequency = 0;       
                    21, 22: active_frequency = 392; 
                    23: active_frequency = 0;       
                    24, 25, 26: active_frequency = 330; 
                    27: active_frequency = 0;       
                    28, 29: active_frequency = 440; 
                    30: active_frequency = 0;       
                    31, 32: active_frequency = 494; 
                    33: active_frequency = 0;       
                    34: active_frequency = 466;     
                    35, 36: active_frequency = 440; 
                    37: active_frequency = 0;       
                    38, 39: active_frequency = 392; 
                    40: active_frequency = 659;     
                    41: active_frequency = 784;     
                    42, 43: active_frequency = 880; 
                    44: active_frequency = 0;       
                    45: active_frequency = 698;     
                    46: active_frequency = 784;     
                    47: active_frequency = 0;       
                    48, 49: active_frequency = 659; 
                    50: active_frequency = 0;       
                    51, 52: active_frequency = 523; 
                    53: active_frequency = 587;     
                    54, 55: active_frequency = 494; 
                    56, 57: active_frequency = 0;   
                    58, 59, 60: active_frequency = 523; 
                    61: active_frequency = 0;       
                    62, 63: active_frequency = 392; 
                    64: active_frequency = 0;       
                    65, 66, 67: active_frequency = 330; 
                    68: active_frequency = 0;       
                    69, 70: active_frequency = 440; 
                    71: active_frequency = 0;       
                    72, 73: active_frequency = 494; 
                    74: active_frequency = 0;       
                    75: active_frequency = 466;     
                    76, 77: active_frequency = 440; 
                    78: active_frequency = 0;       
                    79, 80: active_frequency = 392; 
                    81: active_frequency = 659;     
                    82: active_frequency = 784;     
                    83: active_frequency = 880;     
                    84: active_frequency = 698;     
                    85: active_frequency = 0;       
                    default: active_frequency = 0;
                endcase
            end
            
            9: begin
                case (note_index)
                    0: active_frequency = 523;      
                    1: active_frequency = 0;        
                    2: active_frequency = 523;      
                    3: active_frequency = 0;        
                    4: active_frequency = 523;      
                    5: active_frequency = 440;      
                    6: active_frequency = 494;      
                    7: active_frequency = 523;      
                    8, 9: active_frequency = 587;   
                    10: active_frequency = 0;       
                    11, 12: active_frequency = 659; 
                    13: active_frequency = 0;       
                    14, 15: active_frequency = 523; 
                    16: active_frequency = 0;       
                    17, 18, 19: active_frequency = 392; 
                    20: active_frequency = 0;       
                    21: active_frequency = 349;     
                    22: active_frequency = 0;       
                    23: active_frequency = 349;     
                    24: active_frequency = 0;       
                    25: active_frequency = 349;     
                    26: active_frequency = 294;     
                    27: active_frequency = 330;     
                    28: active_frequency = 349;     
                    29, 30: active_frequency = 392; 
                    31: active_frequency = 0;       
                    32, 33: active_frequency = 440; 
                    34: active_frequency = 0;       
                    35, 36: active_frequency = 349; 
                    37: active_frequency = 0;       
                    38, 39, 40: active_frequency = 294; 
                    41: active_frequency = 0;       
                    42: active_frequency = 523;     
                    43: active_frequency = 0;       
                    44: active_frequency = 494;     
                    45: active_frequency = 0;       
                    46: active_frequency = 440;     
                    47: active_frequency = 0;       
                    48: active_frequency = 392;     
                    49: active_frequency = 0;       
                    50, 51, 52: active_frequency = 523; 
                    53: active_frequency = 0;       
                    54: active_frequency = 523;     
                    55: active_frequency = 0;       
                    56: active_frequency = 523;     
                    57: active_frequency = 0;       
                    58: active_frequency = 523;     
                    59: active_frequency = 440;     
                    60: active_frequency = 494;     
                    61: active_frequency = 523;     
                    62, 63: active_frequency = 587; 
                    64: active_frequency = 0;       
                    65, 66: active_frequency = 659; 
                    67: active_frequency = 0;       
                    68, 69: active_frequency = 523; 
                    70: active_frequency = 0;       
                    71, 72: active_frequency = 392; 
                    73: active_frequency = 0;       
                    74: active_frequency = 261;     
                    75: active_frequency = 294;     
                    76: active_frequency = 330;     
                    77: active_frequency = 349;     
                    78, 79: active_frequency = 392; 
                    80: active_frequency = 0;       
                    81, 82, 83: active_frequency = 523; 
                    84, 85: active_frequency = 0;   
                    default: active_frequency = 0;
                endcase
            end
            
            10: begin
                case (note_index)
                    0, 1, 2: active_frequency = 659; 
                    3: active_frequency = 740;       
                    4, 5, 6: active_frequency = 784; 
                    7: active_frequency = 740;       
                    8, 9: active_frequency = 784;    
                    10, 11: active_frequency = 740;  
                    12, 13: active_frequency = 659;  
                    14, 15: active_frequency = 587;  
                    16: active_frequency = 0;        
                    17, 18, 19: active_frequency = 659; 
                    20: active_frequency = 740;      
                    21, 22, 23: active_frequency = 784; 
                    24: active_frequency = 740;      
                    25, 26: active_frequency = 784;  
                    27, 28: active_frequency = 740;  
                    29, 30: active_frequency = 659;  
                    31, 32: active_frequency = 587;  
                    33: active_frequency = 0;        
                    34, 35, 36: active_frequency = 494; 
                    37: active_frequency = 523;      
                    38, 39, 40: active_frequency = 587; 
                    41: active_frequency = 523;      
                    42, 43: active_frequency = 587;  
                    44, 45: active_frequency = 523;  
                    46, 47: active_frequency = 494;  
                    48, 49: active_frequency = 440;  
                    50: active_frequency = 0;        
                    51, 52, 53: active_frequency = 494; 
                    54: active_frequency = 523;      
                    55, 56, 57: active_frequency = 587; 
                    58: active_frequency = 523;      
                    59, 60: active_frequency = 587;  
                    61, 62: active_frequency = 523;  
                    63, 64: active_frequency = 494;  
                    65, 66: active_frequency = 440;  
                    67: active_frequency = 0;        
                    68, 69, 70, 71, 72: active_frequency = 659; 
                    73, 74: active_frequency = 0;               
                    75, 76, 77, 78, 79, 80: active_frequency = 494; 
                    81, 82, 83, 84, 85: active_frequency = 0;       
                    default: active_frequency = 0;
                endcase
            end
            
            11: begin
                case (note_index)
                    0: active_frequency = 440;  
                    1: active_frequency = 659;  
                    2: active_frequency = 440;  
                    3: active_frequency = 659;  
                    4: active_frequency = 494;  
                    5: active_frequency = 659;  
                    6: active_frequency = 494;  
                    7: active_frequency = 659;  
                    8: active_frequency = 523;  
                    9: active_frequency = 659;  
                    10: active_frequency = 523; 
                    11: active_frequency = 659; 
                    12: active_frequency = 587; 
                    13: active_frequency = 659; 
                    14: active_frequency = 587; 
                    15: active_frequency = 659; 
                    16, 17: active_frequency = 659; 
                    18: active_frequency = 0;       
                    19: active_frequency = 440; 
                    20: active_frequency = 659; 
                    21: active_frequency = 440; 
                    22: active_frequency = 659; 
                    23: active_frequency = 494; 
                    24: active_frequency = 659; 
                    25: active_frequency = 494; 
                    26: active_frequency = 659; 
                    27: active_frequency = 523; 
                    28: active_frequency = 659; 
                    29: active_frequency = 523; 
                    30: active_frequency = 659; 
                    31: active_frequency = 587; 
                    32: active_frequency = 659; 
                    33: active_frequency = 587; 
                    34: active_frequency = 659; 
                    35: active_frequency = 698; 
                    36: active_frequency = 659; 
                    37: active_frequency = 698; 
                    38: active_frequency = 659; 
                    39, 40, 41, 42: active_frequency = 784; 
                    43: active_frequency = 0;               
                    44: active_frequency = 523; 
                    45: active_frequency = 659; 
                    46: active_frequency = 523; 
                    47: active_frequency = 659; 
                    48: active_frequency = 494; 
                    49: active_frequency = 659; 
                    50: active_frequency = 494; 
                    51: active_frequency = 659; 
                    52: active_frequency = 440; 
                    53: active_frequency = 659; 
                    54: active_frequency = 440; 
                    55: active_frequency = 659; 
                    56: active_frequency = 494; 
                    57: active_frequency = 659; 
                    58: active_frequency = 494; 
                    59: active_frequency = 659; 
                    60: active_frequency = 523; 
                    61: active_frequency = 659; 
                    62: active_frequency = 523; 
                    63: active_frequency = 659; 
                    64: active_frequency = 587; 
                    65: active_frequency = 659; 
                    66: active_frequency = 587; 
                    67: active_frequency = 659; 
                    68, 69, 70, 71, 72: active_frequency = 880; 
                    73: active_frequency = 0;                   
                    74, 75, 76, 77, 78, 79, 80: active_frequency = 440; 
                    81, 82, 83, 84, 85: active_frequency = 0;   
                    default: active_frequency = 0;
                endcase
            end
            
            12: begin
                case (note_index)
                    0, 1: active_frequency = 659;   
                    2: active_frequency = 494;      
                    3: active_frequency = 523;      
                    4, 5: active_frequency = 587;   
                    6: active_frequency = 523;      
                    7: active_frequency = 494;      
                    8, 9: active_frequency = 440;   
                    10: active_frequency = 440;     
                    11: active_frequency = 523;     
                    12, 13: active_frequency = 659; 
                    14: active_frequency = 587;     
                    15: active_frequency = 523;     
                    16, 17: active_frequency = 494; 
                    18: active_frequency = 494;     
                    19: active_frequency = 523;     
                    20, 21: active_frequency = 587; 
                    22, 23: active_frequency = 659; 
                    24, 25: active_frequency = 523; 
                    26, 27: active_frequency = 440; 
                    28, 29, 30: active_frequency = 440; 
                    31: active_frequency = 0;       
                    32, 33: active_frequency = 587; 
                    34: active_frequency = 698;     
                    35, 36: active_frequency = 880; 
                    37: active_frequency = 784;     
                    38: active_frequency = 698;     
                    39, 40: active_frequency = 659; 
                    41: active_frequency = 523;     
                    42, 43: active_frequency = 659; 
                    44: active_frequency = 587;     
                    45: active_frequency = 523;     
                    46, 47: active_frequency = 494; 
                    48: active_frequency = 494;     
                    49: active_frequency = 523;     
                    50, 51: active_frequency = 587; 
                    52, 53: active_frequency = 659; 
                    54, 55: active_frequency = 523; 
                    56, 57: active_frequency = 440; 
                    58, 59, 60: active_frequency = 440; 
                    61, 62: active_frequency = 0;   
                    63, 64: active_frequency = 659; 
                    65, 66: active_frequency = 523; 
                    67, 68: active_frequency = 587; 
                    69, 70: active_frequency = 494; 
                    71, 72: active_frequency = 523; 
                    73, 74: active_frequency = 440; 
                    75, 76: active_frequency = 415; 
                    77, 78: active_frequency = 494; 
                    79, 80: active_frequency = 0;   
                    81, 82, 83, 84, 85: active_frequency = 0; 
                    default: active_frequency = 0;
                endcase
            end
            
            13: begin
                case (note_index)
                    0, 1: active_frequency = 370;       
                    2, 3: active_frequency = 370;       
                    4: active_frequency = 0;            
                    5, 6: active_frequency = 415;       
                    7, 8: active_frequency = 415;       
                    9: active_frequency = 0;            
                    10, 11: active_frequency = 440;     
                    12, 13, 14: active_frequency = 440; 
                    15: active_frequency = 440;         
                    16, 17: active_frequency = 0;       
                    18, 19: active_frequency = 659;     
                    20, 21: active_frequency = 659;     
                    22: active_frequency = 0;           
                    23, 24: active_frequency = 587;     
                    25, 26, 27: active_frequency = 587; 
                    28, 29: active_frequency = 0;       
                    30, 31: active_frequency = 554;     
                    32, 33, 34: active_frequency = 554; 
                    35, 36: active_frequency = 0;       
                    37, 38: active_frequency = 494;     
                    39, 40, 41: active_frequency = 494; 
                    42, 43, 44: active_frequency = 494; 
                    45, 46, 47: active_frequency = 0;   
                    48, 49: active_frequency = 370;     
                    50, 51: active_frequency = 370;     
                    52: active_frequency = 0;           
                    53, 54: active_frequency = 415;     
                    55, 56: active_frequency = 415;     
                    57: active_frequency = 0;           
                    58, 59: active_frequency = 440;     
                    60, 61, 62: active_frequency = 440; 
                    63, 64: active_frequency = 0;       
                    65, 66: active_frequency = 494;     
                    67, 68: active_frequency = 494;     
                    69: active_frequency = 0;           
                    70, 71: active_frequency = 440;     
                    72: active_frequency = 440;         
                    73: active_frequency = 0;           
                    74, 75: active_frequency = 415;     
                    76: active_frequency = 415;         
                    77: active_frequency = 0;           
                    78, 79: active_frequency = 370;     
                    80, 81: active_frequency = 370;     
                    82: active_frequency = 0;           
                    83, 84: active_frequency = 370;     
                    85: active_frequency = 0;           
                    default: active_frequency = 0;
                endcase
            end
            
            14: begin
                case (note_index)
                    0: active_frequency = 294;      
                    1: active_frequency = 294;      
                    2: active_frequency = 0;        
                    3: active_frequency = 294;      
                    4: active_frequency = 294;      
                    5: active_frequency = 0;        
                    6: active_frequency = 294;      
                    7: active_frequency = 294;      
                    8: active_frequency = 0;        
                    9: active_frequency = 330;      
                    10: active_frequency = 330;     
                    11: active_frequency = 0;       
                    12: active_frequency = 349;     
                    13: active_frequency = 349;     
                    14: active_frequency = 0;       
                    15: active_frequency = 349;     
                    16: active_frequency = 349;     
                    17: active_frequency = 0;       
                    18: active_frequency = 349;     
                    19: active_frequency = 349;     
                    20: active_frequency = 0;       
                    21: active_frequency = 392;     
                    22: active_frequency = 392;     
                    23: active_frequency = 0;       
                    24: active_frequency = 330;     
                    25: active_frequency = 330;     
                    26: active_frequency = 0;       
                    27: active_frequency = 330;     
                    28: active_frequency = 330;     
                    29: active_frequency = 0;       
                    30: active_frequency = 294;     
                    31: active_frequency = 294;     
                    32: active_frequency = 0;       
                    33: active_frequency = 261;     
                    34: active_frequency = 261;     
                    35: active_frequency = 0;       
                    36: active_frequency = 261;     
                    37: active_frequency = 261;     
                    38: active_frequency = 0;       
                    39: active_frequency = 294;     
                    40, 41: active_frequency = 294; 
                    42, 43: active_frequency = 0;   
                    44: active_frequency = 294;     
                    45: active_frequency = 294;     
                    46: active_frequency = 0;       
                    47: active_frequency = 294;     
                    48: active_frequency = 294;     
                    49: active_frequency = 0;       
                    50: active_frequency = 349;     
                    51: active_frequency = 349;     
                    52: active_frequency = 0;       
                    53: active_frequency = 392;     
                    54: active_frequency = 392;     
                    55: active_frequency = 0;       
                    56: active_frequency = 440;     
                    57: active_frequency = 440;     
                    58: active_frequency = 0;       
                    59: active_frequency = 440;     
                    60: active_frequency = 440;     
                    61: active_frequency = 0;       
                    62: active_frequency = 440;     
                    63: active_frequency = 440;     
                    64: active_frequency = 0;       
                    65: active_frequency = 466;     
                    66: active_frequency = 466;     
                    67: active_frequency = 0;       
                    68: active_frequency = 392;     
                    69: active_frequency = 392;     
                    70: active_frequency = 0;       
                    71: active_frequency = 392;     
                    72: active_frequency = 392;     
                    73: active_frequency = 0;       
                    74: active_frequency = 440;     
                    75: active_frequency = 440;     
                    76: active_frequency = 0;       
                    77: active_frequency = 294;     
                    78: active_frequency = 294;     
                    79: active_frequency = 0;       
                    80: active_frequency = 294;     
                    81: active_frequency = 294;     
                    82: active_frequency = 0;       
                    83: active_frequency = 330;     
                    84: active_frequency = 330;     
                    85: active_frequency = 0;       
                    default: active_frequency = 0;
                endcase
            end
            
            15: begin
                case (note_index)
                    0, 1: active_frequency = 587;     
                    2: active_frequency = 587;        
                    3: active_frequency = 0;          
                    4, 5: active_frequency = 659;     
                    6: active_frequency = 659;        
                    7: active_frequency = 0;          
                    8, 9: active_frequency = 698;     
                    10: active_frequency = 698;       
                    11: active_frequency = 0;         
                    12, 13: active_frequency = 880;   
                    14: active_frequency = 880;       
                    15: active_frequency = 0;         
                    16, 17, 18: active_frequency = 784; 
                    19, 20: active_frequency = 784;   
                    21: active_frequency = 0;         
                    22, 23: active_frequency = 698;   
                    24: active_frequency = 698;       
                    25: active_frequency = 0;         
                    26, 27: active_frequency = 659;   
                    28: active_frequency = 659;       
                    29: active_frequency = 0;         
                    30, 31: active_frequency = 587;   
                    32: active_frequency = 587;       
                    33: active_frequency = 0;         
                    34, 35: active_frequency = 659;   
                    36: active_frequency = 659;       
                    37: active_frequency = 0;         
                    38, 39: active_frequency = 698;   
                    40: active_frequency = 698;       
                    41: active_frequency = 0;         
                    42, 43: active_frequency = 880;   
                    44: active_frequency = 880;       
                    45: active_frequency = 0;         
                    46, 47, 48: active_frequency = 784; 
                    49, 50: active_frequency = 784;   
                    51: active_frequency = 0;         
                    52, 53: active_frequency = 698;   
                    54: active_frequency = 698;       
                    55: active_frequency = 0;         
                    56, 57: active_frequency = 659;   
                    58: active_frequency = 659;       
                    59: active_frequency = 0;         
                    60, 61, 62: active_frequency = 587; 
                    63: active_frequency = 587;       
                    64: active_frequency = 0;         
                    65, 66, 67: active_frequency = 440; 
                    68: active_frequency = 440;       
                    69: active_frequency = 0;         
                    70, 71, 72: active_frequency = 554; 
                    73, 74: active_frequency = 554;   
                    75: active_frequency = 0;         
                    76, 77, 78, 79: active_frequency = 587; 
                    80, 81: active_frequency = 587;   
                    82: active_frequency = 587;       
                    83, 84, 85: active_frequency = 0; 
                    default: active_frequency = 0;
                endcase
            end
            
            default: active_frequency = 0;
        endcase
    end
    
    always @(posedge clk) begin
        // --- EĞER SESSİZDEYSE (is_playing=0) SES ÇIKMASIN ---
        if (active_frequency == 0 || is_playing == 0) begin
            clk_counter <= 0;
            buzzer_state <= 0;
        end else begin
            if (clk_counter >= (13500000 / active_frequency)) begin
                buzzer_state <= ~buzzer_state;
                clk_counter <= 0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end
    end
    
    assign buzzer_out = buzzer_state;

endmodule