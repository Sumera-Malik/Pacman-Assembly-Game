;Sumera Malik - 21i1579 -BS CY(C)
INCLUDE irvine32.inc
INCLUDE macros.inc
Includelib Winmm.lib ;lib for sound effect
.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
       PlaySound PROTO,  ;pointer to file 
       pszSound:PTR BYTE, 
       hmod:DWORD, 
       fdwSound:DWORD ;flag for playing sound
Start_Music BYTE "Game_startmusic.wav", 0
Pac_manmsg    BYTE " <<<<<<    PAC-MAN GAME      >>>>>> ", 0Ah
            BYTE "                                    ",0Ah
            BYTE "                 Collect coins to Score points  ", 0Ah
            BYTE "                  Avoid the ghosts to survive    ", 0Ah
            BYTE "                   Good luck and have fun!     ", 0

Instructions_display BYTE "Game instructions", 0
Levelchoice_msg BYTE "Choose a Level ", 0Ah
                BYTE "Press 1 for Level 1", 0Ah
				BYTE "Press 2 for Level 2", 0Ah
				BYTE "Press 3 for Level 3", 0
Win_msg BYTE "YOU WIN!", 0
Gameover_msg BYTE "GAME OVER! BOOO ", 0
Decor BYTE "========================================================================================================================", 0
Maze_blocks BYTE "*", 0 ;maze walls 
Maze_array dword 1000 dup(0) ;positions
Maze_size dword 0
Coin_positions dword 1000 dup(0)
Coinsize_array dd 0
Player_Lives BYTE 3
Live_msg BYTE "Lives = ", 0
Player_namesize BYTE 0
Name_msg BYTE "Enter Player name = ", 0
Buffer_size = 25
Playername_array BYTE Buffer_size DUP(?)
Playername_arraysize BYTE Buffer_size DUP(?)
Playername_msg BYTE "Enter player name", 0
x_axis BYTE 1 ;Player's positions 
y_axis BYTE 1
user_input BYTE ?
Ghost_movement BYTE 1 ; direction of Ghost
Ghost_positions dword 5 dup(0)
No_ofGhost dd 0
Ghost_xaxis BYTE 12
Ghost_yaxis BYTE 9
GameLevel BYTE 0
Level_msg BYTE "Level = ", 0
Score_msg BYTE "Score = ", 0
Current_Score dword 0
Pause_msg BYTE "Press R to resume game", 0
Play_msg BYTE "Press P to play", 0
Resume_msg BYTE " ", 0
Instructionmsg_1 BYTE "Press y to move up", 0
Instructionmsg_2 BYTE "Press g to move left", 0
Instructionmsg_3 BYTE "Press h to move down", 0
Instructionmsg_4 BYTE "Press j to move right", 0
Instructionmsg_5 BYTE "Press M to move to main menu", 0
Instructionmsg_6 BYTE "Press I to show instructions", 0
File_name BYTE "Score_rec.txt", 0
Handlers HANDLE ?
File_content BYTE 1000 DUP(?)
File_sizea dd 0

.code
main PROC
start:
 
INVOKE PlaySound, OFFSET Start_Music, NULL, 11h
		mov eax,white +(Black*16)
		call SetTextColor
		call clrscr
		call Game_menu
        call Level_1
        jmp Game_MainLoop
Level1_PlaceGhosts:
		mov ebx,0
		mov bl,[esi]  ;loading positions x_axis
		mov bh,[esi+1]  ;y_axis 
		mov Ghost_xaxis,bl ;storing positions
		mov Ghost_yaxis,bh
		call Draw_Ghost
		add esi,2 ;move to the next ghost in an array
loop Level1_PlaceGhosts
		jmp Game_MainLoop

Level2_PlaceGhosts:
				mov ebx,0
				mov bl,[esi]  
				mov bh,[esi+1]
				mov Ghost_xaxis,bl ;update x_axis
				mov Ghost_yaxis,bh  ;update y_axis
				call Draw_Ghost
				add esi,2
loop Level2_PlaceGhosts
				jmp Game_MainLoop

Level3_PlaceGhosts:
		mov ebx,0
			mov bl,[esi]
			mov bh,[esi+1]
			mov Ghost_xaxis,bl
			mov Ghost_yaxis,bh
			call Draw_Ghost
			add esi,2
loop Level3_PlaceGhosts
			jmp Game_MainLoop

;=================== GAME START ======================
Game_MainLoop:
		call Game_score
		call Game_level
		call Ghost_strike
		call Player_live
		cmp Player_Lives,0 ; game over as player have zero lives
		je Game_over_L	
		mov eax,0

    mov eax, Current_Score
    cmp eax, 150             ; if score is hunderd jump to level 2
    je Level_2
    cmp eax, 200             ; id score is hunderd jump to level 3
    je Level_3
    cmp Current_Score, 350    ;if score is 500 end the game and declare the winner
    je Game_winner_L
		cmp GameLevel,1
		je Ghost1_L
		cmp GameLevel,2
		je Ghost1_L
		
;=================== 1st GHOST ======================
Ghost1_L:			
			mov ecx,0
			mov ecx,No_ofGhost
			mov esi,0
			mov esi,offset Ghost_positions
Ghost1_l1:
			mov eax,20 ;delay in ghost movemnet
			call delay
			mov ebx,0
			mov bl,[esi]
			mov bh,[esi+1]
			mov Ghost_xaxis,bl
			mov Ghost_yaxis,bh
			call Update_Ghostmovement ;erase ghost form current position
			call Movement_ofGhost
			mov ebx,0  ;update new position in ghost array
			mov bl,Ghost_xaxis
			mov bh,Ghost_yaxis
			mov [esi],bl  ;saving positions 
			mov [esi+1],bh
			call Draw_Ghost
			add esi,2
loop Ghost1_l1
			jmp user_inputloop

;=================== 2nd GHOST ======================
Ghost2_L:
			mov ecx,0
			mov ecx,No_ofGhost
			mov esi,0
			mov esi,offset Ghost_positions
Ghost2_l2:
			mov eax,15
			call delay
				mov ebx,0
				mov bl,[esi]
				mov bh,[esi+1]
				mov Ghost_xaxis,bl
				mov Ghost_yaxis,bh
				call Update_Ghostmovement
				call Movement_ofGhost
				mov ebx,0
				mov bl,Ghost_xaxis
				mov bh,Ghost_yaxis
				mov [esi],bl
				mov [esi+1],bh
				call Draw_Ghost
				add esi,2
				loop Ghost2_l2
				jmp user_inputloop

;=================== 3rd GHOST ======================
Ghost3_L:
			mov ecx,0
			mov ecx,No_ofGhost
			mov esi,0
			mov esi,offset Ghost_positions
Ghost3_l2:
			mov eax,10
			call delay
				mov ebx,0
				mov bl,[esi]
				mov bh,[esi+1]
				mov Ghost_xaxis,bl
				mov Ghost_yaxis,bh
				call Update_Ghostmovement
				call Movement_ofGhost
				mov ebx,0
				mov bl,Ghost_xaxis
				mov bh,Ghost_yaxis
				mov [esi],bl
				mov [esi+1],bh
				call Draw_Ghost
				add esi,2
				loop Ghost3_l2
				jmp user_inputloop
		
;=================== USER INPUT ======================
user_inputloop:
		call Readkey
		mov user_input,al
		cmp user_input,"E" ;to exit the game
		je Game_Exit_L

		cmp user_input,"y"
		je Player_MoveUp

		cmp user_input,"h"
		je Player_MoveDown

		cmp user_input,"g"
		je Player_Move_leftL

		cmp user_input,"j"
		je Player_Move_RightL
		
		cmp user_input,"p"
		je Game_pause_L
		jmp Game_MainLoop

;=================== BOUNDRY CHECK RESTRUCTION ======================
Player_MoveUp:
		mov ecx,1 ;upward limit 
		cmp y_axis,1
		je Game_MainLoop

		mov eax,0
		mov ebx,0
		mov ecx ,Maze_size
		mov esi, OFFSET Maze_array
		l1_temp:
			mov al,[esi]  ;check maze x axis
			mov bl,x_axis
			cmp eax,ebx
			je l2_temp
			mov eax,0
			mov ebx,0
			add esi,2
			loop l1_temp  ;repating for all block
			jmp move_Loop
		l2_temp:
		    mov al,[esi+1] ;load y_axis
			mov bl,y_axis
			dec ebx
			cmp ebx,eax
			je Game_MainLoop
			mov eax,0
			mov ebx,0
			add esi,2
			loop l1_temp
		move_Loop:
			call Update_Playermovement
			dec y_axis
			call Draw_Player
		jmp Game_MainLoop

;=================== RESTRICTION FOR LOWER BOUNDRY ======================
Player_MoveDown:
		cmp y_axis,33 ;not out of maze
		je Game_MainLoop
		mov eax,0 
		mov ebx,0
		mov ecx ,Maze_size ;loop for the maze 
		mov esi, OFFSET Maze_array
		l3_temp:
			mov al,[esi]
			mov bl,x_axis
			cmp eax,ebx
			je l4_temp
			mov eax,0
			mov ebx,0 
			add esi,2
			loop l3_temp
			jmp Move_down
		l4_temp:
		    mov al,[esi+1] ; maze y axis
			mov bl,y_axis
			inc ebx
			cmp ebx,eax ;check palyer and maze y axis
			je Game_MainLoop
			mov eax,0
			mov ebx,0
			add esi,2
			loop l3_temp
		Move_down:
		call Update_Playermovement
		inc y_axis
		call Draw_Player
		jmp Game_MainLoop
Player_Move_leftL:
		cmp x_axis,2
		je Game_MainLoop
		mov eax,0
		mov ebx,0
		mov ecx ,Maze_size
		mov esi, OFFSET Maze_array

		l5_temp:
			mov al,[esi]
			mov bl,x_axis
			dec ebx
			cmp ebx,0
			je temp1
			cmp eax,ebx
			je l6_temp
			mov eax,0
			mov ebx,0
			add esi,2
			loop l5_temp
			jmp Move_left
		l6_temp:
		    mov al,[esi+1]
			mov bl,y_axis
			cmp ebx,eax
			je Game_MainLoop
			mov eax,0
			mov ebx,0
			add esi,2
			loop l5_temp
		
		Move_left:
		call Update_Playermovement
		dec x_axis
		call Draw_Player
		jmp Game_MainLoop

		temp1:
		cmp GameLevel,3
		jne Game_MainLoop
		call Update_Playermovement
		add x_axis,37
		jmp Player_Move_RightL
		
		Player_Move_RightL:
		cmp x_axis,52
		je Game_MainLoop
		mov eax,0
		mov ebx,0
		mov ecx ,Maze_size
		mov esi, OFFSET Maze_array
		l7_temp:
			mov al,[esi]
			mov bl,x_axis
			inc ebx
			
			cmp ebx,48
			je temp4
			cmp eax,ebx
			je l8_temp
			mov eax,0
			mov ebx,0
			add esi,2
			loop l7_temp
			jmp move_right
		l8_temp:
		    mov al,[esi+1]
			mov bl,y_axis
			cmp ebx,eax
			je temp2
			mov eax,0
			mov ebx,0
			add esi,2
			loop l7_temp
		move_right:
		call Update_Playermovement
		inc x_axis
		call Draw_Player
		jmp Game_MainLoop

		temp2:
		cmp x_axis,46
		je temp3
		jmp Game_MainLoop
		
		temp3:
		mov x_axis,9
		call Draw_Player
		jmp Game_MainLoop

		temp4:
		cmp GameLevel,3
		jne Game_MainLoop
		call Update_Playermovement
		mov x_axis,10
		jmp Player_Move_leftL

	Game_Exit_L:
	call File_handling
	exit

;=================== GAME OVER ======================
Game_over_L:
	call Game_over
	mov eax,0
	call readchar
	cmp al,'E'
	je Game_Exit_L
	jmp Game_over_L
	
;=================== WIN  ======================	
Game_winner_L:
	call Game_winner
	mov eax,0
	call readchar
	cmp al,'E'
	je Game_Exit_L
	jmp Game_winner_L
	
;=================== PAUSE ======================
Game_pause_L:
	call Game_pause
	jmp Game_MainLoop
main ENDP

;======================================= GAME PROCS ========================================================
;=================== LEVEL 1  ======================
Level_1 PROC
    mov eax, white + (Black * 16)
    call SetTextColor
    call clrscr
    call Initialize_MAZE_1             
    call Generate_coins   
    mov x_axis, 1              
    mov y_axis, 1
    call Draw_Player           
    mov GameLevel, 1              
    call Set_Ghost1            
    mov ecx, No_ofGhost
    mov esi, offset Ghost_positions
Placeghost_l1:                
    mov ebx, 0
    mov bl, [esi]
    mov bh, [esi + 1]
    mov Ghost_xaxis, bl
    mov Ghost_yaxis, bh
    call Draw_Ghost
    add esi, 2
    loop Placeghost_l1
    ret
Level_1 ENDP

;=================== LEVEL 2 ======================
Level_2 PROC
    mov eax, white + (Black * 16)
    call SetTextColor
    call clrscr
    call Initialize_MAZE_2                
    call Generate_coins  
    mov x_axis, 1              
    mov y_axis, 1
    call Draw_Player           
    mov GameLevel, 2               
    call Set_Ghost2 
	mov ecx, No_ofGhost
    mov esi, offset Ghost_positions
	call Set_Ghost3
    mov ecx, No_ofGhost
    mov esi, offset Ghost_positions
Placeghost_l2:              
    mov ebx, 0
    mov bl, [esi]
    mov bh, [esi + 1]
    mov Ghost_xaxis, bl
    mov Ghost_yaxis, bh
    call Draw_Ghost
    add esi, 2
    loop Placeghost_l2
    ret
Level_2 ENDP

;=================== LEVEL 3 ======================
Level_3 PROC
    mov eax, white + (Black * 16)
    call SetTextColor
    call clrscr
    call Initialize_MAZE_3               
    call Generate_coins   
    mov x_axis, 1              
    mov y_axis, 1
    call Draw_Player           
    mov GameLevel, 3               
    call Set_Ghost2 
	call Set_Ghost3
    mov ecx, No_ofGhost
    mov esi, offset Ghost_positions
Placeghost_l3:                
    mov ebx, 0
    mov bl, [esi]
    mov bh, [esi + 1]
    mov Ghost_xaxis, bl
    mov Ghost_yaxis, bh
    call Draw_Ghost
    add esi, 2
    loop Placeghost_l3
    ret
Level_3 ENDP

;================= DRAW PLAYER =======================================
Draw_Player PROC
	mov eax,black+(yellow * 16)
	call SetTextColor
	mov dl,x_axis
	mov dh,y_axis
	call Gotoxy
	mov al,":"
	call WriteChar
	ret
Draw_Player ENDP 

;================== DRAW GHOST ======================================
Draw_Ghost PROC
	mov eax,black+(white * 16)
	call SetTextColor
	mov dl,Ghost_xaxis
	mov dh,Ghost_yaxis
	call Gotoxy
	mov al,""""
	call WriteChar
	ret
Draw_Ghost ENDP

;================= WHEN THE PLAYER MOVE HOW IT SHOW ON CONSOLE =======================================
Update_Playermovement PROC
	mov eax,red+(black * 16)
	call SetTextColor
	mov dl,x_axis
	mov dh,y_axis
	call Gotoxy
	mov al," "
	call WriteChar
	ret
Update_Playermovement ENDP

;=================== WHEN THE GHOST MOVE HOW IT SHOW ON CONSOLE =====================================
Update_Ghostmovement PROC
	push ecx
	mov eax,white+(black * 16)
	call SetTextColor
	mov dl,Ghost_xaxis
	mov dh,Ghost_yaxis
	call Gotoxy
	mov edi,0
	mov edi,offset Coin_positions
	mov ecx,0
	mov ebx,0
	gl1_temp:
		mov bl,Ghost_xaxis
		mov bh,Ghost_yaxis
		cmp bl ,[edi]
		je ghost_ycheck
		add edi,2
		loop gl1_temp
		jmp Nocoin_foundL
	
		ghost_ycheck:
		cmp bh,[edi+1]
		je Coin_foundL
		add edi,2
		loop gl1_temp
		jmp Nocoin_foundL

	Coin_foundL:
	mov al," "
	call WriteChar
	pop ecx
	ret
	Nocoin_foundL:
	mov al," "
	call WriteChar
	pop ecx
	ret
Update_Ghostmovement ENDP

;=============== MOVE GHOST =========================================
Movement_ofGhost PROC
	
	mov ebx,0
	mov bl,Ghost_xaxis
	mov bh,Ghost_yaxis
	cmp bl,40
	je Ghost_Leftmovement1 ;change direction to left 
	cmp bl,25
	je Ghost_Rightmovement1
	jmp Ghost_moveLL

	Ghost_Leftmovement1:
	mov Ghost_movement,0
	jmp Ghost_moveLL

	Ghost_Rightmovement1:
	mov Ghost_movement,1
	jmp Ghost_moveLL

	Ghost_moveLL:
	 cmp Ghost_movement,1
	 je Ghost_Rightmovement2

	Ghost_Leftmovement2:
	 sub Ghost_xaxis,1
	 ret

	Ghost_Rightmovement2:
	 add Ghost_xaxis,1
	 ret
ret
Movement_ofGhost ENDP

;================ HORIZONTAL WALL ========================================
DrawHorizontal_Wall PROC
	horwall_loop1:
		mov [esi],bl
		mov [esi+1],al
		add esi,5
		inc Maze_size
		mov dl,bl
		mov dh,al
		call gotoxy

		mov edx,offset Maze_blocks
		call writestring
		inc ebx
		loop horwall_loop1
	ret
DrawHorizontal_Wall ENDp

;============== VERTICAL WALLS ==========================================
DrawVertical_Wall PROC
	verwall_loop:
		mov [esi],bl
		mov [esi+1],al
		add esi,5
		inc Maze_size
		mov dl,bl
		mov dh,al
		call gotoxy
		mov edx,offset Maze_blocks
		call writestring
		inc eax
		loop verwall_loop
	ret
DrawVertical_Wall ENDP

;===================== MAZE 1 ===================================
Initialize_MAZE_1 proc
   
   mov esi, offset Maze_array

    mov eax, Blue + (Black * 16) 
	call SetTextColor
    mov eax, 0        
    mov ecx, 49       
    mov ebx, 0         
    call DrawHorizontal_Wall

    mov eax, 28   
    mov ecx, 49   
    mov ebx, 0        
    call DrawHorizontal_Wall

    mov eax, 0         
    mov ecx, 28       
    mov ebx, 0         
    call DrawVertical_Wall

    mov eax, 0        
    mov ecx, 28      
    mov ebx, 49      
    call DrawVertical_Wall

    mov eax, 5         
    mov ebx, 7         
    mov ecx, 28      
    call DrawHorizontal_Wall

	mov eax, 5         
    mov ebx, 35        
    mov ecx, 6     
    call DrawVertical_Wall

    mov eax, 10        
    mov ebx, 8         
    mov ecx, 28        
    call DrawHorizontal_Wall

	mov eax, 10    
    mov ebx, 20     
    mov ecx, 10       
    call DrawVertical_Wall
	
	mov eax, 2      
    mov ebx, 15     
    mov ecx, 30    
    call DrawHorizontal_Wall
  
	mov eax, 2       
    mov ebx, 45      
    mov ecx, 6      
    call DrawVertical_Wall

	mov eax, 22      
    mov ebx, 8     
    mov ecx, 30   
    call DrawHorizontal_Wall

     mov eax, 20         
    mov ebx, 8     
    mov ecx, 6     
    call DrawVertical_Wall

	mov eax, white + (Black * 16) 
	call SetTextColor

    ret
Initialize_MAZE_1 endp

;================= MAZE 2 =======================================
Initialize_MAZE_2 proc

 mov esi, offset Maze_array
    mov eax, Blue + (Black * 16) 
	call SetTextColor
    mov eax, 0        
    mov ecx, 49       
    mov ebx, 0         
    call DrawHorizontal_Wall

    mov eax, 28   
    mov ecx, 49   
    mov ebx, 0        
    call DrawHorizontal_Wall

    mov eax, 0         
    mov ecx, 28       
    mov ebx, 0         
    call DrawVertical_Wall

    mov eax, 0        
    mov ecx, 28      
    mov ebx, 49      
    call DrawVertical_Wall

    mov eax, 5         
    mov ebx, 7         
    mov ecx, 28      
    call DrawHorizontal_Wall

	mov eax, 10       
    mov ebx, 8        
    mov ecx, 28      
    call DrawHorizontal_Wall

	mov eax, 5         
    mov ebx, 35        
    mov ecx, 6     
    call DrawVertical_Wall

    mov eax, 10        
    mov ebx, 8         
    mov ecx, 28        
    call DrawHorizontal_Wall

	mov eax, 10    
    mov ebx, 20     
    mov ecx, 10       
    call DrawVertical_Wall
	
	mov eax, 2      
    mov ebx, 15     
    mov ecx, 30    
    call DrawHorizontal_Wall
  
	mov eax, 2       
    mov ebx, 45      
    mov ecx, 6      
    call DrawVertical_Wall

	mov eax, 22      
    mov ebx, 8     
    mov ecx, 30   
    call DrawHorizontal_Wall

     mov eax, 20         
    mov ebx, 8     
    mov ecx, 6     
    call DrawVertical_Wall

	mov eax, white + (Black * 16) 
	call SetTextColor
ret
Initialize_MAZE_2 endp

;===================== MAZE 3 ===================================
Initialize_MAZE_3 proc
	mov esi, offset Maze_array
    mov eax, Blue + (Black * 16) 
	call SetTextColor
    mov eax, 0        
    mov ecx, 49       
    mov ebx, 0         
    call DrawHorizontal_Wall

    mov eax, 28   
    mov ecx, 49   
    mov ebx, 0        
    call DrawHorizontal_Wall

    mov eax, 0         
    mov ecx, 28       
    mov ebx, 0         
    call DrawVertical_Wall

    mov eax, 0        
    mov ecx, 28      
    mov ebx, 49      
    call DrawVertical_Wall

    mov eax, 5         
    mov ebx, 7         
    mov ecx, 28      
    call DrawHorizontal_Wall

	mov eax, 5         
    mov ebx, 35        
    mov ecx, 6     
    call DrawVertical_Wall

    mov eax, 10        
    mov ebx, 8         
    mov ecx, 28        
    call DrawHorizontal_Wall

	mov eax, 10    
    mov ebx, 20     
    mov ecx, 10       
    call DrawVertical_Wall
	
	mov eax, 2      
    mov ebx, 15     
    mov ecx, 30    
    call DrawHorizontal_Wall
  
	mov eax, 2       
    mov ebx, 45      
    mov ecx, 6      
    call DrawVertical_Wall

	mov eax, 22      
    mov ebx, 8     
    mov ecx, 30   
    call DrawHorizontal_Wall

     mov eax, 20         
    mov ebx, 8     
    mov ecx, 6     
    call DrawVertical_Wall

	mov eax, white + (Black * 16) 
	call SetTextColor
ret		
Initialize_MAZE_3 endp

;================= DRAW COINS =======================================
Draw_Coins PROC
	
	mov eax, Yellow+(Black * 16)
	call SetTextColor
	mov dl, 4
	mov dh, 1
	call Gotoxy
	mwrite ".. .. .. .. .."

	mov dl, 25
	mov dh, 1
	call Gotoxy
	mwrite ".. .. .. .. .."

	mov dl, 5
	mov dh, 3
	call Gotoxy
	mwrite ".. .. .. .. .."

	mov dl, 25
	mov dh, 3
	call Gotoxy
	mwrite ".. .. .. .. .."

	mov dl, 23
	mov dh, 25
	call Gotoxy
	mwrite ".. .. .. .. .. .."

	mov dl, 5
	mov dh, 18
	call Gotoxy
	mwrite " .. .. .. .."

	mov dl, 5
	mov dh, 14
	call Gotoxy
	mwrite ".. .. .. .. .. .. .. .. .. .. .. .. "

	mov dl, 7
	mov dh, 25
	call Gotoxy
	mwrite ".. .. .. .. .."

	mov dl, 5
	mov dh, 6
Vertical_Coins1:
	call Gotoxy
	mwrite "::"
	add dh, 2
	cmp dh, 24
	jle Vertical_Coins1

	mov dl, 40
	mov dh, 6
Vertical_Coins2:
	call Gotoxy
	mwrite "::"
	add dh, 2
	cmp dh, 24
	jle Vertical_Coins2

	mov dl, 18
	mov dh, 8
	call Gotoxy
	mwrite ".. .. .. .."


	mov dl, 30
	mov dh, 14
	call Gotoxy
	mwrite ".."

	mov dl, 28
	mov dh, 18
	call Gotoxy
	mwrite ".. .. .."

	mov dl, 40
	mov dh, 12
	call Gotoxy
	mwrite ".."

	mov dl, 5
	mov dh, 50
	call Gotoxy
	mwrite ".."

	inc Coinsize_array
	ret

Draw_Coins ENDP

;================ GENERATE COINS ========================================
Generate_coins PROC
    mov ecx, 30                    
    mov ebx, 0
    mov bl, 1                    
    mov bh, 1                       
    push ebx
    mov edi, offset Coin_positions  

generate_loop:
    pop ebx ; restore axis
    mov eax, ebx
    inc ah
    push eax
    mov esi, offset Maze_array       
	jmp validate_and_place

validate_and_place:
    push ecx ;save coins genration 
	mov ecx,30
	mov edx,0
	mov esi,0
	mov esi,offset Maze_array
	temp10:
	mov esi,offset Maze_array
	mov edx,0
	validate:
		
		mov eax,0
		mov al,[esi]
		mov ah,[esi+1]
		cmp bh,ah
		jne temp12
		cmp bl,al
		jne temp12
		jmp temp13

		temp12:
		add esi,2 ;move to next block 
		inc edx
		cmp edx,Maze_size
		je coins_placement
		jmp validate
				
		coins_placement:
		mov [edi],bl
		mov [edi+1],bh
		add edi,2
		call Draw_Coins

		temp13:
		inc bl
		inc bl
		loop temp10
		pop ecx  ;restore coin genertation 
	loop generate_loop
	pop eax 
    ret
Generate_coins ENDP

;================== SET GHOST 1 ======================================
Set_Ghost1 proc
mov esi,0
mov esi,offset Ghost_positions
mov ebx,0
mov bl,3 ;position of ghost 
mov bh,7
mov [esi],bl
mov [esi+1],bh
inc No_ofGhost

add esi,2
mov ebx,0
mov bl,25 ; how much right and left it can move
mov bh,12
mov [esi],bl
mov [esi+1],bh
inc No_ofGhost
ret
Set_Ghost1 endp

;================ SET GHOST 2 ========================================
Set_Ghost2 proc
mov esi,0
mov esi,offset Ghost_positions
mov No_ofGhost,0

mov ebx,0
mov bl,6
mov bh,8
mov [esi],bl
mov [esi+1],bh
inc No_ofGhost

add esi,2
mov ebx,0
mov bl,25
mov bh,16
mov [esi],bl
mov [esi+1],bh
inc No_ofGhost
ret
Set_Ghost2 endp

;================ SET GHOST 3 ========================================
Set_Ghost3 proc
mov esi,0
mov esi,offset Ghost_positions
mov No_ofGhost,0

mov ebx,0
mov bl,15
mov bh,8
mov [esi],bl
mov [esi+1],bh
inc No_ofGhost

add esi,2
mov ebx,0
mov bl,25
mov bh,16
mov [esi],bl
mov [esi+1],bh
inc No_ofGhost
ret
Set_Ghost3 endp

;=================== GHOST ATTACK =====================================
Ghost_strike proc
mov ecx,No_ofGhost
mov edi,offset Ghost_positions
G_attack_l:
mov ebx,0
mov bl,[edi]
mov bh,[edi+1]
cmp x_axis,bl
je temp15
add edi,2
loop G_attack_l
ret 

temp15:
cmp y_axis,bh ;check if player and ghost have same axis then life dec
je Live_countsub
add edi,2
loop G_attack_l
ret

Live_countsub:
dec Player_Lives ;when live dec move player to 1 1 axis
mov x_axis,1
mov y_axis,1
call Update_Playermovement
call Draw_Player
ret
Ghost_strike endp

;================== DISPLAY SCORES ======================================
Game_score proc
		mov ecx,Coinsize_array
		mov ebx,5
		mov bl,x_axis
		mov bh,y_axis
		mov edi,offset Coin_positions

		Score_loop1:
		cmp bl,[edi]  ;cmp player and coins x axis
		je check_axis
		add edi,2 ; move to the next coin 
		loop Score_loop1
		jmp draw_Score_l

		check_axis:
		cmp bh,[edi+1]  ;cmp player and coins y axis of both same the coin is collected
		je coin_tempcoll
		add edi,2
		loop Score_loop1
		jmp draw_Score_l

		coin_tempcoll:
		inc Current_Score ;coin are collected so score is inc 
		mov  BYTE ptr[edi],0 ;coin mark as collected 
		mov BYTE ptr[edi+1],0

		mov ecx,5
		mov ebx,0
		mov bl,x_axis
		mov bh,y_axis

		Scoring_loop2:
		cmp bl,[edi]
		je check_axis2
		add edi,2
		loop Scoring_loop2
		jmp draw_Score_l

		check_axis2:
		cmp bh,[edi+1]
		add edi,2
		loop Scoring_loop2
		jmp draw_Score_l
		draw_Score_l:
		mov eax,green +(black * 16)
		call SetTextColor
		mov dl,100
		mov dh,0
        call Gotoxy
		mov edx,OFFSET Score_msg
		call WriteString
		mov eax,Current_Score
		call WriteInt
ret
Game_score endp 

;================ DRAW LIVES ========================================
Player_live proc
	mov eax,0
	mov eax,green +(black * 16)
	call SetTextColor	
	mov edx,0
	mov dl,100
	mov dh,1
	call gotoxy
	mov edx,offset Live_msg
	call writestring
	mov eax,0
	mov al,Player_Lives
	call writedec
	ret
Player_live endp

;=================== DRAW LEVELS =====================================
Game_level proc
		mov eax,green+(black * 16)
		call SetTextColor
		mov dl,100
		mov dh,2
		call Gotoxy
		mov edx,OFFSET Level_msg
		call WriteString
		movzx  eax,GameLevel
		call WriteInt
ret
Game_level endp

;================ SHOW MENU ========================================
Game_menu proc
     
	mov edx, offset Decor
    call writestring

	mov eax, Red+ (Black * 16)
    call SetTextColor
	mov dl, 14
    mov dh, 4
    call gotoxy
	mov edx, offset Pac_manmsg 
    call writestring
	 mov eax, blue+ (Black * 16)
    call SetTextColor
    mov eax, 0
    mov edx, 0
    mov dl, 20
    mov dh, 10
    call gotoxy
    mov edx, offset Playername_msg
    call writestring
    start:
    mov eax, 0
    mov edx, 0
    mov dl, 25
    mov dh, 12
    call gotoxy
    mov eax, Green + (Black * 16)
    call SetTextColor
    mov edx, OFFSET Playername_array
    mov ecx, Buffer_size
    call ReadString
    mov [Player_namesize], al
    mov eax, 0
    mov esi, OFFSET Playername_array
    mov edi, OFFSET Playername_arraysize
    mov ecx, Buffer_size
    rep movsb
    mov BYTE PTR [edi], 0
    mov eax, White + (Black * 16)
    call SetTextColor
    call clrscr

    console_display:
    mov edx, offset Decor
    call writestring
    mov eax, Cyan + (Black * 16)
    call SetTextColor
    mov eax, 0
    mov eax, Cyan + (Black * 16)
    call SetTextColor

    mov edx, 0
    mov dl, 1
    mov dh, 1
	call gotoxy
    mov edx, offset Play_msg
    call writestring
    mov dl, 1
    mov dh, 2
	call crlf
    call gotoxy

    mov edx, offset Instructionmsg_6
    call writestring
    mov dl, 1
    mov dh, 3
    call gotoxy
	call crlf
    mov edx, offset Levelchoice_msg
    call writestring
	call crlf 

    call readchar
    cmp al, 'p'
    je starting_gameL
    cmp al, 'i'
    je display_instruction_l

    cmp al, '1'
    je set_level1
    cmp al, '2'
    je set_level2
    cmp al, '3'
    je set_level3
    jmp console_display

    set_level1:
    mov GameLevel, 1
    jmp starting_gameL

    set_level2:
    mov GameLevel, 2
    jmp starting_gameL

    set_level3:
    mov GameLevel, 3
    jmp starting_gameL

    display_instruction_l:
    call Game_instructions
    mov eax, White + (Black * 16)
    call SetTextColor
    jmp console_display

    starting_gameL:
    mov eax, White + (Black * 16)
    call SetTextColor
    call clrscr
    ret
Game_menu endp

;=================== SHOW INSTRUCTIONS =====================================
Game_instructions proc
show_instructsL:
    mov eax, white + (Black * 16)  
	call SetTextColor
	call clrscr
    mov edx, offset Decor
	call writestring
	mov eax, Blue + (Black * 16)  
	call SetTextColor
	mov edx,0
	mov dl,0
	mov dh,9
	call crlf
	mov edx,offset Instructions_display
	call writestring

	mov eax, Yellow + (Black * 16) 
	call SetTextColor
	mov edx,0
	mov dl,17
	mov dh,13
	call crlf
	mov edx,offset Instructionmsg_1
	call writestring

	mov eax, Green + (Black * 16)  
	call SetTextColor
	mov edx,0
	mov dl,17
	mov dh,14
	call crlf
	mov edx,offset Instructionmsg_2
	call writestring

	mov eax, Cyan + (Black * 16)  
	call SetTextColor
	mov edx,0
	mov dl,17
	mov dh,15
	call crlf
	mov edx,offset Instructionmsg_3
	call writestring

	mov eax, Magenta + (Black * 16) 
	call SetTextColor
	mov edx,0
	mov dl,17
	mov dh,16
	call crlf
	mov edx,offset Instructionmsg_4
	call writestring

	mov eax, Red + (Black * 16)  
	call SetTextColor
	mov edx,0
	mov dl,13
	mov dh,17
	call crlf
	mov edx,offset Instructionmsg_5
	call writestring

	call readchar
	cmp al, 'm'
	jne show_instructsL
	call clrscr
	ret
Game_instructions endp

;================ PAUSE GAME ========================================
Game_pause proc
	mov eax,Red +(black*16)
	call SetTextColor
	
	mov edx,0
	mov dl,80
	mov dh,4
	call gotoxy
	mov edx,offset Pause_msg
	call writestring
	mov eax,0
	call readchar
	cmp al,'r'
	je resume_l
	call Game_pause

	resume_l:
	mov eax,Red +(black*16)
	call SetTextColor
	
	mov edx,0
	mov dl,80
	mov dh,5
	call gotoxy
	mov edx,offset Resume_msg
	call writestring
	ret
Game_pause endp

;=============== DISPLAY WIN SCREEN =========================================
Game_winner proc
    mov eax, white + (Black * 16)  
	call SetTextColor
	call clrscr
    mov edx, offset Decor
	call writestring

	mov eax,Yellow +(black*16)
	call SetTextColor
	call clrscr
	mov edx,0
	mov dl,0
	mov dh,0
	call gotoxy
	mov edx,offset Win_msg
	call writestring	
	
	mov edx,0
	mov dl,1
	mov dh,1
	call gotoxy
	mov edx,offset Name_msg
	call writestring	
	
	mov edx,0
	mov dl,22
	mov dh,1
	call gotoxy
	mov edx,offset Playername_arraysize
	call writestring	
	
	mov edx,0
	mov dl,1
	mov dh,2
	call gotoxy
	mov edx,offset Score_msg
	call writestring	
	
	mov edx,0
	mov dl,9
	mov dh,2
	call gotoxy
	mov eax,Current_Score
	call writedec	

	mov edx,0
	mov dl,1
	mov dh,3
	call gotoxy
	mov edx,offset Level_msg
	call writestring	

	mov edx,0
	mov dl,8
	mov dh,3
	call gotoxy
	mov eax,0
	mov al,GameLevel
	call writedec	
ret
Game_winner endp

;============== GAME OVER DISPLAY ==========================================
Game_over proc

   mov eax, white + (Black * 16)  
	call SetTextColor
	call clrscr
    mov edx, offset Decor
	call writestring
	mov eax,Magenta +(black*16)
	call SetTextColor
	call clrscr
	mov edx,0
	mov dl,1
	mov dh,0
	call gotoxy
	mov edx,offset Gameover_msg
	call writestring

	mov edx,0
	mov dl,1
	mov dh,1
	call gotoxy
	mov edx,offset Name_msg
	call writestring	
	
	mov edx,0
	mov dl,22
	mov dh,1
	call gotoxy
	mov edx,offset Playername_arraysize
	call writestring	
	
	mov edx,0
	mov dl,1
	mov dh,2
	call gotoxy
	mov edx,offset Score_msg
	call writestring	
	
	mov edx,0
	mov dl,9
	mov dh,2
	call gotoxy
	mov eax,Current_Score
	call writedec	
	
	mov edx,0
	mov dl,1
	mov dh,3
	call gotoxy
	mov edx,offset Level_msg
	call writestring	
	
	mov edx,0
	mov dl,8
	mov dh,3
	call gotoxy
	mov eax,0
	mov al,GameLevel
	call writedec	
ret
Game_over endp

;=============== FILE HANDLING =========================================
File_handling PROC
	mov edx, OFFSET File_name ;file open 
	call OpenInputFile
	mov Handlers, eax

	mov edx, OFFSET File_content ;reading file content
	mov ecx, 1000
	call ReadFromFile
	mov File_sizea, eax
	mov eax, Handlers ;colsing after reading data 
	call CloseFile

	Exit_l:
	ret
File_handling ENDP
END main