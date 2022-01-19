.model small

macro adding_only a b c d
    
    
    sub bx,bx
    mov al, a               ; a
 
    sub al, 30h
    mov bh, al   ; first digit of first char
    
    mov al, b                ; b
    
    sub al, 30h
    mov bl, al   ; Second digit of 1st number 
    
    ;; Bh, Bl  == First number  == a, b
    
    mov al, c                 ; c
    
    sub al, 30h        ; first digit of 2nd number
    mov ch, al
    
    
    mov al, d                 ; d
    
    sub al, 30h            ;2nd digit of 2nd number
    mov cl, al
    
    ;; Ch, cl == Second Number
    
    
    ADD bl, cl          ; Adding tenth position of both numbers
    
    mov al, bl
    mov ah, 00h
    aaa 
    
    mov cl, al
    mov bl, ah
    
    add bl, bh
    add bl, ch
    
    mov al, bl
    mov ah, 00h
    aaa
    
    mov bx, ax
    
    mov dl, bh
    add dl, 30h        ; carry (We can discard it), Useful when answer is 3 digit
    mov digit_one , dl
  
           
    mov dl, bl
    add dl, 30h
    mov ah, 02
    mov digit_two, dl
    
    mov dl, cl
    add dl, 30h
    mov digit_three, dl
    
endm

macro printing_total
    
    mov ah, 02
    mov dl, digit_one
    int 21h
    
    mov ah, 02
    mov dl, digit_two
    int 21h       
    
    mov ah, 02
    mov dl, digit_three
    int 21h
    
endm

macro lfcr  
   mov ah, 02
   mov dl, 10
   int 21h
   mov dl, 13
   int 21h
endm

macro print_string string
    mov ah, 09
    lea dx, string
    int 21h
endm

macro print_char c
    mov ah, 02
    mov dl, c
    int 21h
endm     

macro take_input
    mov ah, 01
    int 21h
endm    

.stack 100h
.data      
     clearline db "                                      $"
     wel1 db "******************************************$"
     wel2 db "*                                        *$"
     wel3 db "*                                        *$"
     wel4 db "*                                        *$"
     wel5 db "*  WELCOME TO PARKING MANAGEMENT SYSTEM  *$"
     wel6 db "*                                        *$"
     wel7 db "*                                        *$"
     wel8 db "*                                        *$"
     wel9 db "******************************************$"
     
     limit1 db "Limit for bicycles is: 8$"
     limit2 db "Limit for bikes is: 8$"
     limit3 db "Limit for car is: 5$"
     limit4 db "Limit for trucks is: 2$"  
     
     price0 db "Price per vehicle: $"
     price1 db "Bicycle: 10$"
     price2 db "Bike: 15$"
     price3 db "Car: 20$"
     price4 db "Truck: 30$" 
     
     ; Prices (USE in Calculation)
     
     bicA db 1
     bicB db 0
     
     bikA db 1
     bikB db 5
     
     carA db 2
     carB db 0 
     
     truckA db 3
     truckB db 0        
              
     line1 db "Press 1 for booking space for Bicycle$"
     line2 db "Press 2 for booking space for Bike$"
     line3 db "Press 3 for booking space for Car$"
     line4 db "Press 4 for booking space for Truck$"    
     line5 db "Press 6 to show all the records$"
     line6 db "Press 7 to delete all the records$"
     line7 db "Press 0 to Exit$"                  
     
     bicycleCount db '0'
     bikeCount db '0'
     carCount db '0'
     truckCount db '0' 
     
     bicpark db "Bicycle has allocated Space $"
     bikpark db "Bike has allocated Space $" 
     carpark db "Car has allocated Space $"
     truckpark db "Truck has allocated Space $" 
     
     gap db "************************************$"
     
     bicMsg db "Bicycle parking is full!$"
     bikMsg db "Bike parking is full!$"
     cMsg db "Car parking is full!$"
     tMsg db "Truck parking is full!$"
     
     wrongInput db "WRONG INPUT!$"    
     
     bic db "No. of bicycles: $"
     bik db "No. of bikes: $ "
     c db "No. of cars: $"
     t db "No. of trucks: $"  
     amt db "Total amount is: $"
     
     dltd db "RECORDS DELETED SUCCESSFULLY!$"
     
     totalAmount dw 00 
     digit_one db 0
     digit_two db 0
     digit_three db 0
     
.code

main proc
    mov ax, @data
    mov ds, ax
    
    ;printing welcome message
    
    print_string wel1      
    lfcr
    print_string wel2
    lfcr
    print_string wel3
    lfcr
    print_string wel4  
    lfcr
    print_string wel5 
    lfcr
    print_string wel6   
    lfcr
    print_string wel7 
    lfcr
    print_string wel8 
    lfcr
    print_string wel9   
    lfcr   
      
    ;clearing screen
    call clearScreen
    lfcr 
      
    ;printing limits message
    
    print_string limit1
    lfcr
    print_string limit2
    lfcr
    print_string limit3
    lfcr
    print_string limit4  
    lfcr                 
    
    ;printing gap 
    lfcr
    print_string gap
    lfcr
    lfcr
    
    ;printing prices
    
    print_string price0
    lfcr
    print_string price1
    lfcr
    print_string price2
    lfcr
    print_string price3
    lfcr
    print_string price4
    lfcr
    
    ;clearing screen
    call clearScreen
    
    
start:    
    ;printing menu
    lfcr
    print_string line1
    lfcr
    print_string line2
    lfcr
    print_string line3
    lfcr
    print_string line4
    lfcr
    print_string line5
    lfcr
    print_string line6
    lfcr
    print_string line7
    lfcr         
    
    
            
    ;taking input
    lfcr
    take_input       
    mov bl, al
    lfcr
    
    ;comparing
    
    mov al, bl
    cmp al, '1'
    je bicycle
    cmp al, '2'
    je bike    
    cmp al, '3'
    je car    
    cmp al, '4'
    je truck        
    cmp al, '6'
    je show_records
    cmp al, '7'
    je delete_records
    cmp al, '0'
    je exit  
    
    ;else print wrong input
    print_string wrongInput
    lfcr
    
    ;labels
    
    bicycle:
       call bicycleProc
    bike:
       call bikeProc
    car:
       call carProc
    truck:
       call truckProc
    show_records:
       call showProc
    delete_records:
       call deleteProc
    exit:
        mov ah, 4ch
        int 21h            
         
main endp 

bicycleProc proc
    cmp bicycleCount, '8'
    jle b1       
    print_string bicMsg
    jmp start
    jmp exit
    
    b1: 
        print_string bicpark 
        lfcr
        adding_only digit_two digit_three bicA bicB 
        inc bicycleCount
        jmp start
        jmp exit
                   
bikeProc proc
    cmp bikeCount, '8'
    jle b01       
    print_string bikMsg
    jmp start
    jmp exit
    
    b01: 
        print_string bikpark 
        lfcr
        
         adding_only digit_two digit_three bikA bikB 
        inc bikeCount
        jmp start
        jmp exit                   
                   
carProc proc
    cmp carCount, '5'
    jle c1
    print_string cMsg
    jmp start
    jmp exit
    
    c1:   
        print_string carpark 
        lfcr
        
         adding_only digit_two digit_three carA carB
        inc carCount
        jmp start
        jmp exit
        
truckProc proc
    cmp truckCount, '2'
    jle t1     
    lfcr
    print_string tMsg
    lfcr
    jmp start
    jmp exit
    
    t1:  
        print_string truckpark 
        lfcr
        
         adding_only digit_two digit_three truckA truckB
        inc truckCount
        jmp start
        jmp exit
        
showProc proc      
    call clearscreen
    lfcr
    
    print_string amt  
    
    printing_total
    
    lfcr
    print_string bic
    lfcr
    print_char bicycleCount   
    lfcr
    print_string bik
    lfcr
    print_char bikeCount
    lfcr
    print_string c
    lfcr
    print_char carCount 
    lfcr
    print_string t
    lfcr
    print_char truckCount   
    lfcr
    
    jmp start 
    
deleteProc proc
    mov bicycleCount, '0'
    mov bikeCount, '0'
    mov carCount, '0'
    mov truckCount, '0'        
    mov digit_one, '0'
    mov digit_two, '0'
    mov digit_three, '0'
    lfcr
    print_string dltd
    lfcr
    
    
jmp start
jmp exit

clearScreen proc  
    mov ah, 02
    mov bx, 0
	mov dl, 0  ;column
	mov dh, 0  ;row
	int 10h 
	mov cx, 50
	lp:       
    	
    	mov ah,09 
        lea dx, clearline
        int 21h 
    	
	loop lp         
	
    ret


end main
    
    