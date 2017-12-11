# @file     queen.S
# @author   wangqr
#
# This is the homework 9 of course THU-30230793-2016-Spring.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
#    The above copyright notice and this permission notice shall be included in
#    all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# +--------------------------------------------------------------+
# |    Bootstrap                                                 |
# +--------------------------------------------------------------+
    .text
    jal     main
    move    $a0,$v0
    li      $v0,10
    syscall


# +--------------------------------------------------------------+
# |    Begin of function 'Valid'                                 |
# +--------------------------------------------------------------+
    .text
    .globl  Valid

# int Valid(int n)
Valid:

#   $a0 = $a3 = n - i
#   $a2 = Site[n]
#   $v1 = &Site[i]

#     for (i = 0; i < n; i++)   // @ (i = 0)
    blez    $a0,L4
    sll     $a1,$a0,2

#         if (Site[i] == Site[n]) return 0;
    addu    $v1,$a1,$gp # la      $v1,Site
                        # addu    $v1,$a1,$v1
    lw      $v0,0($gp)  # lw      $v0,Site
    lw      $a2,0($v1)
    beq     $v0,$a2,L2

#         if (abs(Site[i] - Site[n]) == (n - i)) return 0;
    subu    $v0,$v0,$a2
    bltz    $v0,L5

L0:
    beq     $a0,$v0,L2
    addiu   $v1,$gp,4

#     for (i = 0; i < n; i++)   // @ (i > 0)
L1:
    addiu   $a0,$a0,-1
    beqz    $a0,L4
  # move    $a3,$a0

#         if (Site[i] == Site[n])
    lw      $a1,0($v1)
    beq     $a1,$a2,L2
    subu    $v0,$a1,$a2

#         if (abs(Site[i] - Site[n]) == (n - i))
    addiu   $v1,$v1,4
    bltz    $v0,L3
    bne     $v0,$a0,L1

#             return 0;
L2:
    move    $v0,$zero
    jr      $ra

#         if (abs(Site[i] - Site[n]) == (n - i))
L3:
    subu    $v0,$zero,$v0
    bne     $v0,$a0,L1

#             return 0;
    move    $v0,$zero
    jr      $ra

#     return 1;
L4:
    li      $v0,1
    jr      $ra

#         if (abs(Site[i] - Site[n]) == (n - i))
L5:
    subu    $v0,$zero,$v0
    j       L0

# +--------------------------------------------------------------+
# |    End of function 'Valid'                                   |
# +--------------------------------------------------------------+


# +--------------------------------------------------------------+
# |    Begin of function 'Queen'                                 |
# +--------------------------------------------------------------+
    .text
    .globl  Queen

# int Queen(int n, int QUEENS, int iCount)
Queen:

# $s0 = i
# $s1 = QUEENS
# $s2 = n
# $s3 = &Site[i]
# $s4 = n + 1
# $s5 = iCount

#     if (n == QUEENS)
    beq     $a0,$a1,L9

    addiu   $sp,$sp,-28
    sw      $s5,20($sp)
    sw      $s2,8($sp)
    sw      $s1,4($sp)
    sw      $ra,24($sp)
  # sw      $s4,16($sp)
    sw      $s3,12($sp)
    sw      $s0,0($sp)
    move    $s2,$a0
    move    $s1,$a1
    move    $s5,$a2

#     for (i = 1; i <= QUEENS; i++)
  # blez    $a1,L8
    sll     $v0,$a0,2
    addu    $s3,$gp,$v0 # la      $s3,Site
                        # addu    $s3,$s3,$v0
    li      $s0,1
  # addiu   $s4,$a0,1
    j       L7

L6:
    slt     $v0,$s1,$s0
    bnez    $v0,L8

#         Site[n] = i;
#         if (Valid(n))
L7:
    sw      $s0,0($s3)
    move    $a0,$s2
    jal     Valid

    addiu   $s0,$s0,1
    beqz    $v0,L6

#             iCount = Queen(n + 1, QUEENS, iCount);
    move    $a2,$s5
    addiu   $a0,$s2,1   # move    $a0,$s4
    move    $a1,$s1
    jal     Queen

    move    $s5,$v0
    slt     $v0,$s1,$s0
    beqz    $v0,L7

#     return iCount;
L8:
    lw      $ra,24($sp)
    move    $v0,$s5
  # lw      $s4,16($sp)
    lw      $s5,20($sp)
    lw      $s3,12($sp)
    lw      $s2,8($sp)
    lw      $s1,4($sp)
    lw      $s0,0($sp)
    addiu   $sp,$sp,28
    jr      $ra

#         iCount = iCount + 1;
#         return iCount;
L9:
    addiu   $v0,$a2,1
    jr      $ra

# +--------------------------------------------------------------+
# |    End of function 'Queen'                                   |
# +--------------------------------------------------------------+


# +--------------------------------------------------------------+
# |    Begin of function 'main'                                  |
# +--------------------------------------------------------------+
    .data
    .align  2
LC0:
    .asciiz "Eight Queen problems, entering the number of queens:"
    .align  2
LC1:
    .asciiz "0\n"
    .text
    .globl  main

# int main(void)
main:

    # WARN - Non-standard optimization: Store the address of Site in $gp.
    la      $gp,Site

    addiu   $sp,$sp,-4
    sw      $ra,0($sp)

#     printf("Eight Queen problems, entering the number of queens:");
    la      $a0,LC0
    li      $v0,4
    syscall

#     scanf("%d", &n);
    li      $v0,5
    syscall

#     m = Queen(0, n, 0);
    blez    $v0,L11
    move    $a0,$zero
    move    $a1,$v0
    move    $a2,$zero
    jal     Queen

#     printf("%d\n", m);
    move    $a0,$v0
    li      $v0,1
    syscall
    li      $a0,'\n'
    li      $v0,11
    syscall

L10:
#     return 0;
    move    $v0,$zero
    lw      $ra,0($sp)
    addiu   $sp,$sp,4
    jr      $ra

L11:
    la      $a0,LC1
    li      $v0,4
    syscall
    j       L10

# +--------------------------------------------------------------+
# |    End of function 'main'                                    |
# +--------------------------------------------------------------+


# +--------------------------------------------------------------+
# |    Begin of global variables                                 |
# +--------------------------------------------------------------+
    .data
    .align 2

# int Site[8];
Site:
    .word   0,0,0,0,0,0,0,0

# +--------------------------------------------------------------+
# |    End of global variables                                   |
# +--------------------------------------------------------------+
