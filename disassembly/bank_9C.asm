org $9C8000

  incsrc data_bank9c_sources.asm
incbin ../assets/bank_9C.bin:$7D53..$7D80   ; $9CFD53 |

CODE_9CFD80:
  JSR.W CODE_FN_9CFDA1                      ; $9CFD80 |
  JSR.W CODE_FN_9CFDAC                      ; $9CFD83 |
  JSL.L CODE_FL_86C424                      ; $9CFD86 |
  PHX                                       ; $9CFD8A |
  ASL A                                     ; $9CFD8B |
  TAX                                       ; $9CFD8C |
  LDA.L DATA8_9CFD97,X                      ; $9CFD8D |
  PLX                                       ; $9CFD91 |
  STA.B $00                                 ; $9CFD92 |
  JMP.W ($0000)                             ; $9CFD94 |

DATA8_9CFD97:
  db $BC,$FD,$DC,$FD,$0D,$FE,$2A,$FE        ; $9CFD97 |
  db $36,$FE                                ; $9CFD9F |

CODE_FN_9CFDA1:
  LDA.W $1692                               ; $9CFDA1 |
  CLC                                       ; $9CFDA4 |
  ADC.W #$0006                              ; $9CFDA5 |
  STA.W $1692                               ; $9CFDA8 |
  RTS                                       ; $9CFDAB |

CODE_FN_9CFDAC:
  LDA.W #$0080                              ; $9CFDAC |
  STA.W $0409                               ; $9CFDAF |
  STA.W $04C9                               ; $9CFDB2 |
  STA.W $040D                               ; $9CFDB5 |
  STA.W $04CD                               ; $9CFDB8 |
  RTS                                       ; $9CFDBB |

  LDA.W #$0080                              ; $9CFDBC |
  STA.B $09,X                               ; $9CFDBF |
  STA.B $0D,X                               ; $9CFDC1 |
  JSL.L CODE_FL_85AA07                      ; $9CFDC3 |
  LDA.W #$0002                              ; $9CFDC7 |
  STA.B $76                                 ; $9CFDCA |
  LDA.W #$0020                              ; $9CFDCC |
  STA.B $2C,X                               ; $9CFDCF |
  LDA.W #$0006                              ; $9CFDD1 |
  STA.B $3A,X                               ; $9CFDD4 |
  INC.B $1A,X                               ; $9CFDD6 |
  JML.L CODE_FL_8B803B                      ; $9CFDD8 |

  JSL.L CODE_FL_86C70D                      ; $9CFDDC |
  LDA.B $3A,X                               ; $9CFDE0 |
  TAY                                       ; $9CFDE2 |
  LDA.W CODE_00DF35,Y                       ; $9CFDE3 |
  TAY                                       ; $9CFDE6 |
  LDA.W #$0219                              ; $9CFDE7 |
  JSL.L CODE_FL_86C9E0                      ; $9CFDEA |
  LDA.B $3A,X                               ; $9CFDEE |
  STA.W $003A,Y                             ; $9CFDF0 |
  LDA.W #$0000                              ; $9CFDF3 |
  STA.W $0022,Y                             ; $9CFDF6 |
  DEC.B $3A,X                               ; $9CFDF9 |
  DEC.B $3A,X                               ; $9CFDFB |
  BEQ CODE_9CFE05                           ; $9CFDFD |
  LDA.W #$0050                              ; $9CFDFF |
  STA.B $2C,X                               ; $9CFE02 |
  RTL                                       ; $9CFE04 |

CODE_9CFE05:
  INC.B $1A,X                               ; $9CFE05 |
  LDA.W #$00A0                              ; $9CFE07 |
  STA.B $2C,X                               ; $9CFE0A |
  RTL                                       ; $9CFE0C |

  JSL.L CODE_FL_86C70D                      ; $9CFE0D |
  LDY.W #$0620                              ; $9CFE11 |
  LDA.W #$0219                              ; $9CFE14 |
  JSL.L CODE_FL_86C9E0                      ; $9CFE17 |
  LDA.W #$0000                              ; $9CFE1B |
  STA.W $003A,Y                             ; $9CFE1E |
  LDA.W #$0000                              ; $9CFE21 |
  STA.W $0022,Y                             ; $9CFE24 |
  INC.B $1A,X                               ; $9CFE27 |
  RTL                                       ; $9CFE29 |

  LDA.W $0638                               ; $9CFE2A |
  BNE CODE_9CFE35                           ; $9CFE2D |
  INC.B $1A,X                               ; $9CFE2F |
  JSL.L CODE_FL_80C213                      ; $9CFE31 |

CODE_9CFE35:
  RTL                                       ; $9CFE35 |

  LDA.W $1F30                               ; $9CFE36 |
  BNE CODE_9CFE43                           ; $9CFE39 |
  JSL.L CODE_FL_848311                      ; $9CFE3B |
  JSL.L CODE_FL_86CA36                      ; $9CFE3F |

CODE_9CFE43:
  RTL                                       ; $9CFE43 |

CODE_9CFE44:
  JSL.L CODE_FL_86C3F8                      ; $9CFE44 |
  PHX                                       ; $9CFE48 |
  ASL A                                     ; $9CFE49 |
  TAX                                       ; $9CFE4A |
  LDA.L DATA8_9CFE55,X                      ; $9CFE4B |
  PLX                                       ; $9CFE4F |
  STA.B $00                                 ; $9CFE50 |
  JMP.W ($0000)                             ; $9CFE52 |

DATA8_9CFE55:
  db $61,$FE,$9F,$FE,$CD,$FE,$E3,$FE        ; $9CFE55 |
  db $F9,$FE,$09,$FF                        ; $9CFE5D |
  LDY.B $3A,X                               ; $9CFE61 |
  LDA.W CODE_00DF3D,Y                       ; $9CFE63 |
  STA.B $09,X                               ; $9CFE66 |
  LDA.W #$FFF8                              ; $9CFE68 |
  STA.B $0D,X                               ; $9CFE6B |
  LDA.W LOOSE_OP_00C531,Y                   ; $9CFE6D |
  STA.B $06,X                               ; $9CFE70 |
  LDA.B $04,X                               ; $9CFE72 |
  AND.W #$DFDF                              ; $9CFE74 |
  CPY.W #$0002                              ; $9CFE77 |
  BNE CODE_9CFE7F                           ; $9CFE7A |
  ORA.W #$2020                              ; $9CFE7C |

CODE_9CFE7F:
  STA.B $04,X                               ; $9CFE7F |
  LDA.W #$0100                              ; $9CFE81 |
  STA.B $28,X                               ; $9CFE84 |
  INC.B $1A,X                               ; $9CFE86 |
  JSL.L CODE_FL_8B88C7                      ; $9CFE88 |
  LDA.W #$C684                              ; $9CFE8C |
  LDY.B $3A,X                               ; $9CFE8F |
  BNE CODE_9CFE9B                           ; $9CFE91 |
  LDA.W #$0002                              ; $9CFE93 |
  STA.B $1A,X                               ; $9CFE96 |
  LDA.W #$C5F4                              ; $9CFE98 |

CODE_9CFE9B:
  JML.L CODE_FL_8B8208                      ; $9CFE9B |

  LDA.W $1C38                               ; $9CFE9F |
  AND.W #$0003                              ; $9CFEA2 |
  ASL A                                     ; $9CFEA5 |
  CMP.B $3A,X                               ; $9CFEA6 |
  BNE CODE_9CFEBD                           ; $9CFEA8 |
  LDY.W #$C684                              ; $9CFEAA |
  LDA.W $1C38                               ; $9CFEAD |
  BIT.W #$0004                              ; $9CFEB0 |
  BEQ CODE_9CFEB8                           ; $9CFEB3 |
  LDY.W #$C690                              ; $9CFEB5 |

CODE_9CFEB8:
  TYA                                       ; $9CFEB8 |
  JSL.L CODE_FL_8B8208                      ; $9CFEB9 |

CODE_9CFEBD:
  LDA.B $0D,X                               ; $9CFEBD |
  CLC                                       ; $9CFEBF |
  ADC.W #$0100                              ; $9CFEC0 |
  CMP.W #$0200                              ; $9CFEC3 |
  BCS CODE_9CFEC9                           ; $9CFEC6 |
  RTL                                       ; $9CFEC8 |

CODE_9CFEC9:
  JML.L CODE_FL_86CA36                      ; $9CFEC9 |

  LDA.W $1C38                               ; $9CFECD |
  AND.W #$0007                              ; $9CFED0 |
  BNE CODE_9CFEE2                           ; $9CFED3 |
  INC.B $1A,X                               ; $9CFED5 |
  JSL.L CODE_FL_8B8266                      ; $9CFED7 |
  LDA.W #$3044                              ; $9CFEDB |
  JSL.L CODE_FL_86CAEE                      ; $9CFEDE |

CODE_9CFEE2:
  RTL                                       ; $9CFEE2 |

  LDA.B $0D,X                               ; $9CFEE3 |
  CMP.W #$0038                              ; $9CFEE5 |
  BNE CODE_9CFEF8                           ; $9CFEE8 |
  LDA.W #$FFFE                              ; $9CFEEA |
  STA.B $4C,X                               ; $9CFEED |
  LDA.W #$0098                              ; $9CFEEF |
  JSL.L CODE_FL_8089BD                      ; $9CFEF2 |
  INC.B $1A,X                               ; $9CFEF6 |

CODE_9CFEF8:
  RTL                                       ; $9CFEF8 |

  JSL.L CODE_FL_86C82F                      ; $9CFEF9 |
  BPL CODE_9CFF08                           ; $9CFEFD |
  STZ.B $28,X                               ; $9CFEFF |
  LDA.W #$0008                              ; $9CFF01 |
  STA.B $4C,X                               ; $9CFF04 |
  INC.B $1A,X                               ; $9CFF06 |

CODE_9CFF08:
  RTL                                       ; $9CFF08 |

  JSL.L CODE_FL_86C82F                      ; $9CFF09 |
  BRA CODE_9CFEBD                           ; $9CFF0D |

CODE_FL_9CFF0F:
  LDA.B $33,X                               ; $9CFF0F |
  AND.W #$0010                              ; $9CFF11 |
  LSR A                                     ; $9CFF14 |
  LSR A                                     ; $9CFF15 |
  LSR A                                     ; $9CFF16 |
  TAY                                       ; $9CFF17 |
  LDA.W $00DC,Y                             ; $9CFF18 |
  RTL                                       ; $9CFF1B |

CODE_FL_9CFF1C:
  LDA.B $32,X                               ; $9CFF1C |
  AND.W #$00FF                              ; $9CFF1E |
  ASL A                                     ; $9CFF21 |
  ASL A                                     ; $9CFF22 |
  ASL A                                     ; $9CFF23 |
  ASL A                                     ; $9CFF24 |
  TAY                                       ; $9CFF25 |
  RTL                                       ; $9CFF26 |

CODE_FL_9CFF27:
  LDA.B $22,X                               ; $9CFF27 |
  ORA.W #$0001                              ; $9CFF29 |
  STA.B $22,X                               ; $9CFF2C |
  RTL                                       ; $9CFF2E |

CODE_FL_9CFF2F:
  JSL.L CODE_FL_9CFF3A                      ; $9CFF2F |
  JSL.L CODE_FL_9CFF5F                      ; $9CFF33 |
  JMP.W CODE_JP_9CFF84                      ; $9CFF37 |

CODE_FL_9CFF3A:
  CLC                                       ; $9CFF3A |
  LDA.B $26,X                               ; $9CFF3B |
  BPL CODE_9CFF4F                           ; $9CFF3D |
  ADC.W $0008,Y                             ; $9CFF3F |
  STA.W $0008,Y                             ; $9CFF42 |
  BCS CODE_9CFF5E                           ; $9CFF45 |
  LDA.W $000A,Y                             ; $9CFF47 |
  DEC A                                     ; $9CFF4A |
  STA.W $000A,Y                             ; $9CFF4B |
  RTL                                       ; $9CFF4E |

CODE_9CFF4F:
  ADC.W $0008,Y                             ; $9CFF4F |
  STA.W $0008,Y                             ; $9CFF52 |
  BCC CODE_9CFF5E                           ; $9CFF55 |
  db $B9,$0A,$00,$1A,$99,$0A,$00            ; $9CFF57 |

CODE_9CFF5E:
  RTL                                       ; $9CFF5E |

CODE_FL_9CFF5F:
  CLC                                       ; $9CFF5F |
  LDA.B $28,X                               ; $9CFF60 |
  BPL CODE_9CFF74                           ; $9CFF62 |
  ADC.W $000C,Y                             ; $9CFF64 |
  STA.W $000C,Y                             ; $9CFF67 |
  BCS CODE_9CFF83                           ; $9CFF6A |
  LDA.W $000E,Y                             ; $9CFF6C |
  DEC A                                     ; $9CFF6F |
  STA.W $000E,Y                             ; $9CFF70 |
  RTL                                       ; $9CFF73 |

CODE_9CFF74:
  ADC.W $000C,Y                             ; $9CFF74 |
  STA.W $000C,Y                             ; $9CFF77 |
  BCC CODE_9CFF83                           ; $9CFF7A |
  db $B9,$0E,$00,$1A,$99,$0E,$00            ; $9CFF7C |

CODE_9CFF83:
  RTL                                       ; $9CFF83 |

CODE_JP_9CFF84:
  CLC                                       ; $9CFF84 |
  LDA.B $2A,X                               ; $9CFF85 |
  BPL CODE_9CFF99                           ; $9CFF87 |
  ADC.W $0010,Y                             ; $9CFF89 |
  STA.W $0010,Y                             ; $9CFF8C |
  BCS CODE_9CFFA8                           ; $9CFF8F |
  LDA.W $0012,Y                             ; $9CFF91 |
  DEC A                                     ; $9CFF94 |
  STA.W $0012,Y                             ; $9CFF95 |
  RTL                                       ; $9CFF98 |

CODE_9CFF99:
  ADC.W $0010,Y                             ; $9CFF99 |
  STA.W $0010,Y                             ; $9CFF9C |
  BCC CODE_9CFFA8                           ; $9CFF9F |
  db $B9,$12,$00,$1A,$99,$12,$00            ; $9CFFA1 |

CODE_9CFFA8:
  RTL                                       ; $9CFFA8 |

CODE_FL_9CFFA9:
  CLC                                       ; $9CFFA9 |
  LDA.B $26,X                               ; $9CFFAA |
  BPL CODE_9CFFC1                           ; $9CFFAC |
  LDA.B $27,X                               ; $9CFFAE |
  AND.W #$00FF                              ; $9CFFB0 |
  ORA.W #$FF00                              ; $9CFFB3 |
  STA.B $00                                 ; $9CFFB6 |
  LDA.B $25,X                               ; $9CFFB8 |
  AND.W #$FF00                              ; $9CFFBA |
  STA.B $02                                 ; $9CFFBD |
  BRA CODE_9CFFCF                           ; $9CFFBF |

CODE_9CFFC1:
  LDA.B $27,X                               ; $9CFFC1 |
  AND.W #$00FF                              ; $9CFFC3 |
  STA.B $00                                 ; $9CFFC6 |
  LDA.B $25,X                               ; $9CFFC8 |
  AND.W #$FF00                              ; $9CFFCA |
  STA.B $02                                 ; $9CFFCD |

CODE_9CFFCF:
  SEC                                       ; $9CFFCF |
  LDA.W $1660                               ; $9CFFD0 |
  SBC.B $02                                 ; $9CFFD3 |
  STA.W $1660                               ; $9CFFD5 |
  LDA.W $1662                               ; $9CFFD8 |
  SBC.B $00                                 ; $9CFFDB |
  STA.W $1662                               ; $9CFFDD |
  RTL                                       ; $9CFFE0 |

  RTL                                       ; $9CFFE1 |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9CFFE2 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9CFFEA |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9CFFF2 |
  db $FF,$FF,$FF,$FF,$FF,$FF                ; $9CFFFA |
