;By Logan Powers
;5/8/18

;necessary commands
INCLUDELIB libcmt.lib
INCLUDELIB legacy_stdio_definitions.lib
EXTERN printf:PROC
EXTERN scanf:PROC

.DATA

;get user numbers
	prompt BYTE  "Enter a number for N: ",0
	prompt3 BYTE "Enter a number for R: ",0

;formats
	inFmt  BYTE  "%d", 0
	inFmt2 BYTE "%s", 0


;printF's
	answer BYTE "The factorial is %1d",10, 0
	answer2Combo BYTE "That combination is %1d", 10,0
	answer2Permu BYTE "That permutation is %1d", 10,0
	prompt2 BYTE "Would you like to perform another operation?", 10,0
	disp   BYTE  "You Entered %d", 10,0

;for main menu
	disp2 BYTE "---------------------------", 13,10
	disp3 BYTE "Please choose",13,10
	disp4 BYTE "1. Combination",13,10
	disp5 BYTE "2. Permutation",13,10

;for user input
	num    QWORD ? ; used for menu choice
	numR QWORD ? ; holds R
	userInput QWORD ? ; holds N

;for continue
	continue QWORD ?
	yes BYTE "yes",0

.CODE
main PROC C


;clear registers, heard it was good practice
	mov rdx, 0
	mov rax, 0
	mov rbx, 0
	mov rsi, 0
	mov rdi, 0
	mov rcx, 0
	mov r8, 0
	mov r9, 0
	mov r10, 0
	mov r11, 0
	mov r12, 0
	mov r13, 0
	mov r14, 0
	mov r15, 0

;sets up stack
	sub rsp, 120

;reads in user in put for N value
	lea rcx, prompt           
	call printf
	lea rdx, userInput             
    lea rcx, inFmt            
	call scanf

;moves N value to rdx then pushes that onto stack for factorial calculation
	mov rdx, userInput
	push rdx

;gets value for factorial from rax and prints it
	call Fact 
	mov rdx, rax
	lea rcx, answer
	call printf

;gets R value
	lea rcx, prompt3           
	call printf
	lea rdx, numR             
    lea rcx, inFmt            
	call scanf

;prints initial menu and gets user input, stores it in rdx to allow for comparison
	lea rcx,disp2			   
	call printf
    lea rdx, num              
    lea rcx, inFmt            
    call scanf
    mov rdx,num                  

;puts user N and R on the stack
	push numR
	push userInput

; compares rdx to see if we should do a combo or a permu
	CMP rdx, 1
	jne permuStart
	call Combo
	mov rdx, rax
	lea rcx, answer2Combo
	call printf

; compares again because if not doing combo would still call permu
	mov rdx, num
	cmp rdx, 2
	jne skip
	permuStart:
		call Permu
		mov rdx, rax
		lea rcx, answer2Permu
		call printf
	skip:

;gets user input on weither to continue or not
	lea rcx, prompt2           
	call printf
	lea rdx, continue             
	lea rcx, inFmt2           
	call scanf
	mov rax, continue

;does the comparison to see if a yes was entered
	lea rsi, continue
	lea rdi, yes
	mov rcx, 4
	repe cmpsb
	jne xt

;if so
	call main
	xt:

;if not	
	add rsp,120                  
    mov rax,0
    ret
;closes program and stack out without error
main ENDP

Fact PROC
;You gave us most of this code, just had to make a few small changes
;first 2 are necessary to set up stack
	push rbp
	mov rbp,rsp

	mov rax, [rbp + 16]
	cmp rax, 1
	jle quit
	dec rax 
	push rax

;recursive
	call Fact
	mov rbx, [rbp+16]
	imul rbx

	quit:
;necessary instructions to close out stack
	mov rsp, rbp
	pop rbp
	ret
Fact ENDP

Combo PROC
;(n!)/r!(n-r)!
;first 2 are necessary to set up stack
	push rbp
	mov  rbp, rsp        ; Stack frame

;puts N and R into registers
	mov  r14, [rbp + 16] ; n
	mov  rcx, [rbp + 24] ; r

;pushes N, factors it and then pops it from the stack
	push r14            
	call fact            
	mov  r15, rax       
	pop  r14             
	
;gets factorial of R
	push rcx
	call fact
	pop  rcx
	mov  r12, rax       

;subtracts  N-R
	sub  r14, rcx       

;after subtracting this now finds the factorial of n-r and moves it to r13
	push r14          
	call fact
	pop  r14
	mov  r13, rax       

;the before parts were calculating all the different parts of the equation
;this part is putting all those together
;r12 holds r! so we move that to rax
	mov  rax, r12     
;then we multiply the R! and the (n-r)!
	mul  r13      
	mov  r14, rax 
;move n! to rax
	mov  rax, r15       
;finally divides the top and bottom, giving answer in rax
	div  r14             

;necessary instructions to close out stack
	mov  rsp, rbp
	pop  rbp
	ret	
Combo ENDP

Permu PROC
;n!/(n-r)!
;permutation is pretty much the same as combination besides multipying the bottom by R!
;first 2 are necessary to set up stack
	push rbp
	mov  rbp, rsp        ; Stack frame

;puts N and R into registers
	mov  r14, [rbp + 16] ; N
	mov  rcx, [rbp + 24] ; R

;pushes N, factors it and then pops it from the stack
	push r14            
	call fact           
	mov  r15, rax       
	pop  r14       
	
;gets factorial of R
	push rcx
	call fact
	pop  rcx
	mov  r12, rax       

;subtracts  N-R
	sub  r14, rcx        ; (n-r) in r15

;after subtracting this now finds the factorial of n-r
	push r14             
	call fact
	pop  r14

;the before parts were calculating all the different parts of the equation
;this part is putting all those together
;r13 will hold (n-r)! after this
	mov  r13, rax       
	mov  rax, r15       
	div  r13            

;necessary instructions to close out stack
	mov  rsp, rbp
	pop  rbp
	ret
Permu ENDP

END