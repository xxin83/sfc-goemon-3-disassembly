org $988000

  incsrc data_bank98_sources.asm
incbin ../assets/bank_98.bin:$735F..$7E80   ; $98F35F |

CODE_98FE80:
  JSL.L CODE_FL_97FC80                      ; $98FE80 |
  LDA.B $1A,X                               ; $98FE84 |
  PHX                                       ; $98FE86 |
  ASL A                                     ; $98FE87 |
  TAX                                       ; $98FE88 |
  LDA.L PTR16_98FE93,X                      ; $98FE89 |
  PLX                                       ; $98FE8D |
  STA.B $00                                 ; $98FE8E |
  JMP.W ($0000)                             ; $98FE90 |

PTR16_98FE93:
  dw CODE_98FE9B                            ; $98FE93 |
  dw CODE_98FEAC                            ; $98FE95 |
  dw CODE_98FEC2                            ; $98FE97 |
  dw CODE_98FEDD                            ; $98FE99 |

CODE_98FE9B:
  LDA.W #$0020                              ; $98FE9B |
  STA.B $06,X                               ; $98FE9E |
  JSL.L CODE_FL_86C57D                      ; $98FEA0 |
  LDA.W #$DC9F                              ; $98FEA4 |
  STA.B $00,X                               ; $98FEA7 |
  INC.B $1A,X                               ; $98FEA9 |
  RTL                                       ; $98FEAB |

CODE_98FEAC:
  JSR.W CODE_FN_98FEFA                      ; $98FEAC |
  JSL.L CODE_FL_85FA02                      ; $98FEAF |
  LDA.B $30                                 ; $98FEB3 |
  BIT.W #$0040                              ; $98FEB5 |
  BNE CODE_98FEBB                           ; $98FEB8 |
  RTL                                       ; $98FEBA |

CODE_98FEBB:
  JSL.L CODE_FL_86C591                      ; $98FEBB |
  INC.B $1A,X                               ; $98FEBF |
  RTL                                       ; $98FEC1 |

CODE_98FEC2:
  JSR.W CODE_FN_98FEFA                      ; $98FEC2 |
  LDA.W #$0002                              ; $98FEC5 |
  STA.B $4E                                 ; $98FEC8 |
  JSL.L CODE_FL_85FA02                      ; $98FECA |
  LDA.B $30                                 ; $98FECE |
  BIT.W #$0040                              ; $98FED0 |
  BNE CODE_98FED6                           ; $98FED3 |
  RTL                                       ; $98FED5 |

CODE_98FED6:
  JSL.L CODE_FL_86C58C                      ; $98FED6 |
  INC.B $1A,X                               ; $98FEDA |
  RTL                                       ; $98FEDC |

CODE_98FEDD:
  JSR.W CODE_FN_98FEFA                      ; $98FEDD |
  LDA.W #$0001                              ; $98FEE0 |
  STA.B $4E                                 ; $98FEE3 |
  JSL.L CODE_FL_85FA02                      ; $98FEE5 |
  LDA.B $30                                 ; $98FEE9 |
  BIT.W #$0040                              ; $98FEEB |
  BNE CODE_98FEF1                           ; $98FEEE |
  RTL                                       ; $98FEF0 |

CODE_98FEF1:
  JSL.L CODE_FL_86C596                      ; $98FEF1 |
  DEC.B $1A,X                               ; $98FEF5 |
  DEC.B $1A,X                               ; $98FEF7 |
  RTL                                       ; $98FEF9 |

CODE_FN_98FEFA:
  LDY.W #$0400                              ; $98FEFA |
  JSL.L CODE_FL_86C89E                      ; $98FEFD |
  SEC                                       ; $98FF01 |
  LDA.B $0D,X                               ; $98FF02 |
  SBC.W #$000C                              ; $98FF04 |
  STA.B $0D,X                               ; $98FF07 |
  LDA.W #$0004                              ; $98FF09 |
  STA.B $0E                                 ; $98FF0C |
  LDA.W #$0008                              ; $98FF0E |
  STA.B $10                                 ; $98FF11 |
  STZ.B $0A                                 ; $98FF13 |
  STZ.B $0C                                 ; $98FF15 |
  RTS                                       ; $98FF17 |

CODE_FL_98FF18:
  LDA.B $1E,X                               ; $98FF18 |
  CLC                                       ; $98FF1A |
  ADC.B $1C,X                               ; $98FF1B |
  TAY                                       ; $98FF1D |
  LDA.W $0000,Y                             ; $98FF1E |
  STA.B $00,X                               ; $98FF21 |
  DEC.B $20,X                               ; $98FF23 |
  BNE CODE_98FF52                           ; $98FF25 |
  CLC                                       ; $98FF27 |
  LDA.B $1C,X                               ; $98FF28 |
  ADC.W #$0003                              ; $98FF2A |
  STA.B $1C,X                               ; $98FF2D |
  CLC                                       ; $98FF2F |
  ADC.B $1E,X                               ; $98FF30 |
  TAY                                       ; $98FF32 |
  LDA.W $0002,Y                             ; $98FF33 |
  AND.W #$00FF                              ; $98FF36 |
  STA.B $20,X                               ; $98FF39 |
  BNE CODE_98FF40                           ; $98FF3B |
  STZ.B $1E,X                               ; $98FF3D |
  RTL                                       ; $98FF3F |

CODE_98FF40:
  CMP.W #$00FF                              ; $98FF40 |
  BNE CODE_98FF52                           ; $98FF43 |
  STZ.B $1C,X                               ; $98FF45 |
  LDA.B $1E,X                               ; $98FF47 |
  TAY                                       ; $98FF49 |
  LDA.W $0002,Y                             ; $98FF4A |
  AND.W #$00FF                              ; $98FF4D |
  STA.B $20,X                               ; $98FF50 |

CODE_98FF52:
  LDA.W $0000,Y                             ; $98FF52 |
  STA.B $00,X                               ; $98FF55 |
  RTL                                       ; $98FF57 |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF58 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF60 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF68 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF70 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF78 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF80 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF88 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF90 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FF98 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFA0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFA8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFB0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFB8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFC0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFC8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFD0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFD8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFE0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFE8 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFF0 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $98FFF8 |
