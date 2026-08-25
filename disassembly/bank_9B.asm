org $9B8000

  incsrc data_bank9b_sources.asm
incbin ../assets/bank_9B.bin:$71B4..$7EC0   ; $9BF1B4 |

CODE_FL_9BFEC0:
  PHB                                       ; $9BFEC0 |
  PEA.W $8181                               ; $9BFEC1 |
  PLB                                       ; $9BFEC4 |
  PLB                                       ; $9BFEC5 |
  LDA.W $19BC                               ; $9BFEC6 |
  AND.W #$00FF                              ; $9BFEC9 |
  ASL A                                     ; $9BFECC |
  TAY                                       ; $9BFECD |
  LDA.W LOOSE_OP_00F52F,Y                   ; $9BFECE |
  STA.B $00                                 ; $9BFED1 |
  LDY.W $19BA                               ; $9BFED3 |
  LDX.B $50                                 ; $9BFED6 |
  LDA.B ($00),Y                             ; $9BFED8 |
  STA.L $7E0004,X                           ; $9BFEDA |
  INY                                       ; $9BFEDE |
  INY                                       ; $9BFEDF |
  LDA.B ($00),Y                             ; $9BFEE0 |
  STA.L $7E0008,X                           ; $9BFEE2 |
  INY                                       ; $9BFEE6 |
  INY                                       ; $9BFEE7 |
  LDA.B ($00),Y                             ; $9BFEE8 |
  STA.L $7E0006,X                           ; $9BFEEA |
  INY                                       ; $9BFEEE |
  INY                                       ; $9BFEEF |
  LDA.B ($00),Y                             ; $9BFEF0 |
  STA.L $7E0009,X                           ; $9BFEF2 |
  INY                                       ; $9BFEF6 |
  INY                                       ; $9BFEF7 |
  LDA.W #$1801                              ; $9BFEF8 |
  STA.L $7E0002,X                           ; $9BFEFB |
  LDA.W #$0080                              ; $9BFEFF |
  STA.L $7E0000,X                           ; $9BFF02 |
  TXA                                       ; $9BFF06 |
  CLC                                       ; $9BFF07 |
  ADC.W #$000B                              ; $9BFF08 |
  STA.B $50                                 ; $9BFF0B |
  LDA.B ($00),Y                             ; $9BFF0D |
  CMP.W #$FFFF                              ; $9BFF0F |
  BEQ CODE_9BFF19                           ; $9BFF12 |
  db $8C,$BA,$19,$AB,$6B                    ; $9BFF14 |

CODE_9BFF19:
  STA.W $19BA                               ; $9BFF19 |
  PLB                                       ; $9BFF1C |
  RTL                                       ; $9BFF1D |

CODE_FL_9BFF1E:
  PHX                                       ; $9BFF1E |
  STZ.B $18                                 ; $9BFF1F |
  LDA.W #$0000                              ; $9BFF21 |
  SEC                                       ; $9BFF24 |
  SBC.W $1672                               ; $9BFF25 |
  AND.W #$000F                              ; $9BFF28 |
  ORA.W #$0010                              ; $9BFF2B |
  STA.B $1C                                 ; $9BFF2E |
  LDA.W $1662                               ; $9BFF30 |
  AND.W #$000F                              ; $9BFF33 |
  STA.B $1E                                 ; $9BFF36 |

CODE_9BFF38:
  STZ.B $1A                                 ; $9BFF38 |
  LDA.B $1C                                 ; $9BFF3A |
  STA.B $0A                                 ; $9BFF3C |
  LDY.B $18                                 ; $9BFF3E |
  LDA.W LOOSE_OP_00F69F,Y                   ; $9BFF40 |
  AND.W #$00FF                              ; $9BFF43 |
  CLC                                       ; $9BFF46 |
  ADC.B $1E                                 ; $9BFF47 |
  STA.B $08                                 ; $9BFF49 |

CODE_9BFF4B:
  JSL.L CODE_FL_80CA7D                      ; $9BFF4B |
  CMP.W #$0008                              ; $9BFF4F |
  BCC CODE_9BFF5F                           ; $9BFF52 |
  LDA.B $1A                                 ; $9BFF54 |
  CMP.W #$0002                              ; $9BFF56 |
  BCS CODE_9BFF7A                           ; $9BFF59 |
  db $64,$1A,$80,$02                        ; $9BFF5B |

CODE_9BFF5F:
  INC.B $1A                                 ; $9BFF5F |
  LDA.B $0A                                 ; $9BFF61 |
  CLC                                       ; $9BFF63 |
  ADC.W #$0010                              ; $9BFF64 |
  STA.B $0A                                 ; $9BFF67 |
  CMP.W #$00E0                              ; $9BFF69 |
  BCC CODE_9BFF4B                           ; $9BFF6C |
  INC.B $18                                 ; $9BFF6E |
  LDA.B $18                                 ; $9BFF70 |
  CMP.W #$000F                              ; $9BFF72 |
  BCC CODE_9BFF38                           ; $9BFF75 |
  db $FA,$38,$6B                            ; $9BFF77 |

CODE_9BFF7A:
  LDA.B $0A                                 ; $9BFF7A |
  SEC                                       ; $9BFF7C |
  SBC.W #$0018                              ; $9BFF7D |
  STA.B $0D,X                               ; $9BFF80 |
  LDA.B $08                                 ; $9BFF82 |
  STA.B $09,X                               ; $9BFF84 |
  PLX                                       ; $9BFF86 |
  CLC                                       ; $9BFF87 |
  RTL                                       ; $9BFF88 |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFF89 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFF91 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFF99 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFA1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFA9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFB1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFB9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFC1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFC9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFD1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFD9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFE1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFE9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $9BFFF1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF            ; $9BFFF9 |
