;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      : Calculator
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.586
.model  flat, stdcall
option casemap:none

; Link in the CRT.
includelib libcmt.lib
includelib libvcruntime.lib
includelib libucrt.lib
includelib legacy_stdio_definitions.lib

extern printf:NEAR
extern scanf:NEAR
extern _getch:NEAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.data
    chooseStr db  0ah,'Choose what opperation you will like to do: ', 0ah, 0ah, 0
    additionStr db 'Enter 1 for addition: ', 0ah, 0                                                             ; 1 for additison
    subtractionStr db 'Enter 2 for subtraction: ', 0ah, 0                                                       ; 2 for subtraction
    divisionStr db 'Enter 3 for division: ', 0ah, 0                                                             ; 3 for division
    multiplicationStr db 'Enter 4 for multiplication: ', 0ah, 0                                                 ; 4 for multiplication
    quitStr db 'Enter q to quit: ', 0ah, 0ah, 0                                                                 ; q to quit
    ;---------------------------------------------------------------------------------------------------;
    ;---------------------------------------------------------------------------------------------------;   
    numbersToSumStr db 'Enter a of addends: ', 0
    addendStr db 'Enter a addend: ', 0
    ;---------------------------------------------------------------------------------------------------;
    ;---------------------------------------------------------------------------------------------------;       
    minuendStr db 'Enter a minuend: ', 0
    subtrahendStr db 'Enter a subtrahend: ', 0
    ;---------------------------------------------------------------------------------------------------;
    ;---------------------------------------------------------------------------------------------------;       
    dividendStr db 'Enter a dividend: ', 0
    divisorStr db 'Enter a divisor: ', 0
    ;---------------------------------------------------------------------------------------------------;
    ;---------------------------------------------------------------------------------------------------;       
    multiplicandStr db 'Enter a multiplicand: ', 0
    multiplierStr db 'Enter a multiplier: ', 0
    ;---------------------------------------------------------------------------------------------------;
    ;---------------------------------------------------------------------------------------------------;    
    printStr db 0ah,'Result: %d', 0ah, 0
    scanfStr db '%d', 0
.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; Main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main proc C
                push ebp 
                mov ebp, esp

                call Calculator  

                mov esp, ebp
                pop ebp
                xor eax, eax
                ret
main endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; ScanF wrapper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MasmScanf PROC
                push ebp
                mov ebp, esp

                sub esp, 4

                mov edx, ebp  ; address of local variable
                sub edx, 4
                push edx

                push offset scanfStr
                call scanf   ; this subs 4

                add esp, 8 ; restore

                mov eax, [ebp - 4] ; returning the local variable

                mov esp, ebp
                pop ebp
                ret
MasmScanf ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Main menu print prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MainMenuDisplay PROC
                push ebp
                mov ebp, esp

                push offset chooseStr  
                call printf

                push offset additionStr  
                call printf

                push offset subtractionStr  
                call printf

                push offset divisionStr  
                call printf

                push offset multiplicationStr  
                call printf

                push offset quitStr  
                call printf
                add esp, 24      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
MainMenuDisplay ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        Addition Land
        ; Addition prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NumberToSumPrompt PROC
                push ebp
                mov ebp, esp

                push offset numbersToSumStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
NumberToSumPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Addition prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AdditionPrompt PROC
                push ebp
                mov ebp, esp

                push offset addendStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
AdditionPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Addition operation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AddOperation PROC
                push ebp
                mov ebp, esp

                mov eax, [ebp + 12] ; getting parameters
                mov ecx, [ebp + 8]

                add eax, ecx

                mov esp, ebp
                pop ebp
                ret 8
AddOperation ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Addition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AdditionBranch PROC
                push ebp
                mov ebp, esp

                push ebx            ; save ebx now need for looping in

                call NumberToSumPrompt 
                call MasmScanf

                mov ebx, eax        ; using ebx now to hold number of times around in the loop

                push 0              ; first param for add operation proc call 

        NumbersToSum:

                call AdditionPrompt 
                call MasmScanf

                push eax             ; pushing result to stack

                call AddOperation    ; adding the two numbers on the stack cleans stack on return 
                push eax             ; pushing result to stack
            
                sub ebx, 1           ; evey time around - 1 

                cmp ebx, 0           ; if ecx is 0 then stop looping
                jne NumbersToSum     ; after loop has ended eax should be the sum of all addends

                push offset printStr ; print final sum 
                call printf
                add esp, 8           ; clean after call

                pop ebx              ; restore ebx no longer in use

                mov esp, ebp
                pop ebp
                ret
AdditionBranch ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Minuend prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MinuendPrompt PROC
                push ebp
                mov ebp, esp

                push offset minuendStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
MinuendPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        Subtraction Land
        ; Subtraction prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SubtrahendPrompt PROC
                push ebp
                mov ebp, esp

                push offset subtrahendStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
SubtrahendPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Subtraction operation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SubtractionOperation PROC
                push ebp
                mov ebp, esp

                mov eax, [ebp + 12] ; getting parameters
                mov ecx, [ebp + 8]

                sub eax, ecx

                mov esp, ebp
                pop ebp
                ret 8
SubtractionOperation ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Subtraction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SubtractionBranch PROC
                push ebp
                mov ebp, esp

                call MinuendPrompt

                call MasmScanf
                push eax             ; pushing user entered number for later use

                call SubtrahendPrompt

                call MasmScanf
                push eax             ; pushing user entered number for later use

                call SubtractionOperation ; operation uses the last two masmScanf returns and cleans in proc

                push eax
                push offset printStr
                call printf
                add esp, 8

                mov esp, ebp
                pop ebp
                ret
SubtractionBranch ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        Multiplication Land
        ; Multiplicand prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MultiplicandPrompt PROC
                push ebp
                mov ebp, esp

                push offset multiplicandStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
MultiplicandPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Multiplier prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MultiplierPrompt PROC
                push ebp
                mov ebp, esp

                push offset multiplierStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
MultiplierPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Multiplication operation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MultiplicationOperation PROC
                push ebp
                mov ebp, esp

                mov eax, [ebp + 12] ; getting parameters
                mov ecx, [ebp + 8]

                mul ecx

                mov esp, ebp
                pop ebp
                ret 8
MultiplicationOperation ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Multiplication
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MultiplicationBranch PROC
                push ebp
                mov ebp, esp

                mov eax, 0

                call MultiplicandPrompt

                call MasmScanf
                push eax             ; pushing user entered number for later use 

                call MultiplierPrompt

                call MasmScanf
                push eax             ; pushing user entered number for later use

                call MultiplicationOperation

                push eax
                push offset printStr
                call printf
                add esp, 8

                mov esp, ebp
                pop ebp
                ret
MultiplicationBranch ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        Division Land
        ; Dividend prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DividendPrompt PROC
                push ebp
                mov ebp, esp

                push offset dividendStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
DividendPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Divisor prompt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DivisorPrompt PROC
                push ebp
                mov ebp, esp

                push offset divisorStr  
                call printf
                add esp, 4      ; reset from calls

                mov esp, ebp
                pop ebp
                ret
DivisorPrompt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Divide operation Truncates remainder
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DivideTruncate PROC
                push ebp
                mov ebp, esp

                mov edx, 0 ; 0 edx before to prevent overflow 

                mov eax, [ebp + 12] ; getting parameters prepped #Mise en Place
                mov ecx, [ebp + 8]

                cmp eax, 0         ; if eax or ecx is 0 return out to prevent / by 0 crash
                je ProcReturn

                cmp ecx, 0
                je ProcReturn

                idiv ecx

        ProcReturn:
                mov esp, ebp
                pop ebp
                ret 8
DivideTruncate ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Division
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DivisionBranch PROC
                push ebp
                mov ebp, esp

                mov eax, 0

                call DividendPrompt

                call MasmScanf
                push eax             ; pushing user entered number for later use

                call DivisorPrompt

                call MasmScanf
                push eax             ; pushing user entered number for later use

                call DivideTruncate

                push eax
                push offset printStr
                call printf
                add esp, 8

                mov esp, ebp
                pop ebp
                ret
DivisionBranch ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        Calculator Land
        ; Calculator 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Calculator PROC
                push ebp
                mov ebp, esp
        MainMenu:
           
                call MainMenuDisplay ; main menu print
                call _getch

                cmp eax, 'q' 
                je Exit

                cmp eax, '1' 
                je Addition

                cmp eax, '2' 
                je Subtraction

                cmp eax, '3' 
                je Division

                cmp eax, '4' 
                je Multiplication

                jmp MainMenu

        Addition:

                call AdditionBranch
                jmp MainMenu         

        Subtraction:

                call SubtractionBranch
                jmp MainMenu  

        Division:
                call DivisionBranch
                jmp MainMenu  

        Multiplication:

                call MultiplicationBranch
                jmp MainMenu 
        Exit:

                mov esp, ebp
                pop ebp
                ret
Calculator endp
END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
