org $978000

incbin ../assets/bank_97.bin:$0000..$0581   ; $978000 |
  incsrc data_bank97_sources.asm
incbin ../assets/bank_97.bin:$7C5F..$7C80   ; $97FC5F |

CODE_FL_97FC80:
  LDA.B $22,X                               ; $97FC80 |
  LSR A                                     ; $97FC82 |
  BCS CODE_97FCE1                           ; $97FC83 |
  LDA.B $20,X                               ; $97FC85 |
  BEQ CODE_97FCE1                           ; $97FC87 |
  DEC.B $20,X                               ; $97FC89 |
  BNE CODE_97FCE1                           ; $97FC8B |
  LDA.B $1E,X                               ; $97FC8D |
  BEQ CODE_97FCE1                           ; $97FC8F |
  ASL A                                     ; $97FC91 |
  TAY                                       ; $97FC92 |
  SEP #$20                                  ; $97FC93 |
  PHB                                       ; $97FC95 |
  PEA.W $8787                               ; $97FC96 |
  PLB                                       ; $97FC99 |
  PLB                                       ; $97FC9A |
  LDA.B $05,X                               ; $97FC9B |
  STA.B $1E                                 ; $97FC9D |
  STA.B $1F                                 ; $97FC9F |
  TDC                                       ; $97FCA1 |
  LDA.B $1F,X                               ; $97FCA2 |
  LSR A                                     ; $97FCA4 |
  LSR A                                     ; $97FCA5 |
  LSR A                                     ; $97FCA6 |
  PHX                                       ; $97FCA7 |
  TAX                                       ; $97FCA8 |
  REP #$20                                  ; $97FCA9 |
  CLC                                       ; $97FCAB |
  TYA                                       ; $97FCAC |
  ADC.W LOOSE_OP_00A403,X                   ; $97FCAD |
  PLX                                       ; $97FCB0 |
  TAY                                       ; $97FCB1 |
  LDA.W $0000,Y                             ; $97FCB2 |
  STA.B $18                                 ; $97FCB5 |
  LDA.B $1C,X                               ; $97FCB7 |
  SEP #$20                                  ; $97FCB9 |

CODE_97FCBB:
  TAY                                       ; $97FCBB |
  LDA.B ($18),Y                             ; $97FCBC |
  INC A                                     ; $97FCBE |
  BEQ CODE_97FCBB                           ; $97FCBF |
  DEC A                                     ; $97FCC1 |
  REP #$20                                  ; $97FCC2 |
  STA.B $1A                                 ; $97FCC4 |
  STY.B $1C,X                               ; $97FCC6 |
  INY                                       ; $97FCC8 |

CODE_97FCC9:
  LDA.B ($18),Y                             ; $97FCC9 |
  BEQ CODE_97FCD2                           ; $97FCCB |
  CMP.W #$3000                              ; $97FCCD |
  BCC CODE_97FCE2                           ; $97FCD0 |

CODE_97FCD2:
  STA.B $00,X                               ; $97FCD2 |
  LDA.B $1A                                 ; $97FCD4 |
  STA.B $20,X                               ; $97FCD6 |
  LDA.B $1E                                 ; $97FCD8 |
  STA.B $04,X                               ; $97FCDA |
  INY                                       ; $97FCDC |
  INY                                       ; $97FCDD |
  STY.B $1C,X                               ; $97FCDE |
  PLB                                       ; $97FCE0 |

CODE_97FCE1:
  RTL                                       ; $97FCE1 |

CODE_97FCE2:
  INY                                       ; $97FCE2 |
  INY                                       ; $97FCE3 |
  SBC.W #$00FF                              ; $97FCE4 |
  BCS CODE_97FCF6                           ; $97FCE7 |
  SEP #$20                                  ; $97FCE9 |
  DEC A                                     ; $97FCEB |
  EOR.B $1E                                 ; $97FCEC |
  ORA.B #$80                                ; $97FCEE |
  STA.B $1E                                 ; $97FCF0 |
  REP #$20                                  ; $97FCF2 |
  BRA CODE_97FCC9                           ; $97FCF4 |

CODE_97FCF6:
  STA.B $00                                 ; $97FCF6 |
  LDA.W $19AA                               ; $97FCF8 |
  BEQ CODE_97FD01                           ; $97FCFB |
  INC.B $20,X                               ; $97FCFD |
  PLB                                       ; $97FCFF |
  RTL                                       ; $97FD00 |

CODE_97FD01:
  LDA.B $00                                 ; $97FD01 |
  STA.L $7E8400                             ; $97FD03 |
  LDA.B ($18),Y                             ; $97FD07 |
  STA.L $7E8480                             ; $97FD09 |
  INY                                       ; $97FD0D |
  INY                                       ; $97FD0E |
  LDA.B ($18),Y                             ; $97FD0F |
  AND.W #$00FF                              ; $97FD11 |
  STA.L $7E84C0                             ; $97FD14 |
  INY                                       ; $97FD18 |
  LDA.B $06,X                               ; $97FD19 |
  AND.W #$01FF                              ; $97FD1B |
  ASL A                                     ; $97FD1E |
  ASL A                                     ; $97FD1F |
  ASL A                                     ; $97FD20 |
  ASL A                                     ; $97FD21 |
  ORA.W #$6000                              ; $97FD22 |
  STA.L $7E8440                             ; $97FD25 |
  TDC                                       ; $97FD29 |
  STA.L $7E8402                             ; $97FD2A |
  LDA.W #$0002                              ; $97FD2E |
  STA.W $19AA                               ; $97FD31 |
  BRA CODE_97FCC9                           ; $97FD34 |

CODE_FL_97FD36:
  STZ.B $0A                                 ; $97FD36 |
  STZ.B $0C                                 ; $97FD38 |
  LDA.B $2E,X                               ; $97FD3A |
  STA.B $0E                                 ; $97FD3C |
  LDA.B $30,X                               ; $97FD3E |
  STA.B $10                                 ; $97FD40 |
  LDA.B $34,X                               ; $97FD42 |
  AND.W #$C000                              ; $97FD44 |
  BEQ CODE_97FDAE                           ; $97FD47 |
  ASL A                                     ; $97FD49 |
  BCC CODE_97FD4F                           ; $97FD4A |
  ORA.W #$4000                              ; $97FD4C |

CODE_97FD4F:
  STA.B $08                                 ; $97FD4F |
  CLC                                       ; $97FD51 |
  LDA.B $09,X                               ; $97FD52 |
  ADC.B $0A                                 ; $97FD54 |
  STA.B $01                                 ; $97FD56 |
  CLC                                       ; $97FD58 |
  LDA.B $0D,X                               ; $97FD59 |
  ADC.B $0C                                 ; $97FD5B |
  STA.B $04                                 ; $97FD5D |
  LDX.W $1B76                               ; $97FD5F |
  LDA.B $16,X                               ; $97FD62 |
  STA.W $0012                               ; $97FD64 |
  STZ.B $16,X                               ; $97FD67 |
  LDA.W $1B70                               ; $97FD69 |
  PHB                                       ; $97FD6C |
  PEA.W $8787                               ; $97FD6D |
  PLB                                       ; $97FD70 |
  PLB                                       ; $97FD71 |

CODE_97FD72:
  TAX                                       ; $97FD72 |
  LDA.B $08                                 ; $97FD73 |
  AND.B $34,X                               ; $97FD75 |
  BEQ CODE_97FDA2                           ; $97FD77 |
  LDA.B $09,X                               ; $97FD79 |
  CMP.W #$0100                              ; $97FD7B |
  BCS CODE_97FDA2                           ; $97FD7E |
  SEC                                       ; $97FD80 |
  SBC.B $01                                 ; $97FD81 |
  BPL CODE_97FD89                           ; $97FD83 |
  EOR.W #$FFFF                              ; $97FD85 |
  INC A                                     ; $97FD88 |

CODE_97FD89:
  SEC                                       ; $97FD89 |
  SBC.B $0E                                 ; $97FD8A |
  SBC.B $2E,X                               ; $97FD8C |
  BPL CODE_97FDA2                           ; $97FD8E |
  SEC                                       ; $97FD90 |
  LDA.B $04                                 ; $97FD91 |
  SBC.B $0D,X                               ; $97FD93 |
  BPL CODE_97FD9B                           ; $97FD95 |
  EOR.W #$FFFF                              ; $97FD97 |
  INC A                                     ; $97FD9A |

CODE_97FD9B:
  SEC                                       ; $97FD9B |
  SBC.B $10                                 ; $97FD9C |
  SBC.B $30,X                               ; $97FD9E |
  BMI CODE_97FDAF                           ; $97FDA0 |

CODE_97FDA2:
  LDA.B $16,X                               ; $97FDA2 |
  BNE CODE_97FD72                           ; $97FDA4 |
  PLB                                       ; $97FDA6 |
  LDA.W $0012                               ; $97FDA7 |
  STA.B $16,X                               ; $97FDAA |
  LDX.B $FC                                 ; $97FDAC |

CODE_97FDAE:
  RTL                                       ; $97FDAE |

CODE_97FDAF:
  JSL.L CODE_FL_97FDB9                      ; $97FDAF |
  JSL.L CODE_FL_97FE46                      ; $97FDB3 |
  BRA CODE_97FDA2                           ; $97FDB7 |

CODE_FL_97FDB9:
  LDY.B $FC                                 ; $97FDB9 |
  LDA.B $08                                 ; $97FDBB |
  EOR.B $34,X                               ; $97FDBD |
  BPL CODE_97FDC4                           ; $97FDBF |
  JMP.W CODE_JP_97FE45                      ; $97FDC1 |

CODE_97FDC4:
  LDA.B $38,X                               ; $97FDC4 |
  BNE CODE_JP_97FE45                        ; $97FDC6 |
  LDA.W $002B,Y                             ; $97FDC8 |
  AND.B $2A,X                               ; $97FDCB |
  AND.W #$00FF                              ; $97FDCD |
  BEQ CODE_JP_97FE45                        ; $97FDD0 |
  LDA.W $0032,Y                             ; $97FDD2 |
  ORA.W #$4000                              ; $97FDD5 |
  STA.W $0032,Y                             ; $97FDD8 |
  JSL.L CODE_FL_97FEE4                      ; $97FDDB |
  LDA.W #$0019                              ; $97FDDF |
  STA.B $38,X                               ; $97FDE2 |
  LDA.B $32,X                               ; $97FDE4 |
  AND.W #$FE00                              ; $97FDE6 |
  STA.B $32,X                               ; $97FDE9 |
  LDA.B $FC                                 ; $97FDEB |
  LSR A                                     ; $97FDED |
  LSR A                                     ; $97FDEE |
  LSR A                                     ; $97FDEF |
  LSR A                                     ; $97FDF0 |
  ORA.B $32,X                               ; $97FDF1 |
  ORA.W #$8000                              ; $97FDF3 |
  STA.B $32,X                               ; $97FDF6 |
  LDA.W $0034,Y                             ; $97FDF8 |
  ASL A                                     ; $97FDFB |
  ORA.B $34,X                               ; $97FDFC |
  AND.W #$2000                              ; $97FDFE |
  BNE CODE_JP_97FE45                        ; $97FE01 |
  SEP #$20                                  ; $97FE03 |
  LDA.W $004F,Y                             ; $97FE05 |
  STA.B $37,X                               ; $97FE08 |
  SEC                                       ; $97FE0A |
  LDA.B $36,X                               ; $97FE0B |
  SBC.W $004E,Y                             ; $97FE0D |
  STA.B $36,X                               ; $97FE10 |
  REP #$20                                  ; $97FE12 |
  BEQ CODE_97FE18                           ; $97FE14 |
  BCS CODE_JP_97FE45                        ; $97FE16 |

CODE_97FE18:
  SEP #$20                                  ; $97FE18 |
  STZ.B $36,X                               ; $97FE1A |
  REP #$20                                  ; $97FE1C |
  JSL.L CODE_FL_85F9C1                      ; $97FE1E |
  LDA.W $0002,Y                             ; $97FE22 |
  AND.W #$00FF                              ; $97FE25 |
  STA.B $1A,X                               ; $97FE28 |
  LDA.W $0005,Y                             ; $97FE2A |
  AND.W #$00FF                              ; $97FE2D |
  CMP.W #$0025                              ; $97FE30 |
  BEQ CODE_JP_97FE45                        ; $97FE33 |
  LDA.B $37,X                               ; $97FE35 |
  AND.W #$00FF                              ; $97FE37 |
  CMP.W #$0020                              ; $97FE3A |
  BEQ CODE_97FE42                           ; $97FE3D |
  INC.W $1CAA                               ; $97FE3F |

CODE_97FE42:
  INC.W $1CA6                               ; $97FE42 |

CODE_JP_97FE45:
  RTL                                       ; $97FE45 |

CODE_FL_97FE46:
  LDY.B $FC                                 ; $97FE46 |
  LDA.W $0038,Y                             ; $97FE48 |
  BNE CODE_97FEB2                           ; $97FE4B |
  LDA.B $2B,X                               ; $97FE4D |
  AND.W $002A,Y                             ; $97FE4F |
  AND.W #$00FF                              ; $97FE52 |
  BEQ CODE_97FEB2                           ; $97FE55 |
  LDA.B $32,X                               ; $97FE57 |
  ORA.W #$4000                              ; $97FE59 |
  STA.B $32,X                               ; $97FE5C |
  LDA.W #$0019                              ; $97FE5E |
  STA.W $0038,Y                             ; $97FE61 |
  CPY.W #$0580                              ; $97FE64 |
  BNE CODE_97FE70                           ; $97FE67 |
  LDA.W #$009C                              ; $97FE69 |
  JSL.L CODE_FL_8089BD                      ; $97FE6C |

CODE_97FE70:
  LDA.W $0032,Y                             ; $97FE70 |
  AND.W #$FE00                              ; $97FE73 |
  STA.W $0032,Y                             ; $97FE76 |
  TXA                                       ; $97FE79 |
  LSR A                                     ; $97FE7A |
  LSR A                                     ; $97FE7B |
  LSR A                                     ; $97FE7C |
  LSR A                                     ; $97FE7D |
  ORA.W $0032,Y                             ; $97FE7E |
  ORA.W #$8000                              ; $97FE81 |
  STA.W $0032,Y                             ; $97FE84 |
  LDA.B $34,X                               ; $97FE87 |
  ASL A                                     ; $97FE89 |
  ORA.W $0034,Y                             ; $97FE8A |
  AND.W #$2000                              ; $97FE8D |
  BNE CODE_97FEB2                           ; $97FE90 |
  PHX                                       ; $97FE92 |
  PHY                                       ; $97FE93 |
  PHY                                       ; $97FE94 |
  JSL.L CODE_FL_85F9C1                      ; $97FE95 |
  PLX                                       ; $97FE99 |
  SEP #$20                                  ; $97FE9A |
  LDA.W $0005,Y                             ; $97FE9C |
  STA.B $37,X                               ; $97FE9F |
  SEC                                       ; $97FEA1 |
  LDA.B $36,X                               ; $97FEA2 |
  SBC.W $0004,Y                             ; $97FEA4 |
  BEQ CODE_97FEAB                           ; $97FEA7 |
  BCS CODE_97FEAC                           ; $97FEA9 |

CODE_97FEAB:
  TDC                                       ; $97FEAB |

CODE_97FEAC:
  STA.B $36,X                               ; $97FEAC |
  REP #$20                                  ; $97FEAE |
  PLY                                       ; $97FEB0 |
  PLX                                       ; $97FEB1 |

CODE_97FEB2:
  CPY.W #$0580                              ; $97FEB2 |
  BNE CODE_97FEE0                           ; $97FEB5 |

CODE_FL_97FEB7:
  PHY                                       ; $97FEB7 |
  LDA.B $00                                 ; $97FEB8 |
  PHA                                       ; $97FEBA |
  LDA.B $02                                 ; $97FEBB |
  PHA                                       ; $97FEBD |
  LDA.B $04                                 ; $97FEBE |
  PHA                                       ; $97FEC0 |
  LDA.W $05B6                               ; $97FEC1 |
  AND.W #$00FF                              ; $97FEC4 |
  LDY.W #$0006                              ; $97FEC7 |
  JSL.L CODE_FL_808DF4                      ; $97FECA |
  JSL.L CODE_FL_80A877                      ; $97FECE |
  STA.L $7007BA                             ; $97FED2 |
  PLA                                       ; $97FED6 |
  STA.B $04                                 ; $97FED7 |
  PLA                                       ; $97FED9 |
  STA.B $02                                 ; $97FEDA |
  PLA                                       ; $97FEDC |
  STA.B $00                                 ; $97FEDD |
  PLY                                       ; $97FEDF |

CODE_97FEE0:
  RTL                                       ; $97FEE0 |

CODE_FL_97FEE1:
  PHA                                       ; $97FEE1 |
  BRA CODE_97FEEF                           ; $97FEE2 |

CODE_FL_97FEE4:
  PHY                                       ; $97FEE4 |
  LDA.B $22,X                               ; $97FEE5 |
  AND.W #$0020                              ; $97FEE7 |
  BEQ CODE_97FEEF                           ; $97FEEA |
  JMP.W CODE_JP_97FF35                      ; $97FEEC |

CODE_97FEEF:
  STY.B $18                                 ; $97FEEF |
  PHX                                       ; $97FEF1 |
  LDY.B $FC                                 ; $97FEF2 |
  LDA.B $00                                 ; $97FEF4 |
  PHA                                       ; $97FEF6 |
  LDA.W #$0060                              ; $97FEF7 |
  JSL.L CODE_FL_8695D1                      ; $97FEFA |
  PLA                                       ; $97FEFE |
  STA.B $00                                 ; $97FEFF |
  PLX                                       ; $97FF01 |
  BCS CODE_JP_97FF35                        ; $97FF02 |
  LDA.B $09,X                               ; $97FF04 |
  STA.W $0009,Y                             ; $97FF06 |
  LDA.B $0D,X                               ; $97FF09 |
  STA.W $000D,Y                             ; $97FF0B |
  TDC                                       ; $97FF0E |
  STA.W $0014,Y                             ; $97FF0F |
  PHY                                       ; $97FF12 |
  LDA.B $4F,X                               ; $97FF13 |
  CPX.W #$0B70                              ; $97FF15 |
  BCC CODE_97FF21                           ; $97FF18 |
  JSL.L CODE_FL_85F9C1                      ; $97FF1A |
  LDA.W $0005,Y                             ; $97FF1E |

CODE_97FF21:
  AND.W #$00FF                              ; $97FF21 |
  LDY.W #$800B                              ; $97FF24 |
  CMP.W #$0025                              ; $97FF27 |
  BNE CODE_97FF2F                           ; $97FF2A |
  LDY.W #$8009                              ; $97FF2C |

CODE_97FF2F:
  TYA                                       ; $97FF2F |
  PLY                                       ; $97FF30 |
  JSL.L CODE_FL_86CAE6                      ; $97FF31 |

CODE_JP_97FF35:
  PLY                                       ; $97FF35 |
  RTL                                       ; $97FF36 |

CODE_FL_97FF37:
  PHX                                       ; $97FF37 |
  PHY                                       ; $97FF38 |
  LDX.B $FC                                 ; $97FF39 |
  JSL.L CODE_FL_97FEE1                      ; $97FF3B |
  LDA.W #$0019                              ; $97FF3F |
  STA.W $0038,X                             ; $97FF42 |
  SEP #$20                                  ; $97FF45 |
  LDA.W $0033,X                             ; $97FF47 |
  ORA.B #$80                                ; $97FF4A |
  STA.W $0033,X                             ; $97FF4C |
  LDA.W $0035,X                             ; $97FF4F |
  BIT.B #$20                                ; $97FF52 |
  BNE CODE_97FF66                           ; $97FF54 |
  LDA.B #$26                                ; $97FF56 |
  STA.B $37,X                               ; $97FF58 |
  SEC                                       ; $97FF5A |
  LDA.B $36,X                               ; $97FF5B |
  SBC.B #$01                                ; $97FF5D |
  BEQ CODE_97FF63                           ; $97FF5F |
  BCS CODE_97FF64                           ; $97FF61 |

CODE_97FF63:
  TDC                                       ; $97FF63 |

CODE_97FF64:
  STA.B $36,X                               ; $97FF64 |

CODE_97FF66:
  REP #$20                                  ; $97FF66 |
  JSL.L CODE_FL_97FEB7                      ; $97FF68 |
  PLY                                       ; $97FF6C |
  PLX                                       ; $97FF6D |
  RTL                                       ; $97FF6E |

CODE_97FF6F:
  LDA.B $1A,X                               ; $97FF6F |
  PHX                                       ; $97FF71 |
  ASL A                                     ; $97FF72 |
  TAX                                       ; $97FF73 |
  LDA.L PTR16_97FF7E,X                      ; $97FF74 |
  PLX                                       ; $97FF78 |
  STA.B $00                                 ; $97FF79 |
  JMP.W ($0000)                             ; $97FF7B |

PTR16_97FF7E:
  dw CODE_97FF82                            ; $97FF7E |
  dw CODE_97FFC3                            ; $97FF80 |

CODE_97FF82:
  JSL.L CODE_FL_8DEA00                      ; $97FF82 |
  LDX.B $FC                                 ; $97FF86 |
  LDA.B $4E,X                               ; $97FF88 |
  STA.B $02                                 ; $97FF8A |
  AND.W #$00FF                              ; $97FF8C |
  ASL A                                     ; $97FF8F |
  TAY                                       ; $97FF90 |
  LDA.W CODE_00D31F,Y                       ; $97FF91 |
  TAY                                       ; $97FF94 |

CODE_97FF95:
  LDA.W $0000,Y                             ; $97FF95 |
  STA.B $00                                 ; $97FF98 |
  AND.W #$00FF                              ; $97FF9A |
  CMP.W #$00FF                              ; $97FF9D |
  BEQ CODE_97FFC0                           ; $97FFA0 |
  PHY                                       ; $97FFA2 |
  LDA.B $02                                 ; $97FFA3 |
  AND.W #$FF00                              ; $97FFA5 |
  STA.B $02                                 ; $97FFA8 |
  LDA.B $01                                 ; $97FFAA |
  AND.W #$00FF                              ; $97FFAC |
  ORA.B $02                                 ; $97FFAF |
  TAY                                       ; $97FFB1 |
  LDA.B $00                                 ; $97FFB2 |
  AND.W #$00FF                              ; $97FFB4 |
  JSL.L CODE_FL_8DEA3E                      ; $97FFB7 |
  PLY                                       ; $97FFBB |
  INY                                       ; $97FFBC |
  INY                                       ; $97FFBD |
  BRA CODE_97FF95                           ; $97FFBE |

CODE_97FFC0:
  INC.B $1A,X                               ; $97FFC0 |
  RTL                                       ; $97FFC2 |

CODE_97FFC3:
  JSL.L CODE_FL_8DEA6D                      ; $97FFC3 |
  RTL                                       ; $97FFC7 |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $97FFC8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $97FFD0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $97FFD8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $97FFE0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $97FFE8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $97FFF0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $97FFF8 |
