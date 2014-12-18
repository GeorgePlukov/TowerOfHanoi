; Name: George Plukov
; Description: Create a recurive tower of hanoi solution using arrays in x86 nasm
; Under no circumstances do I condone the use of this code for anything other than educational purposes
; Feel free to understand and learn from this code!

; Declare some external functions
%include "asm_io.inc"
extern printf
extern getchar
SECTION .data

; VARIABLES
size: dd 0      
svdpeg: dd 0
argnum: dd 0
currentpeg: dd 0
mvcounter: dd 0
;FORMATS
pegfmt: db "%s", 10,0
fmt: db "The input is: %d",10,0
decFormat   db '%d',10 					; Format string to use in printf
null: db "",10,0
t0: db "         |             ",0 		; Define each level of the tower
t1: db "        +|+            ",0
t2: db "       ++|++           ",0
t3: db "      +++|+++          ",0
t4: db "     ++++|++++         ",0
t5: db "    +++++|+++++        ",0
t6: db "   ++++++|++++++       ",0
t7: db "  +++++++|+++++++      ",0 
t8: db " ++++++++|++++++++     ",0
t9: db "XXXXXXXXXXXXXXXXXXX    ",0

; status messages
finished:db "You are done!!", 10, 0
waiting: db "Waiting for input: ", 10,0

; PEGS/TOWERS
peg1: dd 0,0,0,0,0,0,0,0,9     
peg2: dd 0,0,0,0,0,0,0,0,9
peg3: dd 0,0,0,0,0,0,0,0,9
store: dd 0

;ERROR MESSAGES
Lt2Error: db "ERROR: size is less than 2, must be 2 < size < 8", 10, 0
Gt8Error: db "ERROR: size is greater than 8, must be 2 < size < 8", 10, 0
WrongAmount: db "ERROR: Wrong amount of arguments",10,0
SECTION .text
global main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                                MAIN           	                   ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:       
   enter 0,0
   pusha
   call GetHanoiSize      	; Get the input size of the tower
   cmp dword[argnum], 2  	; check if argnum is less than two
   jne WrongAmountOfArgs  	; 
   cmp dword [size], 2 		; size < 2
   jl LessThan2Error 	    ; jump to error
   cmp dword [size], 8 		; size > 8
   jg MoreThan8Error 	    ; jumpt to error
   call arrangearray      	; set up the arrays 
   call display_pegs   		; print the full tower once
  ; call getchar        	; pause before starting algorithm 
   call solve             	; solve the tower recursively
   call Exit              	; exit program

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                       Solve function (Recursive)                    ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
solve:
  mov eax,dword[size] ; the size into eax
  mov ebx, peg1       ; each peg into eax,ebx,ecx respectively
  mov ecx, peg2       ; destination
  mov edx, peg3       ; spare
solveloop:			  ; this is the loop that will do recurssion
  cmp eax, 1 	      ; if (size != 1)
  je move 			  ; jump to else
  je exitsolve	      ; exit the loop
  else:               ; recurse solveloop(disk-1, source,spare,dest)
  pusha               ; push the registers
  push eax            ; store eax to use as a temp
  mov eax, edx        ; move spare into temp
  mov edx, ecx        ; move dest into the 
  mov ecx, eax        ; move temp into dest
  pop eax             ; restore eax to its counter
  dec eax             ; take one off of eax
  call solveloop      ; recurse on the left side of the tree
  popa                ; restore the registers after the recursive call
  pusha               ; save registers before move
  call move           ; move the item
  popa                ; estore registers from move
  pusha               ; recurse 2 solveloop (disk-1,spare,dest,source)
  push eax            ;spare = source  dest = spare    source = dest
  mov eax, ebx        ; this part of the code shuffles around the pegs so we can call
  mov ebx, edx        ; move the temp into the dest
  mov edx, eax        ; move the temp into edx
  pop eax             ; restore eax to the counter
  dec eax             ; decrement counter
  call solveloop      ; call the recursive function on the right halfof the tree
  popa                ; restore registers to what they were before the recursive calls
exitsolve:            ; exit the solve function and return to main
  ret                 ; return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                             Move function                           ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; takes 3 variables, in eax it takes the size, in ebx it takes the source, in ecx it takes the destination
; move (size, source[], dest[])
move: 
  enter 0,0
  push edx
  mov edx, 0 
  loop1:                       		; Enter first loop to remove a disk
    cmp dword [ebx + edx], 0  		; if (peg1[n] = 0)
    jne else1 					    ; jump to else1... means we have found the next disk 
    add edx, 4
    call loop1					    ; loop 
   else1:                           ; this else statement replaces the current item in that slot with 0
    mov dword[ebx + edx], 0         ; put 0 into the place we found 
  mov edx, 0                        ; move the counter into ecx
  loop2:
    cmp dword [ecx + edx],dword 0   ; if (peg1[n] = 0)
    jne else2                       ; jump to else2... means we have found the next disk 
    add edx, 4                      ; increment counter by 4
    call loop2                      ; looperino kappa
   else2:
    mov dword[edx + ecx- 4], eax    ; get the place 
  pop edx
  pusha                             ; store the registers before call
  call display_pegs                 ; print the pegs
  popa                              ; restore registers from finvtion call
  leave                             ; return 
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                             Move function                           ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
arrangearray:                       ; sets up the initial array
  enter 0,0                         
  pusha
  mov ecx, dword[size]              ; move size into disk counter
  mov ebx,7                         ; move 7 into second counter
  setuploop: 
    mov dword [peg1 + 4 * ebx], ecx ; move the current size into this piece of the array
    dec ecx 						; decrement the size by one, so we get a tower shape!
    cmp ecx, 0                      ; decrement ecx and see if its 0
    je setupdone 					; if its 0 we are done 
    dec ebx                         ; decrement and compare loop variable
    cmp ebx, 0                      ; compare loop variable
    jge setuploop 					; otherwise keep going until the counter is done, infinite loop protection
setupdone:
  popa 								; pop registers and return to our main method
  leave
  ret

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                            Display function                         ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
display_pegs: 
  enter 0,0             	; setup routine

  mov ebx, 0       			; define our counter i
  layerloop:
  push eax                  ; save registers 
  push ebx
  mov eax, [peg1+ 4*ebx]    ; eax = peg1[i*4], gets teh item in that place of the array
  call getpeg 				; prints the item based on the number in the peg array
  mov eax, [peg2+ 4*ebx]	; eax = peg2[i*4] 
  call getpeg 				; prints the item based on the number in the peg array
  mov eax, [peg3+ 4*ebx]	; eax = peg3[i*4] 
  call getpeg 				; prints the item based on the number in the peg array
  pop ebx					; return registers after function call
  pop eax

  push null  			   	; print a new line character 
  call printf 			   	; call print
  add esp, 4 				; adjust stack

  inc ebx   				; increment and check the loop condition
  cmp ebx, 8 				; see if we are done our loop
  jle layerloop
  pusha                 	; save all registers

  push waiting 				; print out the waiting message
  call printf
  add esp, 4
  call getchar 				; call our program stall, waits for a character

  popa 						; pop all registers and return
  leave
  ret
getpeg:
  enter 0,0
  tt0:
    cmp eax, 0            	; check if the element sent is 0
    jnz tt1              	; if it is not go to the next if
    push t0 			 	; otehrwise push that piece of the tree for printing
    jmp done 			 	; jump to where we print it
  tt1:
    cmp eax, 1 	            ; all of these do the same thign as the first one, see above
    jne tt2
    push t1
    jmp done
  tt2:
    cmp eax, 2
    jne tt3
    push t2
    jmp done
  tt3:
    cmp eax, 3
    jne tt4
    push t3
    jmp done
  tt4:
    cmp eax, 4
    jne tt5
    push t4
    jmp done
  tt5:
    cmp eax, 5
    jne tt6
    push t5
    jmp done
  tt6:
    cmp eax, 6
    jne tt7
    push t6
    jmp done
  tt7:
    cmp eax, 7
    jne tt8
    push t7
    jmp done
  tt8:
    cmp eax, 8
    jne tt9
    push t8
    jmp done
  tt9:
    cmp eax, 9
    jne done
    push t9
    jmp done
  done:
    call printf 			; prints message
    add esp, 4 				; adjust pointer
  leave 					; return to the caller
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                       Get Command Line Argument                     ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetHanoiSize:				; gets the size from the user and stores it in the size memory address
  pusha
  mov ebx, dword [ebp + 8]
  mov dword [argnum], ebx
  mov eax, dword [ebp+12]   ; 2nd argument = 1st argument for the program
  add eax, 4
  mov ebx, dword [eax]      ; ebx points to arg 1
  mov ecx, 0
  mov cl, byte [ebx]        ; cl holds 1st digit ot arg 1
  sub ecx, '0'              ; turn it into number
  mov dword [size], ecx
  popa
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;                               Error Handling                        ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LessThan2Error:
  push Lt2Error 	 		; push the error
  call printf  	   			; print
  add  esp, 4       		; add to stack
  call Exit  	 	    	; Go to exit
MoreThan8Error:
  push Gt8Error 	  		; push the error
  call printf 	    		; print
  add  esp, 4       		; add to stack
  call Exit 		    	; Go to exit
WrongAmountOfArgs:
  push WrongAmount 			; Push the error
  call printf 				; print
  add esp, 4   				; adjust pointer
  call Exit 				; currently redundant exit call, added in case of future additions
Exit:
  push finished   			; Print the finished message
  call printf
  add esp, 4
  leave 					; Exit the Program
  ret
