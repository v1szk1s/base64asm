/*
 *     author: Ambrus Attila
 *      
 *      Ez az arm 32 bites assembly kód  base64 titkosítással encodol egy szöveget.
 *      base_64(char *text, char *dest);
 */

.syntax unified
.cpu cortex-a7

.data
TABLE:
    .asciz "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    //az egyenloseg jel: 75 0x4b 
c:
    .asciz "-> %c <-\n"
d:
  .asciz "-> %d\n"
.text
.global base64_encode
base64_encode:
    push {r4-r11, lr}       // prologus

    mov r9, 0
    mov r4, 3               //szamlalo
    mov r5, r0              // r5 := &text
    mov r6, r1              // r6 := &dest
    ldr r2, =TABLE

  _loop:

    
  //egy
    sub r4, r4, 3
    ldrb r1, [r5, r4]           // r1 := text[r4] 
    
   // push {r1}
   // ldr r0, =c
   // //mov r1, 
   // bl printf
   // pop {r1}

    cmp r1, #0                  // r1 == 0 -> _end
    beq _end  
    push {r1}
    lsr r1, #2                  // r1 >> 2  //elso hat bit kesz
    ldr r2, =TABLE              //r2 := &table
    ldr r3, [r2, r1]            // r3 = TABLE[r1]
    strb r3, [r6, r9]
    add r9, r9, #1

    add r4, r4, 3

  //ketto
    sub r4, r4, #2              // minden 2. at nezzuk
    ldrb r1, [r5, r4]           // r1 := r5 + r4, masodik betu r1 be
    cmp r1, #0                  // text[r4] == 0: ketto
    pop {r7}        //elso betu
    beq ketto       // mivel most 2 egyenloseg jel kell

    push {r1}

    and r7, #3
    lsl r7, #4                  //elso betu r7 << 6

    lsr r1, #4                  // r1 >> 2
    orr r1, r1, r7              //r1 | r7

    ldr r2, =TABLE              //r2 := &table
    ldr r3, [r2, r1]            // r3 = TABLE[r1]
    strb r3, [r6, r9]            // dest[r4] = r3
    add r9, r9, #1
    
    add r4, r4, #2

//harom
    sub r4, r4, #1         
    ldrb r1, [r5, r4]           // r1 := r5 + r4, harmadik betu r1 be

    cmp r1, #0                // text[r4] == 0: egy
    pop {r7}
    beq egy
    push {r1}

    and r7, #0xF
    lsl r7, #2                  //elso betu
    and r1, #0xC0
    lsr r1, #6                  // r1 >> 2
    orr r1, r1, r7              //r1 | r7

    ldr r2, =TABLE              //r2 := &table
    ldr r3, [r2, r1]            // r3 = *(r2+r1)
    strb r3, [r6, r9]            // *dest = r3
    add r9, r9, #1

 
 
 //negy
    pop {r1}
    and r1, #0x3F

    ldr r2, =TABLE              //r2 := &table
    ldr r3, [r2, r1]            // r3 = *(r2+r1)

    mov r1, r3
    //ldr r0, =c
    //bl printf

    strb r3, [r6, r9]            // *dest = r3
    add r9, r9, #1



    add r4, r4, #4
    b _loop

  egy:        //r7 masodik betu
    and r7, r7, #0xF
    lsl r7, #2
    ldr r2, =TABLE              //r2 := &table
    ldr r3, [r2, r7]
    strb r3, [r6, r9]
    add r9, r9, #1
    mov r3, #0x3d
    strb r3, [r6, r9]
    b _end

  ketto:            // r7 be elso betu r1 be masodik betu 

    and r7, #0x3
    lsl r7, #4

    ldr r2, =TABLE              //r2 := &table
    ldr r3, [r2, r7]            // r3 = *(r2+r1)
    strb r3, [r6, r9]            // *dest = r3
    add r9, r9, #1

    mov r3, #0x3d
    strb r3, [r6, r9]
    add r9, r9, #1
    strb r3, [r6, r9]

  _end:

    add r9, r9, #1
    mov r3, #0
    strb r3, [r6, r9]


    //mov sp, fp
    pop {r4-r11, pc}        // epilogus