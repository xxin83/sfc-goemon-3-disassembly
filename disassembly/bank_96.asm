org $968000

incbin ../assets/bank_96.bin:$0000..$0AB9   ; $968000 |

  incsrc data_logo_support_968ab9.asm

VRAM_968CFB:
  incsrc data_font_968cfb.asm

  incsrc data_bank96_small_sources.asm
  incsrc data_vram_969e44.asm
incbin ../assets/bank_96.bin:$1F03..$7880   ; $969F03 |

CODE_96F880:
  JSL.L CODE_FL_86C3A3                      ; $96F880 |
  LDA.B $1A,X                               ; $96F884 |
  PHX                                       ; $96F886 |
  ASL A                                     ; $96F887 |
  TAX                                       ; $96F888 |
  LDA.L PTR16_96F893,X                      ; $96F889 |
  PLX                                       ; $96F88D |
  STA.B $00                                 ; $96F88E |
  JMP.W ($0000)                             ; $96F890 |

PTR16_96F893:
  dw CODE_96F8BD                            ; $96F893 |
  dw CODE_96F8EC                            ; $96F895 |
  dw CODE_96F922                            ; $96F897 |
  dw CODE_96F96A                            ; $96F899 |
  dw CODE_96F96A                            ; $96F89B |
  dw CODE_96F96A                            ; $96F89D |
  dw CODE_96F988                            ; $96F89F |
  dw CODE_96F9BA                            ; $96F8A1 |
  dw CODE_JL_96F995                         ; $96F8A3 |
  dw CODE_96F9A3                            ; $96F8A5 |
  dw CODE_JL_96F9BB                         ; $96F8A7 |
  dw CODE_96F9C2                            ; $96F8A9 |
  dw CODE_96F9C9                            ; $96F8AB |
  dw CODE_JL_96F9E4                         ; $96F8AD |
  dw CODE_JL_96FA02                         ; $96F8AF |
  dw CODE_JL_96FA3A                         ; $96F8B1 |
  dw CODE_JL_96FAFC                         ; $96F8B3 |
  dw CODE_96F96A                            ; $96F8B5 |
  dw CODE_96F96A                            ; $96F8B7 |
  dw CODE_96F96A                            ; $96F8B9 |
  dw CODE_JL_96FAFC                         ; $96F8BB |

CODE_96F8BD:
  LDA.W #$0018                              ; $96F8BD |
  STA.B $2E,X                               ; $96F8C0 |
  LDA.W #$0004                              ; $96F8C2 |
  STA.B $30,X                               ; $96F8C5 |
  LDA.W #$0060                              ; $96F8C7 |
  STA.B $42,X                               ; $96F8CA |
  LDA.W #$8100                              ; $96F8CC |
  STA.B $22,X                               ; $96F8CF |
  STZ.B $37,X                               ; $96F8D1 |
  LDA.W #$FFF0                              ; $96F8D3 |
  JSL.L CODE_FL_86CB2D                      ; $96F8D6 |
  BCC CODE_96F8E9                           ; $96F8DA |
  INC.B $1A,X                               ; $96F8DC |
  LDA.L $70030E                             ; $96F8DE |
  BEQ CODE_96F8E9                           ; $96F8E2 |
  LDA.W #$0011                              ; $96F8E4 |
  STA.B $1A,X                               ; $96F8E7 |

CODE_96F8E9:
  STZ.B $32,X                               ; $96F8E9 |
  RTL                                       ; $96F8EB |

CODE_96F8EC:
  TDC                                       ; $96F8EC |
  LDY.W $1672                               ; $96F8ED |
  BNE CODE_96F8F5                           ; $96F8F0 |
  LDA.W #$A001                              ; $96F8F2 |

CODE_96F8F5:
  STA.B $34,X                               ; $96F8F5 |
  LDA.B $32,X                               ; $96F8F7 |
  BPL CODE_96F8E9                           ; $96F8F9 |
  LDA.B $37,X                               ; $96F8FB |
  AND.W #$00FF                              ; $96F8FD |
  CMP.W #$000E                              ; $96F900 |
  BNE CODE_96F8E9                           ; $96F903 |
  TDC                                       ; $96F905 |
  STA.L $7E7C04                             ; $96F906 |
  LDA.W #$8001                              ; $96F90A |
  STA.B $E4                                 ; $96F90D |
  INC.B $1A,X                               ; $96F90F |
  LDA.W #$0030                              ; $96F911 |
  JSL.L CODE_FL_8089BD                      ; $96F914 |
  JSL.L CODE_FL_80893F                      ; $96F918 |
  LDY.B $A6                                 ; $96F91C |
  JML.L CODE_FL_8098E4                      ; $96F91E |

CODE_96F922:
  LDA.W #$0007                              ; $96F922 |
  STA.B $10                                 ; $96F925 |

CODE_96F927:
  LDA.W #$0321                              ; $96F927 |
  JSL.L CODE_FL_86C9DA                      ; $96F92A |
  BCS CODE_96F964                           ; $96F92E |
  PHX                                       ; $96F930 |
  TYX                                       ; $96F931 |
  LDA.B $10                                 ; $96F932 |
  LDY.W #$0040                              ; $96F934 |
  JSL.L CODE_FL_8AB4B3                      ; $96F937 |
  LDA.B $00                                 ; $96F93B |
  JSL.L CODE_FL_86C85B                      ; $96F93D |
  LDA.B $02                                 ; $96F941 |
  JSL.L CODE_FL_8CFD63                      ; $96F943 |
  LDY.W #$0028                              ; $96F947 |
  LDA.B $10                                 ; $96F94A |
  ASL A                                     ; $96F94C |
  JSL.L CODE_FL_8AB499                      ; $96F94D |
  LDA.B $28,X                               ; $96F951 |
  STA.B $2A,X                               ; $96F953 |
  STZ.B $28,X                               ; $96F955 |
  LDA.W #$9014                              ; $96F957 |
  JSL.L CODE_FL_86CAEE                      ; $96F95A |
  LDA.W #$00B4                              ; $96F95E |
  STA.B $2C,X                               ; $96F961 |
  PLX                                       ; $96F963 |

CODE_96F964:
  DEC.B $10                                 ; $96F964 |
  BNE CODE_96F927                           ; $96F966 |
  INC.B $1A,X                               ; $96F968 |

CODE_96F96A:
  LDA.W #$0060                              ; $96F96A |
  STA.B $10                                 ; $96F96D |
  SEC                                       ; $96F96F |
  LDA.B $3A,X                               ; $96F970 |
  ASL A                                     ; $96F972 |
  TAY                                       ; $96F973 |
  ASL A                                     ; $96F974 |
  ASL A                                     ; $96F975 |
  ASL A                                     ; $96F976 |
  ASL A                                     ; $96F977 |
  STA.B $12                                 ; $96F978 |
  TYA                                       ; $96F97A |
  ADC.W #$012A                              ; $96F97B |
  JSL.L CODE_FL_8580EE                      ; $96F97E |
  BCS CODE_96F9BA                           ; $96F982 |
  INC.B $3A,X                               ; $96F984 |
  BRA CODE_96F9B8                           ; $96F986 |

CODE_96F988:
  LDA.W #$0322                              ; $96F988 |
  JSL.L CODE_FL_86C9DA                      ; $96F98B |
  BCS CODE_96F9BA                           ; $96F98F |
  STX.B $3C,Y                               ; $96F991 |
  BRA CODE_96F9B8                           ; $96F993 |

CODE_JL_96F995:
  JSL.L CODE_FL_8B80CE                      ; $96F995 |
  JSL.L CODE_FL_84ECC0                      ; $96F999 |
  JSL.L CODE_FL_83852F                      ; $96F99D |
  BRA CODE_96F9B8                           ; $96F9A1 |

CODE_96F9A3:
  LDA.W #$0011                              ; $96F9A3 |
  STA.B $92                                 ; $96F9A6 |
  STZ.W $1960                               ; $96F9A8 |
  STZ.W $1962                               ; $96F9AB |
  LDA.W #$0080                              ; $96F9AE |
  TAY                                       ; $96F9B1 |
  JSL.L CODE_FL_8B8111                      ; $96F9B2 |
  BNE CODE_96F9BA                           ; $96F9B6 |

CODE_96F9B8:
  INC.B $1A,X                               ; $96F9B8 |

CODE_96F9BA:
  RTL                                       ; $96F9BA |

CODE_JL_96F9BB:
  JSL.L CODE_FL_8B86D2                      ; $96F9BB |
  BCC CODE_96F9B8                           ; $96F9BF |
  RTL                                       ; $96F9C1 |

CODE_96F9C2:
  JSL.L CODE_FL_8098F8                      ; $96F9C2 |
  BCS CODE_96F9B8                           ; $96F9C6 |

CODE_96F9C8:
  RTL                                       ; $96F9C8 |

CODE_96F9C9:
  JSL.L CODE_FL_80893F                      ; $96F9C9 |

CODE_JL_96F9CD:
  PHX                                       ; $96F9CD |
  JSL.L CODE_FL_80C213                      ; $96F9CE |
  TDC                                       ; $96F9D2 |
  STA.L $7E7C04                             ; $96F9D3 |
  LDA.W #$8001                              ; $96F9D7 |
  STA.B $E4                                 ; $96F9DA |
  PLX                                       ; $96F9DC |
  LDA.W #$0005                              ; $96F9DD |
  STA.B $2C,X                               ; $96F9E0 |
  BRA CODE_96F9B8                           ; $96F9E2 |

CODE_JL_96F9E4:
  JSL.L CODE_FL_86C70D                      ; $96F9E4 |
  LDA.W $1F30                               ; $96F9E8 |
  BNE CODE_96F9C8                           ; $96F9EB |
  INC.B $1A,X                               ; $96F9ED |
  LDA.W #$000A                              ; $96F9EF |
  STA.B $2C,X                               ; $96F9F2 |
  TDC                                       ; $96F9F4 |
  DEC A                                     ; $96F9F5 |
  STA.L $7E7C04                             ; $96F9F6 |
  JSL.L CODE_FL_8B8000                      ; $96F9FA |
  JML.L CODE_FL_8B8067                      ; $96F9FE |

CODE_JL_96FA02:
  STZ.B $92                                 ; $96FA02 |
  LDA.W #$0200                              ; $96FA04 |
  STA.W $0498                               ; $96FA07 |
  LDA.W #$0100                              ; $96FA0A |
  STA.W $0558                               ; $96FA0D |
  JSL.L CODE_FL_86C70D                      ; $96FA10 |
  LDA.W #$0400                              ; $96FA14 |
  STA.W $0498                               ; $96FA17 |
  LDA.W #$0400                              ; $96FA1A |
  STA.W $0558                               ; $96FA1D |
  PHX                                       ; $96FA20 |
  JSL.L CODE_FL_80C222                      ; $96FA21 |
  PLX                                       ; $96FA25 |
  LDA.B $18,X                               ; $96FA26 |
  CMP.W #$0320                              ; $96FA28 |
  BNE CODE_96FA37                           ; $96FA2B |
  LDA.W #$0080                              ; $96FA2D |
  LDY.W #$00D0                              ; $96FA30 |
  JSL.L CODE_FL_96FC35                      ; $96FA33 |

CODE_96FA37:
  INC.B $1A,X                               ; $96FA37 |
  RTL                                       ; $96FA39 |

CODE_JL_96FA3A:
  STZ.B $92                                 ; $96FA3A |
  STZ.W $1960                               ; $96FA3C |
  STZ.W $1962                               ; $96FA3F |
  LDA.W $1F30                               ; $96FA42 |
  BNE CODE_96F9C8                           ; $96FA45 |
  STZ.B $E4                                 ; $96FA47 |
  BRA CODE_96FA37                           ; $96FA49 |

CODE_96FA4B:
  LDA.W #$0100                              ; $96FA4B |
  STA.B $22,X                               ; $96FA4E |
  JSL.L CODE_FL_8CFD8F                      ; $96FA50 |
  LDA.B $2C,X                               ; $96FA54 |
  BEQ CODE_96FA75                           ; $96FA56 |
  CMP.W #$001E                              ; $96FA58 |
  BCS CODE_96FA69                           ; $96FA5B |
  BIT.W #$0003                              ; $96FA5D |
  BNE CODE_96FA69                           ; $96FA60 |
  LDA.W #$0080                              ; $96FA62 |
  EOR.B $02,X                               ; $96FA65 |
  STA.B $02,X                               ; $96FA67 |

CODE_96FA69:
  LDA.W #$0030                              ; $96FA69 |
  JSL.L CODE_FL_8CFD7A                      ; $96FA6C |
  LDA.B $11,X                               ; $96FA70 |
  BMI CODE_96FA75                           ; $96FA72 |
  RTL                                       ; $96FA74 |

CODE_96FA75:
  JML.L CODE_FL_86CA57                      ; $96FA75 |

CODE_96FA79:
  LDY.B $3C,X                               ; $96FA79 |
  LDA.W $001A,Y                             ; $96FA7B |
  CMP.W #$000E                              ; $96FA7E |
  BCS CODE_96FAF5                           ; $96FA81 |
  JSL.L CODE_FL_8CFD8F                      ; $96FA83 |
  PHX                                       ; $96FA87 |
  ASL A                                     ; $96FA88 |
  TAX                                       ; $96FA89 |
  LDA.L PTR16_96FA94,X                      ; $96FA8A |
  PLX                                       ; $96FA8E |
  STA.B $00                                 ; $96FA8F |
  JMP.W ($0000)                             ; $96FA91 |

PTR16_96FA94:
  dw CODE_96FA9C                            ; $96FA94 |
  dw CODE_96FABA                            ; $96FA96 |
  dw CODE_96FADD                            ; $96FA98 |
  dw CODE_96FAF4                            ; $96FA9A |

CODE_96FA9C:
  LDA.W #$8100                              ; $96FA9C |
  STA.B $22,X                               ; $96FA9F |
  LDA.W #$9012                              ; $96FAA1 |
  JSL.L CODE_FL_86CAEE                      ; $96FAA4 |
  LDA.W #$0006                              ; $96FAA8 |
  STA.B $11,X                               ; $96FAAB |
  LDA.W #$0400                              ; $96FAAD |
  STA.B $2A,X                               ; $96FAB0 |
  LDA.W #$00E0                              ; $96FAB2 |
  STA.B $28,X                               ; $96FAB5 |
  INC.B $1A,X                               ; $96FAB7 |

CODE_96FAB9:
  RTL                                       ; $96FAB9 |

CODE_96FABA:
  LDA.W #$0030                              ; $96FABA |
  JSL.L CODE_FL_8CFD7A                      ; $96FABD |
  BIT.B $11,X                               ; $96FAC1 |
  BPL CODE_96FAB9                           ; $96FAC3 |
  LDY.B $3C,X                               ; $96FAC5 |
  LDA.W $001A,Y                             ; $96FAC7 |
  INC A                                     ; $96FACA |
  STA.W $001A,Y                             ; $96FACB |
  STZ.B $11,X                               ; $96FACE |
  STZ.B $2A,X                               ; $96FAD0 |
  STZ.B $28,X                               ; $96FAD2 |
  INC.B $1A,X                               ; $96FAD4 |
  LDY.W #$00E8                              ; $96FAD6 |
  JML.L CODE_FL_808993                      ; $96FAD9 |

CODE_96FADD:
  LDA.L $7E7C04                             ; $96FADD |
  DEC A                                     ; $96FAE1 |
  BNE CODE_96FAF4                           ; $96FAE2 |
  LDA.W #$0001                              ; $96FAE4 |
  STA.L $70030E                             ; $96FAE7 |
  LDA.W #$9013                              ; $96FAEB |
  JSL.L CODE_FL_86CAEE                      ; $96FAEE |
  INC.B $1A,X                               ; $96FAF2 |

CODE_96FAF4:
  RTL                                       ; $96FAF4 |

CODE_96FAF5:
  LDY.W #$00E4                              ; $96FAF5 |
  JSL.L CODE_FL_808993                      ; $96FAF8 |

CODE_JL_96FAFC:
  JML.L CODE_FL_86CA57                      ; $96FAFC |

  LDA.W #$F4E0                              ; $96FB00 |
  JSL.L CODE_FL_80E9EA                      ; $96FB03 |
  LDA.W #$0001                              ; $96FB07 |
  STA.L $7002F8                             ; $96FB0A |
  LDA.W #$0001                              ; $96FB0E |
  STA.L $70030C                             ; $96FB11 |
  LDA.W #$0001                              ; $96FB15 |
  STA.L $7002FC                             ; $96FB18 |
  STA.L $7002FE                             ; $96FB1C |
  LDA.W #$0001                              ; $96FB20 |
  STA.L $700310                             ; $96FB23 |
  LDA.W #$0100                              ; $96FB27 |
  STA.L $700290                             ; $96FB2A |
  LDA.W #$0006                              ; $96FB2E |
  STA.L $700292                             ; $96FB31 |
  LDA.W #$0003                              ; $96FB35 |
  STA.L $700294                             ; $96FB38 |
  LDA.W #$0003                              ; $96FB3C |
  STA.L $7002A6                             ; $96FB3F |

CODE_FL_96FB43:
  LDA.W #$FE42                              ; $96FB43 |
  STA.L $7002E8                             ; $96FB46 |
  LDA.W #$0020                              ; $96FB4A |
  STA.L $7002EA                             ; $96FB4D |
  LDA.W #$00B0                              ; $96FB51 |
  STA.L $7002EC                             ; $96FB54 |
  RTL                                       ; $96FB58 |

  JML.L CODE_FL_80FB10                      ; $96FB59 |

CODE_FL_96FB5D:
  LDA.L $7002A6                             ; $96FB5D |
  STA.B $B8                                 ; $96FB61 |

CODE_FL_96FB63:
  LDA.L $700290                             ; $96FB63 |
  STA.B $BE                                 ; $96FB67 |
  LDA.L $700292                             ; $96FB69 |
  STA.B $BA                                 ; $96FB6D |
  LDA.L $700294                             ; $96FB6F |
  STA.B $BC                                 ; $96FB73 |
  LDX.W #$0400                              ; $96FB75 |
  LDA.B $18,X                               ; $96FB78 |
  BEQ CODE_96FB82                           ; $96FB7A |
  JSL.L CODE_FL_83CE65                      ; $96FB7C |
  STA.B $9E,X                               ; $96FB80 |

CODE_96FB82:
  LDX.W #$04C0                              ; $96FB82 |
  LDA.B $18,X                               ; $96FB85 |
  BEQ CODE_96FB8F                           ; $96FB87 |
  JSL.L CODE_FL_83CE65                      ; $96FB89 |
  STA.B $9E,X                               ; $96FB8D |

CODE_96FB8F:
  RTL                                       ; $96FB8F |

CODE_FL_96FB90:
  LDA.B $B8                                 ; $96FB90 |
  STA.L $7002A6                             ; $96FB92 |
  LDA.B $BE                                 ; $96FB96 |
  STA.L $700290                             ; $96FB98 |
  LDA.B $BA                                 ; $96FB9C |
  STA.L $700292                             ; $96FB9E |
  LDA.B $BC                                 ; $96FBA2 |
  STA.L $700294                             ; $96FBA4 |
  RTL                                       ; $96FBA8 |

CODE_FL_96FBA9:
  LDA.W #$0001                              ; $96FBA9 |
  STA.L $700320                             ; $96FBAC |
  RTL                                       ; $96FBB0 |

CODE_FL_96FBB1:
  LDA.W #$0001                              ; $96FBB1 |
  STA.L $700334                             ; $96FBB4 |
  RTL                                       ; $96FBB8 |

CODE_FL_96FBB9:
  PHX                                       ; $96FBB9 |
  LDA.B !r_room_mode                        ; $96FBBA |
  CMP.W #$0001                              ; $96FBBC |
  BEQ CODE_96FBE7                           ; $96FBBF |
  LDA.B !r_room_mode                        ; $96FBC1 |
  CMP.W #$0000                              ; $96FBC3 |
  BNE CODE_96FC0A                           ; $96FBC6 |
  LDA.B $A6                                 ; $96FBC8 |
  BNE CODE_96FC0A                           ; $96FBCA |
  STZ.W $0B3A                               ; $96FBCC |
  JSL.L CODE_FL_83B1D8                      ; $96FBCF |
  LDA.W #$00CA                              ; $96FBD3 |
  STA.L $7002EA                             ; $96FBD6 |
  LDA.W #$0078                              ; $96FBDA |
  STA.L $7002EC                             ; $96FBDD |
  JSL.L CODE_FL_83B28B                      ; $96FBE1 |
  PLX                                       ; $96FBE5 |
  RTL                                       ; $96FBE6 |

CODE_96FBE7:
  LDA.B $A6                                 ; $96FBE7 |
  BNE CODE_96FC0A                           ; $96FBE9 |
  STZ.W $0B3A                               ; $96FBEB |
  JSL.L CODE_FL_83B1D8                      ; $96FBEE |
  LDA.W $1662                               ; $96FBF2 |
  CLC                                       ; $96FBF5 |
  ADC.B $00                                 ; $96FBF6 |
  STA.L $7002EA                             ; $96FBF8 |
  LDA.W $1672                               ; $96FBFC |
  CLC                                       ; $96FBFF |
  ADC.B $02                                 ; $96FC00 |
  STA.L $7002EC                             ; $96FC02 |
  JSL.L CODE_FL_83B28B                      ; $96FC06 |

CODE_96FC0A:
  PLX                                       ; $96FC0A |
  RTL                                       ; $96FC0B |

CODE_FL_96FC0C:
  PHX                                       ; $96FC0C |
  LDA.W #$0001                              ; $96FC0D |
  STA.L $7002EE                             ; $96FC10 |
  TDC                                       ; $96FC14 |
  STA.L $7002F0                             ; $96FC15 |
  STA.L $7002F2                             ; $96FC19 |
  LDA.W #$0300                              ; $96FC1D |
  STA.L $7002E2                             ; $96FC20 |
  LDA.W #$0300                              ; $96FC24 |
  STA.L $7002E4                             ; $96FC27 |
  JSL.L CODE_FL_96FB43                      ; $96FC2B |
  JSL.L CODE_FL_83B28B                      ; $96FC2F |
  PLX                                       ; $96FC33 |
  RTL                                       ; $96FC34 |

CODE_FL_96FC35:
  STA.L $7002EA                             ; $96FC35 |
  TYA                                       ; $96FC39 |
  STA.L $7002EC                             ; $96FC3A |
  PHX                                       ; $96FC3E |
  JSL.L CODE_FL_83B1D8                      ; $96FC3F |
  JSL.L CODE_FL_83B28B                      ; $96FC43 |
  PLX                                       ; $96FC47 |
  RTL                                       ; $96FC48 |

CODE_FL_96FC49:
  BEQ CODE_96FC86                           ; $96FC49 |
  CMP.W #$0001                              ; $96FC4B |
  BEQ CODE_96FC6B                           ; $96FC4E |
  REP #$30                                  ; $96FC50 |
  PHB                                       ; $96FC52 |
  LDA.W #$0000                              ; $96FC53 |
  STA.L $701700                             ; $96FC56 |
  LDA.W #$06F3                              ; $96FC5A |
  LDX.W #$1701                              ; $96FC5D |
  TXY                                       ; $96FC60 |
  INY                                       ; $96FC61 |
  MVN $70,$70                               ; $96FC62 |
  PLB                                       ; $96FC65 |
  LDX.W #$1700                              ; $96FC66 |
  BRA CODE_96FC9F                           ; $96FC69 |

CODE_96FC6B:
  REP #$30                                  ; $96FC6B |
  PHB                                       ; $96FC6D |
  LDA.W #$0000                              ; $96FC6E |
  STA.L $701000                             ; $96FC71 |
  LDA.W #$06F3                              ; $96FC75 |
  LDX.W #$1001                              ; $96FC78 |
  TXY                                       ; $96FC7B |
  INY                                       ; $96FC7C |
  MVN $70,$70                               ; $96FC7D |
  PLB                                       ; $96FC80 |
  LDX.W #$1000                              ; $96FC81 |
  BRA CODE_96FC9F                           ; $96FC84 |

CODE_96FC86:
  REP #$30                                  ; $96FC86 |
  PHB                                       ; $96FC88 |
  LDA.W #$0000                              ; $96FC89 |
  STA.L $700900                             ; $96FC8C |
  LDA.W #$06F3                              ; $96FC90 |
  LDX.W #$0901                              ; $96FC93 |
  TXY                                       ; $96FC96 |
  INY                                       ; $96FC97 |
  MVN $70,$70                               ; $96FC98 |
  PLB                                       ; $96FC9B |
  LDX.W #$0900                              ; $96FC9C |

CODE_96FC9F:
  LDA.W #$000A                              ; $96FC9F |
  STA.L $700092,X                           ; $96FCA2 |
  LDA.W #$000A                              ; $96FCA6 |
  STA.L $700094,X                           ; $96FCA9 |
  LDA.W #$0100                              ; $96FCAD |
  STA.L $700090,X                           ; $96FCB0 |
  LDA.W #$0003                              ; $96FCB4 |
  STA.L $7000A6,X                           ; $96FCB7 |
  LDA.W #$0001                              ; $96FCBB |
  STA.L $7000F8,X                           ; $96FCBE |
  STA.L $7000FC,X                           ; $96FCC2 |
  STA.L $7000FE,X                           ; $96FCC6 |
  LDA.W #$0010                              ; $96FCCA |
  STA.L $700106,X                           ; $96FCCD |
  LDA.W #$0001                              ; $96FCD1 |
  STA.L $70010C,X                           ; $96FCD4 |
  STA.L $700110,X                           ; $96FCD8 |
  LDA.W #$0010                              ; $96FCDC |
  STA.L $70012E,X                           ; $96FCDF |
  LDA.W #$0001                              ; $96FCE3 |
  STA.L $700138,X                           ; $96FCE6 |
  LDA.W #$FE42                              ; $96FCEA |
  STA.L $7000E8,X                           ; $96FCED |
  LDA.W #$0020                              ; $96FCF1 |
  STA.L $7000EA,X                           ; $96FCF4 |
  LDA.W #$00B0                              ; $96FCF8 |
  STA.L $7000EC,X                           ; $96FCFB |
  RTL                                       ; $96FCFF |

CODE_FL_96FD00:
  PHB                                       ; $96FD00 |
  PEA.W $8787                               ; $96FD01 |
  PLB                                       ; $96FD04 |
  PLB                                       ; $96FD05 |
  LDA.L $700768                             ; $96FD06 |
  BNE CODE_96FD1A                           ; $96FD0A |

CODE_JP_96FD0C:
  PEA.W $8484                               ; $96FD0C |
  PLB                                       ; $96FD0F |
  PLB                                       ; $96FD10 |
  LDA.W #$F4E0                              ; $96FD11 |
  JSL.L CODE_FL_80E9EA                      ; $96FD14 |
  PLB                                       ; $96FD18 |
  RTL                                       ; $96FD19 |

CODE_96FD1A:
  LDA.W #$0100                              ; $96FD1A |
  STA.W $195E                               ; $96FD1D |
  LDA.L $700768                             ; $96FD20 |
  BNE CODE_96FD29                           ; $96FD24 |
  JMP.W CODE_JP_96FDDF                      ; $96FD26 |

CODE_96FD29:
  BIT.W #$0001                              ; $96FD29 |
  BEQ CODE_96FD31                           ; $96FD2C |
  JMP.W CODE_JP_96FDDF                      ; $96FD2E |

CODE_96FD31:
  CMP.W #$0036                              ; $96FD31 |
  BCC CODE_96FD39                           ; $96FD34 |
  JMP.W CODE_JP_96FDDF                      ; $96FD36 |

CODE_96FD39:
  CMP.W #$002A                              ; $96FD39 |
  BEQ CODE_96FDB6                           ; $96FD3C |
  CMP.W #$002C                              ; $96FD3E |
  BEQ CODE_96FDB6                           ; $96FD41 |
  TAY                                       ; $96FD43 |
  LDA.W LOOSE_OP_00DEFD,Y                   ; $96FD44 |
  STA.B $20                                 ; $96FD47 |
  BPL CODE_96FD51                           ; $96FD49 |
  JSL.L CODE_FL_80E9EA                      ; $96FD4B |
  PLB                                       ; $96FD4F |
  RTL                                       ; $96FD50 |

CODE_96FD51:
  LDA.B $20                                 ; $96FD51 |
  AND.W #$FF00                              ; $96FD53 |
  CMP.W #$0300                              ; $96FD56 |
  BEQ CODE_96FD72                           ; $96FD59 |
  CMP.W #$0400                              ; $96FD5B |
  BEQ CODE_96FD88                           ; $96FD5E |
  CMP.W #$0500                              ; $96FD60 |
  BEQ CODE_96FDA0                           ; $96FD63 |
  CMP.W #$002A                              ; $96FD65 |
  BEQ CODE_96FDA0                           ; $96FD68 |
  CMP.W #$002C                              ; $96FD6A |
  BEQ CODE_96FDA0                           ; $96FD6D |
  JMP.W CODE_JP_96FDDF                      ; $96FD6F |

CODE_96FD72:
  LDA.W #$0002                              ; $96FD72 |
  STA.B !r_room_mode                        ; $96FD75 |
  LDA.B $20                                 ; $96FD77 |
  AND.W #$00FF                              ; $96FD79 |
  CMP.W #$0002                              ; $96FD7C |
  BCS CODE_JP_96FDDF                        ; $96FD7F |
  ORA.W #$8000                              ; $96FD81 |
  STA.B $DA                                 ; $96FD84 |
  PLB                                       ; $96FD86 |
  RTL                                       ; $96FD87 |

CODE_96FD88:
  LDA.W #$0003                              ; $96FD88 |
  STA.B !r_room_mode                        ; $96FD8B |
  LDA.B $20                                 ; $96FD8D |
  AND.W #$00FF                              ; $96FD8F |
  CMP.W #$00FC                              ; $96FD92 |
  BCC CODE_JP_96FDDF                        ; $96FD95 |
  CMP.W #$00FF                              ; $96FD97 |
  BCS CODE_JP_96FDDF                        ; $96FD9A |
  STA.B !r_room_id                          ; $96FD9C |
  PLB                                       ; $96FD9E |
  RTL                                       ; $96FD9F |

CODE_96FDA0:
  LDA.W #$0004                              ; $96FDA0 |
  STA.B !r_room_mode                        ; $96FDA3 |
  LDA.B $20                                 ; $96FDA5 |
  AND.W #$00FF                              ; $96FDA7 |
  CMP.W #$0003                              ; $96FDAA |
  BCS CODE_JP_96FDDF                        ; $96FDAD |
  ORA.W #$8000                              ; $96FDAF |
  STA.B $DA                                 ; $96FDB2 |
  PLB                                       ; $96FDB4 |
  RTL                                       ; $96FDB5 |

CODE_96FDB6:
  LDA.W #$0001                              ; $96FDB6 |
  STA.L $7002F8                             ; $96FDB9 |
  STA.L $70030C                             ; $96FDBD |
  STA.L $700320                             ; $96FDC1 |
  STA.L $700334                             ; $96FDC5 |
  LDA.W #$0400                              ; $96FDC9 |
  STA.W $195E                               ; $96FDCC |
  LDA.W #$0001                              ; $96FDCF |
  STA.L $7E7C5E                             ; $96FDD2 |
  LDA.W #$F5A0                              ; $96FDD6 |
  JSL.L CODE_FL_80E9EA                      ; $96FDD9 |
  PLB                                       ; $96FDDD |
  RTL                                       ; $96FDDE |

CODE_JP_96FDDF:
  JMP.W CODE_JP_96FD0C                      ; $96FDDF |

CODE_FL_96FDE2:
  LDA.W $19C4                               ; $96FDE2 |
  ORA.W #$FE00                              ; $96FDE5 |
  STA.L $7002E8                             ; $96FDE8 |
  LDA.W $19BE                               ; $96FDEC |
  SEC                                       ; $96FDEF |
  SBC.W #$0020                              ; $96FDF0 |
  STA.L $7002EA                             ; $96FDF3 |
  LDA.W $19C0                               ; $96FDF7 |
  CLC                                       ; $96FDFA |
  ADC.W #$0010                              ; $96FDFB |
  STA.L $7002EC                             ; $96FDFE |
  RTL                                       ; $96FE02 |

CODE_FL_96FE03:
  JSL.L CODE_FL_83B1D8                      ; $96FE03 |
  JSL.L CODE_FL_8CFA29                      ; $96FE07 |
  CLC                                       ; $96FE0B |
  ADC.W #$FFF0                              ; $96FE0C |
  STA.L $7002EA                             ; $96FE0F |
  JSL.L CODE_FL_8CFA30                      ; $96FE13 |
  CLC                                       ; $96FE17 |
  ADC.W #$0018                              ; $96FE18 |
  STA.L $7002EC                             ; $96FE1B |
  RTL                                       ; $96FE1F |

CODE_FL_96FE20:
  LDA.B $4C                                 ; $96FE20 |
  BNE CODE_96FE4C                           ; $96FE22 |
  PHX                                       ; $96FE24 |
  PHY                                       ; $96FE25 |
  PHB                                       ; $96FE26 |
  PEA.W $8787                               ; $96FE27 |
  PLB                                       ; $96FE2A |
  PLB                                       ; $96FE2B |
  LDA.B !r_room_mode                        ; $96FE2C |
  CMP.W #$0003                              ; $96FE2E |
  BEQ CODE_96FE91                           ; $96FE31 |
  LDY.W #$0000                              ; $96FE33 |
  LDA.W $19C4                               ; $96FE36 |

CODE_96FE39:
  CMP.W LOOSE_OP_00DEDD,Y                   ; $96FE39 |
  BEQ CODE_96FE4E                           ; $96FE3C |
  INY                                       ; $96FE3E |
  INY                                       ; $96FE3F |
  INY                                       ; $96FE40 |
  INY                                       ; $96FE41 |
  CPY.W #$0024                              ; $96FE42 |
  BCC CODE_96FE39                           ; $96FE45 |
  SEC                                       ; $96FE47 |
  PLB                                       ; $96FE48 |
  PLY                                       ; $96FE49 |
  PLX                                       ; $96FE4A |
  RTL                                       ; $96FE4B |

CODE_96FE4C:
  CLC                                       ; $96FE4C |
  RTL                                       ; $96FE4D |

CODE_96FE4E:
  LDA.W LOOSE_OP_00DEDB,Y                   ; $96FE4E |

CODE_JP_96FE51:
  STA.B $00                                 ; $96FE51 |
  JSL.L CODE_FL_96FB90                      ; $96FE53 |
  LDA.B $00                                 ; $96FE57 |
  STA.L $700768                             ; $96FE59 |
  LDA.B !r_room_mode                        ; $96FE5D |
  STA.L $70076A                             ; $96FE5F |
  JSR.W CODE_FN_96FEC2                      ; $96FE63 |
  LDA.B $C2                                 ; $96FE66 |
  ASL A                                     ; $96FE68 |
  TAX                                       ; $96FE69 |
  LDA.L DATA8_87DED5,X                      ; $96FE6A |
  TAY                                       ; $96FE6E |
  LDX.W #$0200                              ; $96FE6F |
  LDA.W #$06F5                              ; $96FE72 |
  PHB                                       ; $96FE75 |
  MVN $70,$70                               ; $96FE76 |
  PLB                                       ; $96FE79 |
  LDA.B $C2                                 ; $96FE7A |
  JSL.L CODE_FL_80FA0F                      ; $96FE7C |
  CLC                                       ; $96FE80 |
  PLB                                       ; $96FE81 |
  PLY                                       ; $96FE82 |
  PLX                                       ; $96FE83 |
  RTL                                       ; $96FE84 |

  LDA.B $4C                                 ; $96FE85 |
  BNE CODE_96FEAE                           ; $96FE87 |
  PHX                                       ; $96FE89 |
  PHY                                       ; $96FE8A |
  PHB                                       ; $96FE8B |
  PEA.W $8787                               ; $96FE8C |
  PLB                                       ; $96FE8F |
  PLB                                       ; $96FE90 |

CODE_96FE91:
  LDA.B !r_room_id                          ; $96FE91 |
  CMP.W #$00FE                              ; $96FE93 |
  BEQ CODE_96FEA7                           ; $96FE96 |
  CMP.W #$00FD                              ; $96FE98 |
  BEQ CODE_96FEA2                           ; $96FE9B |
  LDA.W #$000E                              ; $96FE9D |
  BRA CODE_96FEAA                           ; $96FEA0 |

CODE_96FEA2:
  LDA.W #$0032                              ; $96FEA2 |
  BRA CODE_96FEAA                           ; $96FEA5 |

CODE_96FEA7:
  LDA.W #$002A                              ; $96FEA7 |

CODE_96FEAA:
  STA.B $00                                 ; $96FEAA |
  BRA CODE_JP_96FE51                        ; $96FEAC |

CODE_96FEAE:
  RTL                                       ; $96FEAE |

CODE_FL_96FEAF:
  PHA                                       ; $96FEAF |
  LDA.B $4C                                 ; $96FEB0 |
  BNE CODE_96FEC0                           ; $96FEB2 |
  PLA                                       ; $96FEB4 |
  PHX                                       ; $96FEB5 |
  PHY                                       ; $96FEB6 |
  PHB                                       ; $96FEB7 |
  PEA.W $8787                               ; $96FEB8 |
  PLB                                       ; $96FEBB |
  PLB                                       ; $96FEBC |
  JMP.W CODE_JP_96FE51                      ; $96FEBD |

CODE_96FEC0:
  PLA                                       ; $96FEC0 |
  RTL                                       ; $96FEC1 |

CODE_FN_96FEC2:
  LDA.L $700292                             ; $96FEC2 |
  CMP.W #$000A                              ; $96FEC6 |
  BCS CODE_96FED2                           ; $96FEC9 |
  LDA.W #$000A                              ; $96FECB |
  STA.L $700292                             ; $96FECE |

CODE_96FED2:
  LDA.L $700290                             ; $96FED2 |
  CMP.W #$0100                              ; $96FED6 |
  BCS CODE_96FEE2                           ; $96FED9 |
  LDA.W #$0100                              ; $96FEDB |
  STA.L $700290                             ; $96FEDE |

CODE_96FEE2:
  LDA.L $7002A6                             ; $96FEE2 |
  CMP.W #$0003                              ; $96FEE6 |
  BCS CODE_96FEF2                           ; $96FEE9 |
  LDA.W #$0003                              ; $96FEEB |
  STA.L $7002A6                             ; $96FEEE |

CODE_96FEF2:
  LDA.L $7002EE                             ; $96FEF2 |
  BEQ CODE_96FF08                           ; $96FEF6 |
  LDA.L $7002E2                             ; $96FEF8 |
  CMP.W #$0300                              ; $96FEFC |
  BCS CODE_96FF08                           ; $96FEFF |
  LDA.W #$0300                              ; $96FF01 |
  STA.L $7002E2                             ; $96FF04 |

CODE_96FF08:
  RTS                                       ; $96FF08 |

  LDA.W #$0000                              ; $96FF09 |
  STA.L $7008EE                             ; $96FF0C |
  STA.L $7008F0                             ; $96FF10 |
  RTL                                       ; $96FF14 |

CODE_FL_96FF15:
  LDA.B $78                                 ; $96FF15 |
  BNE CODE_96FF75                           ; $96FF17 |
  SEP #$20                                  ; $96FF19 |
  LDA.L $7008F0                             ; $96FF1B |
  INC A                                     ; $96FF1F |
  STA.L $7008F0                             ; $96FF20 |
  CMP.B #$3C                                ; $96FF24 |
  BCC CODE_96FF72                           ; $96FF26 |
  LDA.B #$00                                ; $96FF28 |
  STA.L $7008F0                             ; $96FF2A |
  LDA.L $7008F1                             ; $96FF2E |
  INC A                                     ; $96FF32 |
  STA.L $7008F1                             ; $96FF33 |
  CMP.B #$3C                                ; $96FF37 |
  BCC CODE_96FF72                           ; $96FF39 |
  LDA.B #$00                                ; $96FF3B |
  STA.L $7008F1                             ; $96FF3D |
  SED                                       ; $96FF41 |
  LDA.L $7008EE                             ; $96FF42 |
  CLC                                       ; $96FF46 |
  ADC.B #$01                                ; $96FF47 |
  STA.L $7008EE                             ; $96FF49 |
  CMP.B #$60                                ; $96FF4D |
  BCC CODE_96FF72                           ; $96FF4F |
  LDA.B #$00                                ; $96FF51 |
  STA.L $7008EE                             ; $96FF53 |
  LDA.L $7008EF                             ; $96FF57 |
  CLC                                       ; $96FF5B |
  ADC.B #$01                                ; $96FF5C |
  STA.L $7008EF                             ; $96FF5E |
  CMP.B #$99                                ; $96FF62 |
  BCC CODE_96FF72                           ; $96FF64 |
  LDA.B #$99                                ; $96FF66 |
  STA.L $7008EF                             ; $96FF68 |
  LDA.B #$59                                ; $96FF6C |
  STA.L $7008EE                             ; $96FF6E |

CODE_96FF72:
  CLD                                       ; $96FF72 |
  REP #$20                                  ; $96FF73 |

CODE_96FF75:
  RTL                                       ; $96FF75 |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FF76 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FF7E |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FF86 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FF8E |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FF96 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FF9E |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFA6 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFAE |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFB6 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFBE |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFC6 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFCE |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFD6 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFDE |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFE6 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFEE |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $96FFF6 |
  db $FF,$FF                                ; $96FFFE |
