org $A88000

incsrc data_bankA8_sources.asm

CODE_FL_A8FC80:
  LDA.W $0046,X                             ; $A8FC80 |
  AND.W #$FE70                              ; $A8FC83 |
  STA.W $0046,X                             ; $A8FC86 |
  LDA.B $2E,X                               ; $A8FC89 |
  STA.B $0E                                 ; $A8FC8B |
  LDA.B $30,X                               ; $A8FC8D |
  STA.B $10                                 ; $A8FC8F |
  LDA.B $09,X                               ; $A8FC91 |
  STA.B $01                                 ; $A8FC93 |
  LDA.B $0D,X                               ; $A8FC95 |
  STA.B $04                                 ; $A8FC97 |
  LDY.B $FC                                 ; $A8FC99 |
  LDA.W $1B72                               ; $A8FC9B |
  STA.B $12                                 ; $A8FC9E |
  LDA.W $1B70                               ; $A8FCA0 |

CODE_A8FCA3:
  TAX                                       ; $A8FCA3 |
  LDA.B $33,X                               ; $A8FCA4 |
  BPL CODE_A8FCAB                           ; $A8FCA6 |
  JSR.W CODE_FN_A8FCB4                      ; $A8FCA8 |

CODE_A8FCAB:
  LDA.B $16,X                               ; $A8FCAB |
  CPX.B $12                                 ; $A8FCAD |
  BNE CODE_A8FCA3                           ; $A8FCAF |
  LDX.B $FC                                 ; $A8FCB1 |
  RTL                                       ; $A8FCB3 |

CODE_FN_A8FCB4:
  SEC                                       ; $A8FCB4 |
  LDA.B $09,X                               ; $A8FCB5 |
  SBC.B $01                                 ; $A8FCB7 |
  BPL CODE_A8FCBF                           ; $A8FCB9 |
  EOR.W #$FFFF                              ; $A8FCBB |
  INC A                                     ; $A8FCBE |

CODE_A8FCBF:
  SEC                                       ; $A8FCBF |
  SBC.B $0E                                 ; $A8FCC0 |
  BCC CODE_A8FCC8                           ; $A8FCC2 |
  SBC.B $2E,X                               ; $A8FCC4 |
  BCS CODE_A8FCDF                           ; $A8FCC6 |

CODE_A8FCC8:
  SEC                                       ; $A8FCC8 |
  LDA.B $04                                 ; $A8FCC9 |
  SBC.B $0D,X                               ; $A8FCCB |
  BMI CODE_A8FCD8                           ; $A8FCCD |
  BEQ CODE_A8FCE0                           ; $A8FCCF |
  SEC                                       ; $A8FCD1 |
  SBC.B $10                                 ; $A8FCD2 |
  BPL CODE_A8FCDF                           ; $A8FCD4 |
  BRA CODE_A8FCE0                           ; $A8FCD6 |

CODE_A8FCD8:
  CLC                                       ; $A8FCD8 |
  ADC.B $30,X                               ; $A8FCD9 |
  BMI CODE_A8FCDF                           ; $A8FCDB |
  BRA CODE_A8FCE0                           ; $A8FCDD |

CODE_A8FCDF:
  RTS                                       ; $A8FCDF |

CODE_A8FCE0:
  CPX.B $FC                                 ; $A8FCE0 |
  BEQ CODE_A8FCDF                           ; $A8FCE2 |
  LDA.B $34,X                               ; $A8FCE4 |
  AND.W #$0004                              ; $A8FCE6 |
  BEQ CODE_A8FCF6                           ; $A8FCE9 |
  LDA.B $46,X                               ; $A8FCEB |
  AND.W #$0200                              ; $A8FCED |
  BNE CODE_A8FCDF                           ; $A8FCF0 |
  LDA.B $26,X                               ; $A8FCF2 |
  BNE CODE_A8FCDF                           ; $A8FCF4 |

CODE_A8FCF6:
  LDA.B $34,X                               ; $A8FCF6 |
  AND.W #$0010                              ; $A8FCF8 |
  BNE CODE_A8FD59                           ; $A8FCFB |
  LDA.B $34,X                               ; $A8FCFD |
  AND.W #$0800                              ; $A8FCFF |
  BEQ CODE_JP_A8FD79                        ; $A8FD02 |
  CLC                                       ; $A8FD04 |
  LDA.B $04                                 ; $A8FD05 |
  ADC.W #$0100                              ; $A8FD07 |
  STA.B $26                                 ; $A8FD0A |
  CLC                                       ; $A8FD0C |
  LDA.B $0D,X                               ; $A8FD0D |
  ADC.W #$0100                              ; $A8FD0F |
  CMP.B $26                                 ; $A8FD12 |
  BCS CODE_A8FD19                           ; $A8FD14 |
  JMP.W CODE_JP_A8FD79                      ; $A8FD16 |

CODE_A8FD19:
  LDA.B $0D,X                               ; $A8FD19 |
  SEC                                       ; $A8FD1B |
  SBC.B $30,X                               ; $A8FD1C |
  STA.B $26                                 ; $A8FD1E |
  SBC.B $04                                 ; $A8FD20 |
  CLC                                       ; $A8FD22 |
  ADC.W #$0008                              ; $A8FD23 |
  BMI CODE_JP_A8FD79                        ; $A8FD26 |
  LDA.W $0028,Y                             ; $A8FD28 |
  BPL CODE_A8FD30                           ; $A8FD2B |
  JMP.W CODE_JP_A8FDDA                      ; $A8FD2D |

CODE_A8FD30:
  LDA.B $46,X                               ; $A8FD30 |
  ORA.W #$0040                              ; $A8FD32 |
  STA.B $46,X                               ; $A8FD35 |
  LDA.W $0046,Y                             ; $A8FD37 |
  ORA.W #$0100                              ; $A8FD3A |
  STA.W $0046,Y                             ; $A8FD3D |
  LDA.B $26                                 ; $A8FD40 |
  STA.W $000D,Y                             ; $A8FD42 |
  LDA.W $0034,Y                             ; $A8FD45 |
  AND.W #$0200                              ; $A8FD48 |
  BEQ CODE_A8FD51                           ; $A8FD4B |
  TDC                                       ; $A8FD4D |
  STA.W $0026,Y                             ; $A8FD4E |

CODE_A8FD51:
  STA.W $0028,Y                             ; $A8FD51 |
  STX.B $20                                 ; $A8FD54 |
  JMP.W CODE_JP_A8FDDA                      ; $A8FD56 |

CODE_A8FD59:
  SEC                                       ; $A8FD59 |
  LDA.B $09,X                               ; $A8FD5A |
  SBC.B $01                                 ; $A8FD5C |
  BPL CODE_A8FD64                           ; $A8FD5E |
  EOR.W #$FFFF                              ; $A8FD60 |
  INC A                                     ; $A8FD63 |

CODE_A8FD64:
  SEC                                       ; $A8FD64 |
  SBC.B $2E,X                               ; $A8FD65 |
  BCC CODE_A8FD70                           ; $A8FD67 |
  SBC.B $0E                                 ; $A8FD69 |
  CMP.W #$FFF8                              ; $A8FD6B |
  BCS CODE_A8FD81                           ; $A8FD6E |

CODE_A8FD70:
  SEC                                       ; $A8FD70 |
  LDA.B $0D,X                               ; $A8FD71 |
  SBC.B $30,X                               ; $A8FD73 |
  STA.B $26                                 ; $A8FD75 |
  BRA CODE_A8FD30                           ; $A8FD77 |

CODE_JP_A8FD79:
  LDA.W $0034,X                             ; $A8FD79 |
  AND.W #$1000                              ; $A8FD7C |
  BEQ CODE_A8FDAF                           ; $A8FD7F |

CODE_A8FD81:
  LDA.B $46,X                               ; $A8FD81 |
  ORA.W #$0020                              ; $A8FD83 |
  STA.B $46,X                               ; $A8FD86 |
  LDA.W $0046,Y                             ; $A8FD88 |
  ORA.W #$0008                              ; $A8FD8B |
  STA.W $0046,Y                             ; $A8FD8E |
  SEC                                       ; $A8FD91 |
  LDA.B $09,X                               ; $A8FD92 |
  SBC.B $01                                 ; $A8FD94 |
  BMI CODE_A8FDA0                           ; $A8FD96 |
  LDA.B $09,X                               ; $A8FD98 |
  SBC.B $2E,X                               ; $A8FD9A |
  SBC.B $0E                                 ; $A8FD9C |
  BRA CODE_A8FDA6                           ; $A8FD9E |

CODE_A8FDA0:
  LDA.B $09,X                               ; $A8FDA0 |
  ADC.B $2E,X                               ; $A8FDA2 |
  ADC.B $0E                                 ; $A8FDA4 |

CODE_A8FDA6:
  STA.W $0009,Y                             ; $A8FDA6 |
  TDC                                       ; $A8FDA9 |
  STA.W $0026,Y                             ; $A8FDAA |
  BRA CODE_JP_A8FDDA                        ; $A8FDAD |

CODE_A8FDAF:
  LDA.B $34,X                               ; $A8FDAF |
  AND.W #$0008                              ; $A8FDB1 |
  BEQ CODE_JP_A8FDDA                        ; $A8FDB4 |
  LDA.W $0028,Y                             ; $A8FDB6 |
  BPL CODE_JP_A8FDDA                        ; $A8FDB9 |
  CLC                                       ; $A8FDBB |
  LDA.B $0D,X                               ; $A8FDBC |
  ADC.B $10                                 ; $A8FDBE |
  STA.B $26                                 ; $A8FDC0 |
  SEC                                       ; $A8FDC2 |
  SBC.B $04                                 ; $A8FDC3 |
  CMP.W #$0006                              ; $A8FDC5 |
  BCC CODE_JP_A8FDDA                        ; $A8FDC8 |
  LDA.B $46,X                               ; $A8FDCA |
  ORA.W #$0010                              ; $A8FDCC |
  STA.B $46,X                               ; $A8FDCF |
  LDA.B $26                                 ; $A8FDD1 |
  STA.W $000D,Y                             ; $A8FDD3 |
  TDC                                       ; $A8FDD6 |
  STA.W $0028,Y                             ; $A8FDD7 |

CODE_JP_A8FDDA:
  RTS                                       ; $A8FDDA |

  PLA                                       ; $A8FDDB |
  LDX.B $FC                                 ; $A8FDDC |
  RTL                                       ; $A8FDDE |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FDDF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FDE7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FDEF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FDF7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FDFF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE07 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE0F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE17 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE1F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE27 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE2F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE37 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE3F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE47 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE4F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE57 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE5F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE67 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE6F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE77 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE7F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE87 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE8F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE97 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FE9F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEA7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEAF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEB7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEBF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEC7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FECF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FED7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEDF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEE7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEEF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEF7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FEFF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF07 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF0F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF17 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF1F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF27 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF2F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF37 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF3F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF47 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF4F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF57 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF5F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF67 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF6F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF77 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF7F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF87 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF8F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF97 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FF9F |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFA7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFAF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFB7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFBF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFC7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFCF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFD7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFDF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFE7 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFEF |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A8FFF7 |
  db $FF                                    ; $A8FFFF |
