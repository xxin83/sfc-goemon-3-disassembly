lorom
org $808000

arch 65816

start:
  CLC                                       ; $808000 |\ Switch to native mode
  XCE                                       ; $808001 |/
  SEI                                       ; $808002 |  Disable IRQ
  CLD                                       ; $808003 |  Clear decimal mode

  REP #$30                                  ; $808004 |  16 bit A/X/Y
  LDX.W #$01AF                              ; $808006 |\ Set up the stack pointer
  TXS                                       ; $808009 |/

  REP #$30                                  ; $80800A |\
  PHB                                       ; $80800C | |
  LDA.W #$0000                              ; $80800D | |
  STA.L $000000                             ; $808010 | |
  LDA.W #$1FFD                              ; $808014 | | Clear $000000 - $001FFF
  LDX.W #$0001                              ; $808017 | |
  TXY                                       ; $80801A | |
  INY                                       ; $80801B | |
  MVN $00,$00                               ; $80801C | |
  PLB                                       ; $80801F |/

  REP #$30                                  ; $808020 |\
  PHB                                       ; $808022 | |
  LDA.W #$0000                              ; $808023 | |
  STA.L $7E2000                             ; $808026 | |
  LDA.W #$DFFC                              ; $80802A | | Clear $7E2000 - $7EFFFE
  LDX.W #$2001                              ; $80802D | |
  TXY                                       ; $808030 | |
  INY                                       ; $808031 | |
  MVN $7E,$7E                               ; $808032 | |
  PLB                                       ; $808035 |/

  REP #$30                                  ; $808036 |\
  PHB                                       ; $808038 | |
  LDA.W #$0000                              ; $808039 | |
  STA.L $7F0000                             ; $80803C | |
  LDA.W #$FFFC                              ; $808040 | | Clear $7F0000 - $7FFFFE
  LDX.W #$0001                              ; $808043 | |
  TXY                                       ; $808046 | |
  INY                                       ; $808047 | |
  MVN $7F,$7F                               ; $808048 | |
  PLB                                       ; $80804B |/

  LDA.W #$0000                              ; $80804C |\ Direct page 0
  TCD                                       ; $80804F |/

  PEA.W $8100                               ; $808050 |\
  PLB                                       ; $808053 | | Data bank $81
  PLB                                       ; $808054 |/

  SEP #$20                                  ; $808055 | 8 bit A
  LDA.W !reg_rdnmi                          ; $808057 | Clear NMI flag
  STZ.W !reg_nmitimen                       ; $80805A | Disable NMI
  LDA.B #$80                                ; $80805D |\ Apply forced blank (screen off)
  STA.W !reg_inidisp                        ; $80805F |/

  REP #$20                                  ; $808062 | 16 bit A
  JSL.L reset_io_registers                  ; $808064 |
  REP #$10                                  ; $808068 | 16 bit X/Y
  LDY.W #$7FFF                              ; $80806A |
  LDX.W #$0000                              ; $80806D |

  JSL.L CODE_FL_80BF4B                      ; $808070 |
  JSL.L clear_asset_ram                     ; $808074 |

  JSL.L verify_region                       ; $808078 |
  LDX.W #asset_sound_driver                 ; $80807C |
  JSL.L load_asset                          ; $80807F |

  SEI                                       ; $808083 |  Disable IRQ
  CLD                                       ; $808084 |  Clear decimal mode
  REP #$30                                  ; $808085 |  16 bit A/X/Y
  LDX.W #$01AF                              ; $808087 |\ Set up the stack pointer
  TXS                                       ; $80808A |/
  LDA.W #$0000                              ; $80808B |\ Direct page 0
  TCD                                       ; $80808E |/
  PEA.W $8100                               ; $80808F |\
  PLB                                       ; $808092 | | Data bank $81
  PLB                                       ; $808093 |/

  JSL.L CODE_FL_84C579                      ; $808094 |
  STZ.W $1FF4                               ; $808098 |
  JSL.L CODE_FL_84C5BB                      ; $80809B |
  JSL.L CODE_FL_808302                      ; $80809F |
  JSL.L reset_io_registers                  ; $8080A3 |
  JSL.L CODE_FL_808828                      ; $8080A7 |

  REP #$20                                  ; $8080AB |
  LDA.W #$7000                              ; $8080AD |
  STA.B $50                                 ; $8080B0 |
  LDA.W #$7400                              ; $8080B2 |
  STA.B $52                                 ; $8080B5 |
  LDA.W #$19D2                              ; $8080B7 |
  STA.W $19D0                               ; $8080BA |
  LDA.W #$2C00                              ; $8080BD |
  STA.B $4A                                 ; $8080C0 |
  STZ.W $1770                               ; $8080C2 |
  STZ.W $1778                               ; $8080C5 |
  STZ.W $177C                               ; $8080C8 |
  STZ.W $1784                               ; $8080CB |
  STZ.W $178C                               ; $8080CE |
  STZ.W $1790                               ; $8080D1 |
  STZ.W $1798                               ; $8080D4 |
  STZ.W $17A0                               ; $8080D7 |
  STZ.W $17A4                               ; $8080DA |
  STZ.W $17AC                               ; $8080DD |
  JSL.L CODE_FL_808230                      ; $8080E0 |

  CLI                                       ; $8080E4 |  Enable IRQ

.main_loop
  LDA.W #$0000                              ; $8080E5 |\ Direct page 0
  TCD                                       ; $8080E8 |/

  LDA.B !r_demo_flag                        ; $8080E9 |\ Skip RNG update in demo play
  BNE .after_random                         ; $8080EB |/

  LDA.B !r_rng                              ; $8080ED |\
  ADC.B $42                                 ; $8080EF | | Update RNG until next NMI
  STA.B !r_rng                              ; $8080F1 |/

.after_random
  BRA .main_loop                            ; $8080F3 |


vblank_handler:
  REP #$38                                  ; $8080F5 |
  PHA                                       ; $8080F7 |
  PHX                                       ; $8080F8 |
  PHY                                       ; $8080F9 |
  PHD                                       ; $8080FA |
  PHB                                       ; $8080FB |
  LDA.W #$0000                              ; $8080FC |
  TCD                                       ; $8080FF |

  SEP #$20                                  ; $808100 |
  LDA.B #$81                                ; $808102 |
  PHA                                       ; $808104 |
  PLB                                       ; $808105 |

CODE_JP_808106:
  REP #$20                                  ; $808106 |
  LDA.W !reg_rdnmi                          ; $808108 |
  LDA.W #$0001                              ; $80810B |
  LDY.B $44                                 ; $80810E |
  STA.B $44                                 ; $808110 |
  BEQ .CODE_80813E                          ; $808112 |
  JSR.W CODE_FN_80824B                      ; $808114 |
  JSR.W CODE_FN_8081A0                      ; $808117 |
  JSL.L CODE_FL_808344                      ; $80811A |
  LDA.W $1E36                               ; $80811E |
  BNE .CODE_80813B                          ; $808121 |
  LDA.L $001D9C                             ; $808123 |
  PHA                                       ; $808127 |
  LDA.L $001D9E                             ; $808128 |
  PHA                                       ; $80812C |
  JSL.L CODE_FL_84C7DD                      ; $80812D |
  PLA                                       ; $808131 |
  STA.L $001D9E                             ; $808132 |
  PLA                                       ; $808136 |
  STA.L $001D9C                             ; $808137 |

.CODE_80813B
  BRL .CODE_JL_808198                       ; $80813B |

.CODE_80813E
  SEP #$20                                  ; $80813E |
  STZ.W !reg_hdmaen                         ; $808140 |
  REP #$20                                  ; $808143 |
  JSR.W CODE_FN_80824B                      ; $808145 |
  JSR.W CODE_FN_8081CC                      ; $808148 |
  JSL.L CODE_FL_809493                      ; $80814B |
  JSL.L CODE_FL_809570                      ; $80814F |
  JSL.L CODE_FL_80936E                      ; $808153 |
  JSL.L CODE_FL_8092F6                      ; $808157 |
  JSR.W CODE_FN_8081A0                      ; $80815B |
  JSL.L CODE_FL_809784                      ; $80815E |
  JSR.W CODE_FN_8082C8                      ; $808162 |
  JSL.L CODE_FL_808344                      ; $808165 |
  JSL.L CODE_FL_848B6C                      ; $808169 |
  INC.W $1E36                               ; $80816D |
  JSL.L CODE_FL_84C7DD                      ; $808170 |
  JSL.L CODE_FL_808622                      ; $808174 |

  JSL.L CODE_FL_808458                      ; $808178 |
  STZ.W $1E36                               ; $80817C |
  JSL.L CODE_FL_80B0A2                      ; $80817F |
  JSL.L CODE_FL_80C316                      ; $808183 |
  JSL.L CODE_FL_8097D5                      ; $808187 |
  JSL.L CODE_FL_84BB83                      ; $80818B |
  INC.W $1E36                               ; $80818F |
  JSL.L handle_sound                        ; $808192 |
  STZ.B $44                                 ; $808196 |

.CODE_JL_808198
  REP #$30                                  ; $808198 |

  PLB                                       ; $80819A |
  PLD                                       ; $80819B |
  PLY                                       ; $80819C |
  PLX                                       ; $80819D |
  PLA                                       ; $80819E |
  RTI                                       ; $80819F |


CODE_FN_8081A0:
  SEP #$20                                  ; $8081A0 |

.CODE_8081A2
  BIT.W !reg_hvbjoy                         ; $8081A2 |
  BMI .CODE_8081B9                          ; $8081A5 |
  BIT.W !reg_slhv                           ; $8081A7 |
  BIT.W !reg_stat78                         ; $8081AA |
  BIT.W !reg_opvct                          ; $8081AD |
  BMI .CODE_8081A2                          ; $8081B0 |
  LDA.B #$01                                ; $8081B2 |
  BIT.W !reg_opvct                          ; $8081B4 |
  BNE .CODE_8081A2                          ; $8081B7 |

.CODE_8081B9
  LDA.W $1FA0                               ; $8081B9 |
  LDY.B $46                                 ; $8081BC |
  BEQ .CODE_8081C6                          ; $8081BE |
  DEC.B $46                                 ; $8081C0 |
  BEQ .CODE_8081C6                          ; $8081C2 |
  ORA.B #$80                                ; $8081C4 |

.CODE_8081C6
  STA.W !reg_inidisp                        ; $8081C6 |
  REP #$20                                  ; $8081C9 |
  RTS                                       ; $8081CB |


CODE_FN_8081CC:
  SEP #$10                                  ; $8081CC |
  LDY.B #$01                                ; $8081CE |
  LDA.B $48                                 ; $8081D0 |
  BPL .CODE_8081F7                          ; $8081D2 |
  AND.W #$7FFF                              ; $8081D4 |
  STA.B $48                                 ; $8081D7 |
  LDA.B $4A                                 ; $8081D9 |
  STA.W !reg_a1t0l                          ; $8081DB |
  LDA.W #$2200                              ; $8081DE |
  STA.W !reg_dmap0                          ; $8081E1 |
  LDX.B #$7E                                ; $8081E4 |
  STX.W !reg_a1b0                           ; $8081E6 |
  LDA.W #$0200                              ; $8081E9 |
  STA.W !reg_das0l                          ; $8081EC |
  LDX.B #$00                                ; $8081EF |
  STX.W !reg_cgadd                          ; $8081F1 |
  STY.W !reg_mdmaen                         ; $8081F4 |

.CODE_8081F7
  BIT.B $48                                 ; $8081F7 |
  BVS .CODE_80822D                          ; $8081F9 |
  STZ.W !reg_oamaddl                        ; $8081FB |
  LDA.W #$0410                              ; $8081FE |
  STA.W !reg_dmap0                          ; $808201 |
  LDA.W #$03DF                              ; $808204 |
  STA.W !reg_a1t0l                          ; $808207 |
  LDX.B #$00                                ; $80820A |
  STX.W !reg_a1b0                           ; $80820C |
  LDA.W #$0200                              ; $80820F |
  STA.W !reg_das0l                          ; $808212 |
  STY.W !reg_mdmaen                         ; $808215 |
  LDA.W #$0400                              ; $808218 |
  STA.W !reg_dmap0                          ; $80821B |
  LDA.W #$03E0                              ; $80821E |
  STA.W !reg_a1t0l                          ; $808221 |
  LDA.W #$0020                              ; $808224 |
  STA.W !reg_das0l                          ; $808227 |
  STY.W !reg_mdmaen                         ; $80822A |

.CODE_80822D
  REP #$10                                  ; $80822D |
  RTS                                       ; $80822F |


CODE_FL_808230:
  PHP                                       ; $808230 |
  SEP #$20                                  ; $808231 |
  LDA.W !reg_rdnmi                          ; $808233 |
  LDA.B #$0F                                ; $808236 |
  STA.W $1FA0                               ; $808238 |
  LDA.B #$81                                ; $80823B |
  STA.W $1FA2                               ; $80823D |
  STA.W !reg_nmitimen                       ; $808240 |
  LDA.B #$04                                ; $808243 |
  STA.B $46                                 ; $808245 |
  REP #$20                                  ; $808247 |
  PLP                                       ; $808249 |
  RTL                                       ; $80824A |


CODE_FN_80824B:
  LDA.W #$2100                              ; $80824B |
  TCD                                       ; $80824E |
  SEP #$20                                  ; $80824F |
  LDA.W $1FA6                               ; $808251 |
  STA.B !reg_obsel                          ; $808254 |
  LDA.W $1FAC                               ; $808256 |
  STA.B !reg_bg1sc                          ; $808259 |
  LDA.W $1FAE                               ; $80825B |
  STA.B !reg_bg2sc                          ; $80825E |
  LDX.W $1FF8                               ; $808260 |
  STX.B !reg_wh0                            ; $808263 |
  LDX.W $1FFA                               ; $808265 |
  STX.B !reg_wh2                            ; $808268 |
  LDA.W $1FBA                               ; $80826A |
  STA.B !reg_wbglog                         ; $80826D |
  LDA.W $1FBC                               ; $80826F |
  STA.B !reg_wobjlog                        ; $808272 |
  LDA.W $1FDC                               ; $808274 |
  STA.B !reg_cgwsel                         ; $808277 |
  LDA.W $1FC0                               ; $808279 |
  STA.B !reg_ts                             ; $80827C |
  LDA.W $1FE2                               ; $80827E |
  STA.B !reg_coldata                        ; $808281 |
  LDA.W $1FE4                               ; $808283 |
  STA.B !reg_coldata                        ; $808286 |
  LDA.W $1FE6                               ; $808288 |
  STA.B !reg_coldata                        ; $80828B |
  LDA.W $1FA4                               ; $80828D |
  STA.B !reg_bgmode                         ; $808290 |
  LDA.W $1FAA                               ; $808292 |
  STA.B !reg_mosaic                         ; $808295 |
  LDA.W $1FB0                               ; $808297 |
  STA.B !reg_bg3sc                          ; $80829A |
  LDA.W $1FDE                               ; $80829C |
  STA.B !reg_cgadsub                        ; $80829F |
  LDA.W $1FBE                               ; $8082A1 |
  STA.B !reg_tm                             ; $8082A4 |
  LDA.W $1FC2                               ; $8082A6 |
  STA.B !reg_tmw                            ; $8082A9 |
  LDA.W $1FC4                               ; $8082AB |
  STA.B !reg_tsw                            ; $8082AE |
  LDA.W $1FB4                               ; $8082B0 |
  STA.B !reg_w12sel                         ; $8082B3 |
  LDA.W $1FB6                               ; $8082B5 |
  STA.B !reg_w34sel                         ; $8082B8 |
  LDA.W $1FB8                               ; $8082BA |
  STA.B !reg_wobjsel                        ; $8082BD |
  BRA .CODE_8082C1                          ; $8082BF |


.CODE_8082C1
  REP #$20                                  ; $8082C1 |
  LDA.W #$0000                              ; $8082C3 |
  TCD                                       ; $8082C6 |
  RTS                                       ; $8082C7 |


CODE_FN_8082C8:
  LDY.W #$0000                              ; $8082C8 |
  LDX.W #$1660                              ; $8082CB |
  JSR.W CODE_FN_8082E9                      ; $8082CE |
  LDY.W #$0002                              ; $8082D1 |
  LDX.W #$1680                              ; $8082D4 |
  JSR.W CODE_FN_8082E9                      ; $8082D7 |
  LDY.W #$0004                              ; $8082DA |
  LDX.W #$16A0                              ; $8082DD |
  JSR.W CODE_FN_8082E9                      ; $8082E0 |
  LDY.W #$0006                              ; $8082E3 |
  LDX.W #$16C0                              ; $8082E6 |

CODE_FN_8082E9:
  LDA.B $12,X                               ; $8082E9 |
  DEC A                                     ; $8082EB |
  SEP #$20                                  ; $8082EC |
  STA.W !reg_bg1vofs,Y                      ; $8082EE |
  XBA                                       ; $8082F1 |
  STA.W !reg_bg1vofs,Y                      ; $8082F2 |
  LDA.B $02,X                               ; $8082F5 |
  STA.W !reg_bg1hofs,Y                      ; $8082F7 |
  LDA.B $03,X                               ; $8082FA |
  STA.W !reg_bg1hofs,Y                      ; $8082FC |
  REP #$20                                  ; $8082FF |
  RTS                                       ; $808301 |


CODE_FL_808302:
  PHP                                       ; $808302 |
  SEP #$20                                  ; $808303 |
  STZ.W !reg_hdmaen                         ; $808305 |
  STZ.W !reg_nmitimen                       ; $808308 |

CODE_80830B:
  LDA.B #$80                                ; $80830B |
  STA.W !reg_inidisp                        ; $80830D |
  STZ.W $0040                               ; $808310 |
  PLP                                       ; $808313 |
  RTL                                       ; $808314 |


CODE_FL_808315:
  PHP                                       ; $808315 |
  SEP #$20                                  ; $808316 |

  LDA.W !reg_rdnmi                          ; $808318 |
  LDA.B #$04                                ; $80831B |
  STA.W $0046                               ; $80831D |
  LDA.W $1FA2                               ; $808320 |
  STA.W !reg_nmitimen                       ; $808323 |
  JSL.L CODE_FL_808344                      ; $808326 |
  PLP                                       ; $80832A |
  RTL                                       ; $80832B |


CODE_FL_80832C:
  PHP                                       ; $80832C |
  SEP #$20                                  ; $80832D |
  LDA.W $1FA2                               ; $80832F |
  BMI CODE_808338                           ; $808332 |
  BIT.B #$30                                ; $808334 |
  BNE CODE_80830B                           ; $808336 |

CODE_808338:
  LDA.B #$80                                ; $808338 |
  STA.W $0044                               ; $80833A |

CODE_80833D:
  LDA.W $0044                               ; $80833D |
  BMI CODE_80833D                           ; $808340 |
  BRA CODE_80830B                           ; $808342 |


CODE_FL_808344:
  SEI                                       ; $808344 |
  LDA.W $00D2                               ; $808345 |
  STA.W $0040                               ; $808348 |
  BEQ .CODE_808377                          ; $80834B |
  SEP #$20                                  ; $80834D |
  LDA.W $1FA2                               ; $80834F |
  ORA.B #$30                                ; $808352 |
  AND.B #$7F                                ; $808354 |
  STA.W $1FA2                               ; $808356 |
  STA.W !reg_nmitimen                       ; $808359 |
  STZ.W $00D0                               ; $80835C |
  LDY.W $0040                               ; $80835F |
  LDA.W $8000,Y                             ; $808362 |
  STA.W !reg_vtimel                         ; $808365 |
  STZ.W !reg_vtimeh                         ; $808368 |
  LDA.B #$80                                ; $80836B |
  STA.W !reg_htimel                         ; $80836D |
  STZ.W !reg_htimeh                         ; $808370 |
  REP #$20                                  ; $808373 |

  CLI                                       ; $808375 |
  RTL                                       ; $808376 |


.CODE_808377
  STZ.B $D0                                 ; $808377 |
  RTL                                       ; $808379 |

.CODE_80837A_UNUSED
  STZ.B $D0                                 ; $80837A |
  STZ.B $D2                                 ; $80837C |
  STZ.B $D4                                 ; $80837E |
  STZ.B $D6                                 ; $808380 |
  SEP #$20                                  ; $808382 |
  LDA.W $1FA2                               ; $808384 |
  AND.B #$CF                                ; $808387 |
  STA.W $1FA2                               ; $808389 |
  STA.W !reg_nmitimen                       ; $80838C |
  REP #$20                                  ; $80838F |
  CLI                                       ; $808391 |
  RTL                                       ; $808392 |


irq_handler:
  REP #$30                                  ; $808393 |
  PHA                                       ; $808395 |
  PHX                                       ; $808396 |
  PHY                                       ; $808397 |
  PHD                                       ; $808398 |
  PHB                                       ; $808399 |
  LDA.W #$0000                              ; $80839A |
  TCD                                       ; $80839D |
  SEP #$20                                  ; $80839E |
  LDA.B #$81                                ; $8083A0 |\
  PHA                                       ; $8083A2 | | Data bank $81
  PLB                                       ; $8083A3 |/
  LDA.W !reg_timeup                         ; $8083A4 |
  BPL irq_return                            ; $8083A7 |
  LDY.B $40                                 ; $8083A9 |
  CPY.W #$0002                              ; $8083AB |
  BEQ irq_handler_2                         ; $8083AE |
  REP #$20                                  ; $8083B0 |
  INC.B $D0                                 ; $8083B2 |
  INC.B $D0                                 ; $8083B4 |
  LDX.B $D0                                 ; $8083B6 |
  LDA.B $D2,X                               ; $8083B8 |
  BEQ CODE_8083D0                           ; $8083BA |
  STA.B $40                                 ; $8083BC |
  TAX                                       ; $8083BE |
  LDA.W $8000,X                             ; $8083BF |
  STA.W !reg_vtimel                         ; $8083C2 |
  LDA.W #$00C0                              ; $8083C5 |
  STA.W !reg_htimel                         ; $8083C8 |

CODE_8083CB:
  LDA.W irq_handler_table,Y                 ; $8083CB |
  PHA                                       ; $8083CE |
  RTS                                       ; $8083CF |


CODE_8083D0:
  SEP #$20                                  ; $8083D0 |
  LDA.W $1FA2                               ; $8083D2 |
  AND.B #$CF                                ; $8083D5 |
  STA.W $1FA2                               ; $8083D7 |
  STA.W !reg_nmitimen                       ; $8083DA |
  REP #$20                                  ; $8083DD |
  BRA CODE_8083CB                           ; $8083DF |


irq_return:
  REP #$30                                  ; $8083E1 |
  PLB                                       ; $8083E3 |
  PLD                                       ; $8083E4 |
  PLY                                       ; $8083E5 |
  PLX                                       ; $8083E6 |
  PLA                                       ; $8083E7 |
  RTI                                       ; $8083E8 |


irq_handler_2:
  LDA.W $1FA2                               ; $8083E9 |
  AND.B #$7F                                ; $8083EC |
  STA.W !reg_nmitimen                       ; $8083EE |

CODE_8083F1:
  BIT.W !reg_hvbjoy                         ; $8083F1 |
  BVC CODE_8083F1                           ; $8083F4 |
  LDA.W $1FA0                               ; $8083F6 |
  ORA.B #$80                                ; $8083F9 |
  STA.W !reg_inidisp                        ; $8083FB |
  JMP.W CODE_JP_808106                      ; $8083FE |

empty_irq_handler:
  JMP.W irq_return                          ; $808401 |

verify_region:
  SEP #$20                                  ; $808404 |\  8 bit A
  LDA.W !reg_stat78                         ; $808406 | | Read PAL/NTSC flag from STAT78
  AND.B #$10                                ; $808409 |/
  CMP.L region_code                         ; $80840B |\  Return if the console region matches the ROM
  BEQ .ret                                  ; $80840F |/  (Otherwise, display an error screen and stop execution by the following code)

  STZ.W !reg_cgadd                          ; $808411 |  Select palette 0
  STZ.W !reg_cgdata                         ; $808414 |\  Set color 0 = black (0x0000)
  STZ.W !reg_cgdata                         ; $808417 |/
  LDA.B #$FF                                ; $80841A |\
  STA.W !reg_cgdata                         ; $80841C | | Set color 1 = black (0x7FFF)
  LDA.B #$7F                                ; $80841F | |
  STA.W !reg_cgdata                         ; $808421 |/

  REP #$20                                  ; $808424 |  16 bit A
  LDX.W #asset_system_font                  ; $808426 |\ Upload font to VRAM
  JSL.L load_asset                          ; $808429 |/

  SEP #$20                                  ; $80842D |  8 bit A
  LDA.B #$00                                ; $80842F |\ VRAM address increments after each write
  STA.W !reg_vmain                          ; $808431 |/
  LDY.W #region_error_msg-1                 ; $808434 |  Source pointer (first word is VRAM address)

.newline
  INY                                       ; $808437 |  Skip control byte ($FE)
  LDX.W $0000,Y                             ; $808438 |\ Read VRAM destination address (word)
  STX.W !reg_vmaddl                         ; $80843B |/ Set PPU regsiter
  INY                                       ; $80843E |

.char_loop
  INY                                       ; $80843F |\  Advance source pointer
  LDA.W $0000,Y                             ; $808440 | |
  CMP.B #$FE                                ; $808443 | |\ Control code handling
  BEQ .newline                              ; $808445 | | | $FE $xxxx => set VRAM address (newline)
  BCS .finish                               ; $808447 | |/  $FF => end of text
  STA.W !reg_vmdatal                        ; $808449 | | Write character to VRAM
  BRA .char_loop                            ; $80844C |/

.finish
  LDA.B #$0F                                ; $80844E |\ Enable display
  STA.W !reg_inidisp                        ; $808450 |/

.halt
  BRA .halt                                 ; $808453 |  Stop execution

.ret
  REP #$20                                  ; $808455 |
  RTL                                       ; $808457 |


CODE_FL_808458:
  REP #$30                                  ; $808458 |
  INC.B $42                                 ; $80845A |
  LDA.B $3A                                 ; $80845C |
  ORA.B $3C                                 ; $80845E |
  BEQ CODE_80846D                           ; $808460 |
  LDA.B $3A                                 ; $808462 |
  CMP.W #$0004                              ; $808464 |
  BCS CODE_80846D                           ; $808467 |
  JSL.L CODE_FL_80865A                      ; $808469 |

CODE_80846D:
  LDA.B $3A                                 ; $80846D |
  PHX                                       ; $80846F |
  ASL A                                     ; $808470 |
  TAX                                       ; $808471 |
  LDA.L PTR16_80847C,X                      ; $808472 |
  PLX                                       ; $808476 |
  STA.B $00                                 ; $808477 |
  JMP.W ($0000)                             ; $808479 |

PTR16_80847C:
  dw CODE_808494                            ; $80847C |
  dw CODE_8084C8                            ; $80847E |
  dw CODE_8084E3                            ; $808480 |
  dw CODE_80850E                            ; $808482 |
  dw CODE_808535                            ; $808484 |
  dw CODE_808575                            ; $808486 |
  dw CODE_80EDE6                            ; $808488 |
  dw CODE_808579                            ; $80848A |
  dw CODE_808595                            ; $80848C |
  dw CODE_8085B7                            ; $80848E |
  dw CODE_8085C1                            ; $808490 |
  dw CODE_8085C9                            ; $808492 |

CODE_808494:
  LDX.B $3C                                 ; $808494 |
  BNE CODE_8084BD                           ; $808496 |
  JSL.L CODE_FL_808D45                      ; $808498 |
  STZ.B $70                                 ; $80849C |
  STZ.B $72                                 ; $80849E |
  JSL.L CODE_FL_808BC2                      ; $8084A0 |
  SEP #$20                                  ; $8084A4 |
  LDA.B #$22                                ; $8084A6 |
  STA.W !reg_bg12nba                        ; $8084A8 |
  LDA.B #$44                                ; $8084AB |
  STA.W !reg_bg34nba                        ; $8084AD |
  REP #$20                                  ; $8084B0 |
  JSL.L CODE_FL_808808                      ; $8084B2 |
  JSL.L CODE_FL_84BACC                      ; $8084B6 |
  INC.B $3C                                 ; $8084BA |

CODE_8084BC:
  RTL                                       ; $8084BC |


CODE_8084BD:
  JSL.L CODE_FL_80C01E                      ; $8084BD |
  LDA.B $72                                 ; $8084C1 |
  BEQ CODE_8084BC                           ; $8084C3 |
  BRL CODE_FL_8085DA                        ; $8084C5 |


CODE_8084C8:
  JSR.W CODE_FN_808606                      ; $8084C8 |
  LDX.B $3C                                 ; $8084CB |
  BNE CODE_8084D6                           ; $8084CD |
  JSL.L CODE_FL_84CBE7                      ; $8084CF |

  INC.B $3C                                 ; $8084D3 |

  RTL                                       ; $8084D5 |


CODE_8084D6:
  JSL.L CODE_FL_84CC9B                      ; $8084D6 |
  LDA.B $3E                                 ; $8084DA |
  BEQ CODE_8084E2                           ; $8084DC |
  JSL.L CODE_FL_8085E2                      ; $8084DE |

CODE_8084E2:
  RTL                                       ; $8084E2 |


CODE_8084E3:
  STZ.B $78                                 ; $8084E3 |
  STZ.B $38                                 ; $8084E5 |
  JSR.W CODE_FN_808606                      ; $8084E7 |
  LDX.B $3C                                 ; $8084EA |
  BNE CODE_8084F7                           ; $8084EC |
  JSL.L CODE_FL_8086E9                      ; $8084EE |
  STZ.B $5A                                 ; $8084F2 |
  INC.B $3C                                 ; $8084F4 |
  RTL                                       ; $8084F6 |


CODE_8084F7:
  JSL.L CODE_FL_84CF24                      ; $8084F7 |
  JSL.L CODE_FL_8085FF                      ; $8084FB |
  BEQ CODE_808502                           ; $8084FF |

CODE_808501:
  RTL                                       ; $808501 |


CODE_808502:
  JSL.L CODE_FL_8085DA                      ; $808502 |
  LDA.W #$00EB                              ; $808506 |
  JSL.L push_sound_queue                    ; $808509 |
  RTL                                       ; $80850D |


CODE_80850E:
  LDX.B $3C                                 ; $80850E |
  BNE CODE_808518                           ; $808510 |
  INC.B $3C                                 ; $808512 |
  JML.L CODE_JL_80C896                      ; $808514 |


CODE_808518:
  JSL.L CODE_FL_80C79F                      ; $808518 |
  LDA.B $3E                                 ; $80851C |
  BEQ CODE_808501                           ; $80851E |
  JSL.L CODE_FL_808613                      ; $808520 |
  JSR.W CODE_FN_808606                      ; $808524 |
  LDA.W #$0000                              ; $808527 |
  LDY.B $4E                                 ; $80852A |
  BEQ CODE_808531                           ; $80852C |
  LDA.W #$0001                              ; $80852E |

CODE_808531:
  JML.L CODE_FL_8085EC                      ; $808531 |


CODE_808535:
  LDX.B $3C                                 ; $808535 |
  BNE CODE_808541                           ; $808537 |
  STZ.B !r_demo_flag                        ; $808539 |

CODE_80853B:
  LDX.W #$0050                              ; $80853B |
  BRL CODE_JL_8085D0                        ; $80853E |


CODE_808541:
  DEX                                       ; $808541 |
  BNE CODE_808555                           ; $808542 |
  LDA.W #$0003                              ; $808544 |
  STA.B $38                                 ; $808547 |
  JSL.L CODE_FL_8085FF                      ; $808549 |
  BNE CODE_808560                           ; $80854D |
  JSL.L CODE_FL_80C213                      ; $80854F |
  BRA CODE_80853B                           ; $808553 |


CODE_808555:
  LDA.W $1F30                               ; $808555 |
  BNE CODE_808560                           ; $808558 |
  JSR.W CODE_FN_80860C                      ; $80855A |
  BRL CODE_FL_8085DA                        ; $80855D |


CODE_808560:
  LDA.B $74                                 ; $808560 |
  AND.W #$0004                              ; $808562 |
  STA.B $88                                 ; $808565 |
  LDA.B $5A                                 ; $808567 |
  AND.W #$0001                              ; $808569 |
  ASL A                                     ; $80856C |
  TAY                                       ; $80856D |
  LDX.W $8063,Y                             ; $80856E |
  JML.L CODE_FL_80BF9A                      ; $808571 |


CODE_808575:
  JML.L CODE_JL_A0F9E0                      ; $808575 |


CODE_808579:
  LDA.L $700768                             ; $808579 |
  BNE CODE_808592                           ; $80857D |
  LDA.B $3C                                 ; $80857F |
  DEC A                                     ; $808581 |
  BEQ CODE_80858B                           ; $808582 |
  JSL.L CODE_FL_84CFF0                      ; $808584 |
  INC.B $3C                                 ; $808588 |
  RTL                                       ; $80858A |


CODE_80858B:
  JSL.L CODE_FL_84CFFA                      ; $80858B |
  BCS CODE_808592                           ; $80858F |
  RTL                                       ; $808591 |


CODE_808592:
  BRL CODE_FL_8085DA                        ; $808592 |


CODE_808595:
  LDA.W #$0003                              ; $808595 |
  STA.B $38                                 ; $808598 |
  JSL.L CODE_FL_96FD00                      ; $80859A |
  JSL.L CODE_FL_96FB5D                      ; $80859E |
  JSL.L CODE_FL_838000                      ; $8085A2 |
  JSL.L CODE_FL_808CB3                      ; $8085A6 |
  JSL.L CODE_FL_A0F9E7                      ; $8085AA |
  BRA CODE_8085B0                           ; $8085AE |


CODE_8085B0:
  STZ.B $7E                                 ; $8085B0 |
  STZ.B $80                                 ; $8085B2 |
  BRL CODE_FL_8085DA                        ; $8085B4 |


CODE_8085B7:
  LDA.W #$0003                              ; $8085B7 |
  STA.B $38                                 ; $8085BA |
  JSL.L CODE_FL_80C7A7                      ; $8085BC |
  RTL                                       ; $8085C0 |


CODE_8085C1:
  LDA.W #$0002                              ; $8085C1 |

  JSL.L CODE_FL_8085EC                      ; $8085C4 |
  RTL                                       ; $8085C8 |


CODE_8085C9:
  JML.L CODE_JL_8497E7                      ; $8085C9 |

  LDX.W #$0080                              ; $8085CD |

CODE_JL_8085D0:
  STX.B $74                                 ; $8085D0 |
  INC.B $3C                                 ; $8085D2 |
  RTL                                       ; $8085D4 |

  LDX.W #$0080                              ; $8085D5 |
  STX.B $74                                 ; $8085D8 |

CODE_FL_8085DA:
  JSL.L CODE_FL_80977D                      ; $8085DA |
  JSL.L CODE_FL_808D75                      ; $8085DE |

CODE_FL_8085E2:
  INC.B $3A                                 ; $8085E2 |

CODE_8085E4:
  LDA.W #$0000                              ; $8085E4 |
  STA.B $3E                                 ; $8085E7 |
  STA.B $3C                                 ; $8085E9 |
  RTL                                       ; $8085EB |


CODE_FL_8085EC:
  PHA                                       ; $8085EC |
  JSL.L CODE_FL_80977D                      ; $8085ED |
  JSL.L CODE_FL_808D75                      ; $8085F1 |
  PLA                                       ; $8085F5 |

CODE_FL_8085F6:
  STA.B $3A                                 ; $8085F6 |
  LDX.W #$0050                              ; $8085F8 |
  STX.B $74                                 ; $8085FB |
  BNE CODE_8085E4                           ; $8085FD |

CODE_FL_8085FF:
  LDA.B $74                                 ; $8085FF |
  BEQ CODE_808605                           ; $808601 |
  DEC.B $74                                 ; $808603 |

CODE_808605:
  RTL                                       ; $808605 |


CODE_FN_808606:
  LDA.W #$0001                              ; $808606 |
  STA.B !r_demo_flag                        ; $808609 |
  RTS                                       ; $80860B |


CODE_FN_80860C:
  JSL.L CODE_FL_808613                      ; $80860C |
  STZ.B !r_demo_flag                        ; $808610 |
  RTS                                       ; $808612 |


CODE_FL_808613:
  STZ.B $78                                 ; $808613 |
  JSL.L CODE_FL_808302                      ; $808615 |
  JSL.L CODE_FL_808898                      ; $808619 |
  JSL.L CODE_FL_808230                      ; $80861D |
  RTL                                       ; $808621 |


CODE_FL_808622:
  REP #$10                                  ; $808622 |
  SEP #$20                                  ; $808624 |

CODE_808626:
  LDA.W !reg_hvbjoy                         ; $808626 |
  LSR A                                     ; $808629 |
  BCS CODE_808626                           ; $80862A |
  REP #$20                                  ; $80862C |
  LDX.W #$0006                              ; $80862E |

CODE_808631:
  LDA.B $28,X                               ; $808631 |
  EOR.W #$FFFF                              ; $808633 |
  LDY.W !reg_joy1l,X                        ; $808636 |
  STY.B $28,X                               ; $808639 |
  AND.B $28,X                               ; $80863B |
  STA.B $30,X                               ; $80863D |
  TYA                                       ; $80863F |
  AND.W #$000F                              ; $808640 |
  BEQ CODE_808649                           ; $808643 |
  STZ.B $28,X                               ; $808645 |
  STZ.B $30,X                               ; $808647 |

CODE_808649:
  DEX                                       ; $808649 |
  DEX                                       ; $80864A |
  BPL CODE_808631                           ; $80864B |
  LDA.B $28                                 ; $80864D |
  ORA.B $2A                                 ; $80864F |
  STA.B $2E                                 ; $808651 |
  LDA.B $30                                 ; $808653 |
  ORA.B $32                                 ; $808655 |
  STA.B $36                                 ; $808657 |
  RTL                                       ; $808659 |


CODE_FL_80865A:
  REP #$30                                  ; $80865A |
  LDX.W #$0000                              ; $80865C |
  JSL.L CODE_FL_808666                      ; $80865F |
  LDX.W #$0002                              ; $808663 |

CODE_FL_808666:
  LDA.B $30,X                               ; $808666 |
  LDY.B $3A                                 ; $808668 |
  CPY.W #$0001                              ; $80866A |
  BEQ CODE_8086D8                           ; $80866D |
  CPY.W #$0003                              ; $80866F |
  BEQ CODE_8086D8                           ; $808672 |
  CPY.W #$0002                              ; $808674 |
  BEQ CODE_80867E                           ; $808677 |
  BIT.W #$1000                              ; $808679 |
  BNE CODE_8086D9                           ; $80867C |

CODE_80867E:
  BIT.W #$1000                              ; $80867E |
  BNE CODE_8086EF                           ; $808681 |
  BIT.W #$EFC0                              ; $808683 |
  BEQ CODE_8086D8                           ; $808686 |
  LDY.W $1C0A                               ; $808688 |
  BEQ CODE_8086D8                           ; $80868B |
  LDY.W $1C12                               ; $80868D |
  BNE CODE_8086D8                           ; $808690 |
  BIT.W #$2100                              ; $808692 |
  BEQ CODE_8086AF                           ; $808695 |
  LDA.B $5A                                 ; $808697 |
  INC A                                     ; $808699 |
  CMP.W #$0003                              ; $80869A |
  BNE CODE_8086A0                           ; $80869D |
  TDC                                       ; $80869F |

CODE_8086A0:
  STA.B $5A                                 ; $8086A0 |
  CMP.W #$0001                              ; $8086A2 |
  BEQ CODE_8086C6                           ; $8086A5 |
  LDA.W #$0008                              ; $8086A7 |
  STA.W $1C12                               ; $8086AA |
  BRA CODE_8086C6                           ; $8086AD |


CODE_8086AF:
  BIT.W #$0200                              ; $8086AF |
  BEQ CODE_8086D8                           ; $8086B2 |
  LDA.B $5A                                 ; $8086B4 |
  DEC A                                     ; $8086B6 |
  BPL CODE_8086BC                           ; $8086B7 |
  LDA.W #$0002                              ; $8086B9 |

CODE_8086BC:
  STA.B $5A                                 ; $8086BC |
  BEQ CODE_8086C6                           ; $8086BE |
  LDA.W #$FFF8                              ; $8086C0 |
  STA.W $1C12                               ; $8086C3 |

CODE_8086C6:
  LDA.W #$0002                              ; $8086C6 |
  CMP.B $3A                                 ; $8086C9 |
  BNE CODE_8086D4                           ; $8086CB |
  LDA.W #$0046                              ; $8086CD |

  JSL.L push_sound_queue                    ; $8086D0 |

CODE_8086D4:
  JSL.L CODE_FL_8086E9                      ; $8086D4 |

CODE_8086D8:
  RTL                                       ; $8086D8 |


CODE_8086D9:
  LDA.W #$00EB                              ; $8086D9 |
  JSL.L push_sound_queue                    ; $8086DC |
  LDA.W #$0001                              ; $8086E0 |
  JSL.L CODE_FL_8085EC                      ; $8086E3 |
  BRA CODE_FL_8086E9                        ; $8086E7 |


CODE_FL_8086E9:
  LDA.W #$0200                              ; $8086E9 |
  STA.B $74                                 ; $8086EC |
  RTL                                       ; $8086EE |


CODE_8086EF:
  LDA.B $5A                                 ; $8086EF |
  CMP.W #$0002                              ; $8086F1 |
  BEQ CODE_8086D8                           ; $8086F4 |
  LDA.W $1C12                               ; $8086F6 |
  BNE CODE_8086D8                           ; $8086F9 |
  LDA.W #$00EC                              ; $8086FB |
  JSL.L push_sound_queue                    ; $8086FE |
  LDA.W #$004C                              ; $808702 |
  JSL.L CODE_FL_8089BD                      ; $808705 |
  LDA.W #$0004                              ; $808709 |
  JML.L CODE_FL_8085F6                      ; $80870C |


reset_io_registers:
  JSL.L CODE_FL_808D45                      ; $808710 |
  SEP #$10                                  ; $808714 |
  LDA.W #$2100                              ; $808716 |
  TCD                                       ; $808719 |
  LDX.B #$00                                ; $80871A |
  LDY.B #$8F                                ; $80871C |
  STY.B !reg_inidisp                        ; $80871E |
  LDY.B #$03                                ; $808720 |
  STY.W $1FA6                               ; $808722 |
  STY.B !reg_obsel                          ; $808725 |
  STX.B !reg_oamaddl                        ; $808727 |
  STX.B !reg_oamadd                         ; $808729 |
  LDY.B #$09                                ; $80872B |
  STY.B !reg_bgmode                         ; $80872D |
  STX.W $1FAA                               ; $80872F |
  STX.B !reg_mosaic                         ; $808732 |
  LDY.B #$03                                ; $808734 |
  STY.W $1FAC                               ; $808736 |
  STY.B !reg_bg1sc                          ; $808739 |
  LDY.B #$13                                ; $80873B |
  STY.W $1FAE                               ; $80873D |

  STY.B !reg_bg2sc                          ; $808740 |
  LDY.B #$52                                ; $808742 |

  STY.W $1FB0                               ; $808744 |
  STY.B !reg_bg3sc                          ; $808747 |
  LDY.B #$54                                ; $808749 |
  STY.W $1FB2                               ; $80874B |
  STY.B !reg_bg4sc                          ; $80874E |
  LDY.B #$22                                ; $808750 |
  STY.B !reg_bg12nba                        ; $808752 |
  LDY.B #$44                                ; $808754 |
  STY.B !reg_bg34nba                        ; $808756 |
  STX.B !reg_bg1hofs                        ; $808758 |
  STX.B !reg_bg1hofs                        ; $80875A |
  STX.B !reg_bg1vofs                        ; $80875C |
  STX.B !reg_bg1vofs                        ; $80875E |
  STX.B !reg_bg2hofs                        ; $808760 |
  STX.B !reg_bg2hofs                        ; $808762 |
  STX.B !reg_bg2vofs                        ; $808764 |
  STX.B !reg_bg2vofs                        ; $808766 |
  STX.B !reg_bg3hofs                        ; $808768 |
  STX.B !reg_bg3hofs                        ; $80876A |
  STX.B !reg_bg3vofs                        ; $80876C |
  STX.B !reg_bg3vofs                        ; $80876E |
  STX.B !reg_bg4hofs                        ; $808770 |
  STX.B !reg_bg4hofs                        ; $808772 |
  STX.B !reg_bg4vofs                        ; $808774 |
  STX.B !reg_bg4vofs                        ; $808776 |
  LDY.B #$80                                ; $808778 |
  STY.B !reg_vmain                          ; $80877A |
  STX.B !reg_vmaddl                         ; $80877C |
  STX.B !reg_vmaddh                         ; $80877E |
  LDY.B #$80                                ; $808780 |
  STY.B !reg_m7sel                          ; $808782 |

  STX.B !reg_m7a                            ; $808784 |

  LDY.B #$01                                ; $808786 |
  STY.B !reg_m7a                            ; $808788 |
  STX.B !reg_m7b                            ; $80878A |
  STX.B !reg_m7b                            ; $80878C |
  STX.B !reg_m7c                            ; $80878E |
  STX.B !reg_m7c                            ; $808790 |
  STX.B !reg_m7d                            ; $808792 |
  LDY.B #$01                                ; $808794 |
  STY.B !reg_m7d                            ; $808796 |
  STX.B !reg_m7x                            ; $808798 |
  STX.B !reg_m7x                            ; $80879A |
  STX.B !reg_m7y                            ; $80879C |
  STX.B !reg_m7y                            ; $80879E |
  STX.B !reg_cgadd                          ; $8087A0 |
  STX.B !reg_w12sel                         ; $8087A2 |
  STX.B !reg_w34sel                         ; $8087A4 |
  STX.B !reg_wobjsel                        ; $8087A6 |
  STX.B !reg_wh0                            ; $8087A8 |
  STX.B !reg_wh1                            ; $8087AA |
  STX.B !reg_wh2                            ; $8087AC |
  STX.B !reg_wh3                            ; $8087AE |
  STX.B !reg_wbglog                         ; $8087B0 |
  STX.B !reg_wobjlog                        ; $8087B2 |
  LDY.B #$17                                ; $8087B4 |
  STY.W $1FBE                               ; $8087B6 |
  STY.B !reg_tm                             ; $8087B9 |
  STY.W $1FC0                               ; $8087BB |
  STY.B !reg_ts                             ; $8087BE |
  STX.W $1FC2                               ; $8087C0 |
  STX.B !reg_tmw                            ; $8087C3 |
  STX.W $1FC4                               ; $8087C5 |
  STX.B !reg_tsw                            ; $8087C8 |
  STX.W $1FDC                               ; $8087CA |
  STX.B !reg_cgwsel                         ; $8087CD |
  STX.W $1FDE                               ; $8087CF |
  STX.B !reg_cgadsub                        ; $8087D2 |
  LDY.B #$E0                                ; $8087D4 |
  STY.B !reg_coldata                        ; $8087D6 |

  STX.B !reg_setini                         ; $8087D8 |

  LDA.W #!reg_nmitimen                      ; $8087DA |
  TCD                                       ; $8087DD |

  STX.B !reg_nmitimen                       ; $8087DE |
  LDY.B #$FF                                ; $8087E0 |
  STY.B !reg_wrio                           ; $8087E2 |
  STX.B !reg_wrmpya                         ; $8087E4 |
  STX.B !reg_wrmpyb                         ; $8087E6 |
  STX.B !reg_wrdivl                         ; $8087E8 |
  STX.B !reg_wrdivh                         ; $8087EA |
  STX.B !reg_wrdivb                         ; $8087EC |
  LDY.B #$01                                ; $8087EE |
  STY.B !reg_htimel                         ; $8087F0 |
  STX.B !reg_htimeh                         ; $8087F2 |
  STX.B !reg_vtimel                         ; $8087F4 |
  STX.B !reg_vtimeh                         ; $8087F6 |
  STX.B !reg_mdmaen                         ; $8087F8 |
  STX.B !reg_hdmaen                         ; $8087FA |
  STZ.W $1FF2                               ; $8087FC |
  STY.B !reg_memsel                         ; $8087FF |

  LDA.W #$0000                              ; $808801 |
  TCD                                       ; $808804 |
  REP #$10                                  ; $808805 |
  RTL                                       ; $808807 |


CODE_FL_808808:
  JSL.L CODE_FL_808823                      ; $808808 |
  REP #$30                                  ; $80880C |
  PHB                                       ; $80880E |
  LDA.W #$0000                              ; $80880F |
  STA.L $001F30                             ; $808812 |
  LDA.W #$004D                              ; $808816 |
  LDX.W #$1F31                              ; $808819 |
  TXY                                       ; $80881C |
  INY                                       ; $80881D |
  MVN $00,$00                               ; $80881E |
  PLB                                       ; $808821 |
  RTL                                       ; $808822 |


CODE_FL_808823:
  JSL.L CODE_FL_84BAE2                      ; $808823 |
  RTL                                       ; $808827 |


CODE_FL_808828:
  REP #$30                                  ; $808828 |
  PHB                                       ; $80882A |
  LDA.W #$0000                              ; $80882B |
  STA.L $000000                             ; $80882E |
  LDA.W #$0135                              ; $808832 |
  LDX.W #$0001                              ; $808835 |

  TXY                                       ; $808838 |
  INY                                       ; $808839 |
  MVN $00,$00                               ; $80883A |
  PLB                                       ; $80883D |
  RTL                                       ; $80883E |


CODE_FL_80883F:
  REP #$30                                  ; $80883F |
  PHB                                       ; $808841 |
  LDA.W #$0000                              ; $808842 |
  STA.L $000400                             ; $808845 |
  LDA.W #$125D                              ; $808849 |
  LDX.W #$0401                              ; $80884C |
  TXY                                       ; $80884F |
  INY                                       ; $808850 |
  MVN $00,$00                               ; $808851 |

  PLB                                       ; $808854 |
  JSL.L CODE_FL_808ED2                      ; $808855 |
  LDA.W #$04C0                              ; $808859 |
  STA.W $0416                               ; $80885C |
  LDA.W #$0580                              ; $80885F |

  STA.W $04D6                               ; $808862 |

CODE_808865:
  REP #$30                                  ; $808865 |
  PHB                                       ; $808867 |

  LDA.W #$0000                              ; $808868 |
  STA.L $0001B0                             ; $80886B |
  LDA.W #$024D                              ; $80886F |
  LDX.W #$01B1                              ; $808872 |
  TXY                                       ; $808875 |

  INY                                       ; $808876 |
  MVN $00,$00                               ; $808877 |

  PLB                                       ; $80887A |
  RTL                                       ; $80887B |


CODE_FL_80887C:
  REP #$30                                  ; $80887C |

  PHB                                       ; $80887E |
  LDA.W #$0000                              ; $80887F |
  STA.L $000580                             ; $808882 |
  LDA.W #$10DD                              ; $808886 |
  LDX.W #$0581                              ; $808889 |
  TXY                                       ; $80888C |
  INY                                       ; $80888D |
  MVN $00,$00                               ; $80888E |
  PLB                                       ; $808891 |
  JSL.L CODE_FL_808ED2                      ; $808892 |
  BRA CODE_808865                           ; $808896 |


CODE_FL_808898:
  REP #$30                                  ; $808898 |
  PHB                                       ; $80889A |
  LDA.W #$0000                              ; $80889B |
  STA.L $000070                             ; $80889E |
  LDA.W #$008D                              ; $8088A2 |
  LDX.W #$0071                              ; $8088A5 |
  TXY                                       ; $8088A8 |
  INY                                       ; $8088A9 |
  MVN $00,$00                               ; $8088AA |
  PLB                                       ; $8088AD |
  RTL                                       ; $8088AE |


CODE_FL_8088AF:
  REP #$30                                  ; $8088AF |
  PHB                                       ; $8088B1 |
  LDA.W #$0000                              ; $8088B2 |
  STA.L $00007E                             ; $8088B5 |
  LDA.W #$007F                              ; $8088B9 |
  LDX.W #$007F                              ; $8088BC |
  TXY                                       ; $8088BF |
  INY                                       ; $8088C0 |
  MVN $00,$00                               ; $8088C1 |
  PLB                                       ; $8088C4 |
  RTL                                       ; $8088C5 |

  REP #$30                                  ; $8088C6 |
  PHB                                       ; $8088C8 |
  LDA.W #$0000                              ; $8088C9 |
  STA.L $7F8E00                             ; $8088CC |
  LDA.W #$00FD                              ; $8088D0 |
  LDX.W #$8E01                              ; $8088D3 |
  TXY                                       ; $8088D6 |
  INY                                       ; $8088D7 |

  MVN $7F,$7F                               ; $8088D8 |
  PLB                                       ; $8088DB |

  REP #$30                                  ; $8088DC |

  PHB                                       ; $8088DE |
  LDA.W #$0000                              ; $8088DF |

  STA.L $7FDE00                             ; $8088E2 |
  LDA.W #$00FD                              ; $8088E6 |
  LDX.W #$DE01                              ; $8088E9 |
  TXY                                       ; $8088EC |
  INY                                       ; $8088ED |
  MVN $7F,$7F                               ; $8088EE |
  PLB                                       ; $8088F1 |

  RTL                                       ; $8088F2 |

  REP #$30                                  ; $8088F3 |
  PHB                                       ; $8088F5 |

  LDA.W #$0000                              ; $8088F6 |
  STA.L $7E2C00                             ; $8088F9 |
  LDA.W #$03FD                              ; $8088FD |

  LDX.W #$2C01                              ; $808900 |
  TXY                                       ; $808903 |
  INY                                       ; $808904 |
  MVN $7E,$7E                               ; $808905 |
  PLB                                       ; $808908 |
  RTL                                       ; $808909 |

  REP #$30                                  ; $80890A |
  PHB                                       ; $80890C |
  LDA.W #$0000                              ; $80890D |
  STA.L $7F8000                             ; $808910 |
  LDA.W #$7FFD                              ; $808914 |
  LDX.W #$8001                              ; $808917 |
  TXY                                       ; $80891A |
  INY                                       ; $80891B |
  MVN $7F,$7F                               ; $80891C |
  PLB                                       ; $80891F |
  RTL                                       ; $808920 |


CODE_FL_808921:
  REP #$30                                  ; $808921 |
  PHB                                       ; $808923 |
  LDA.W #$0000                              ; $808924 |
  STA.L $7E8000                             ; $808927 |
  LDA.W #$03FD                              ; $80892B |
  LDX.W #$8001                              ; $80892E |
  TXY                                       ; $808931 |
  INY                                       ; $808932 |
  MVN $7E,$7E                               ; $808933 |
  PLB                                       ; $808936 |
  RTL                                       ; $808937 |


CODE_FL_808938:
  LDA.W #$00EB                              ; $808938 |
  JML.L push_sound_queue                    ; $80893B |


CODE_FL_80893F:
  LDA.W #$00EC                              ; $80893F |
  JML.L push_sound_queue                    ; $808942 |


CODE_FL_808946:
  LDA.W #$00ED                              ; $808946 |
  JML.L push_sound_queue                    ; $808949 |

  STZ.W $1E32                               ; $80894D |

; Y = music index (must be multiple of 4)
set_music:
  CPY.W #$00FE                              ; $808950 |\ ???
  BEQ .ret                                  ; $808953 |/
  TYA                                       ; $808955 |\
  AND.W #$FFFE                              ; $808956 | |
  STA.B $EE                                 ; $808959 | |
  TAY                                       ; $80895B |/
  BRA .process_music_entry                  ; $80895C |

.unreachable
  TYA                                       ; $80895E |
  AND.W #$FFFE                              ; $80895F |
  TAY                                       ; $808962 |

.process_music_entry
  PHX                                       ; $808963 |\
  PHB                                       ; $808964 | |
  PEA.W $8181                               ; $808965 | | Data bank $81
  PLB                                       ; $808968 | |
  PLB                                       ; $808969 |/
  LDA.W music_table-4,Y                     ; $80896A |\
  BEQ .skip_instrument_load                 ; $80896D | |
  PHY                                       ; $80896F | |
  JSL.L CODE_FL_84C604                      ; $808970 | | ???
  PLY                                       ; $808974 |/

.skip_instrument_load
  LDA.W music_table-2,Y                     ; $808975 |\  Read param2 from table
  PHA                                       ; $808978 | |
  JSL.L CODE_FL_84C5C9                      ; $808979 |/  ???
  PLY                                       ; $80897D |
  PEA.W $8888                               ; $80897E |\
  PLB                                       ; $808981 | | Data bank $88
  PLB                                       ; $808982 |/
  LDA.W seq_table,Y                         ; $808983 |\  Read ??? from table
  AND.W #$00FF                              ; $808986 | |
  JSL.L push_sound_queue                    ; $808989 |/  Play music track
  PLB                                       ; $80898D |
  PLX                                       ; $80898E |

.ret
  RTL                                       ; $80898F |


CODE_FL_808990:
  STZ.W $1E32                               ; $808990 |

CODE_FL_808993:
  TYA                                       ; $808993 |
  AND.W #$FFFE                              ; $808994 |
  STA.B $EE                                 ; $808997 |
  TAY                                       ; $808999 |

  BRA CODE_8089A1                           ; $80899A |


  TYA                                       ; $80899C |
  AND.W #$FFFE                              ; $80899D |
  TAY                                       ; $8089A0 |

CODE_8089A1:
  PHX                                       ; $8089A1 |
  PHB                                       ; $8089A2 |
  PEA.W $8181                               ; $8089A3 |\
  PLB                                       ; $8089A6 | | Data bank $81
  PLB                                       ; $8089A7 |/

  LDA.W music_table-4,Y                     ; $8089A8 |
  BEQ CODE_8089B3                           ; $8089AB |
  PHY                                       ; $8089AD |
  JSL.L CODE_FL_84C604                      ; $8089AE |
  PLY                                       ; $8089B2 |

CODE_8089B3:
  LDA.W music_table-2,Y                     ; $8089B3 |
  JSL.L CODE_FL_84C6D5                      ; $8089B6 |
  PLB                                       ; $8089BA |
  PLX                                       ; $8089BB |
  RTL                                       ; $8089BC |


CODE_FL_8089BD:
  PHX                                       ; $8089BD |
  PHB                                       ; $8089BE |
  PEA.W $8100                               ; $8089BF |\
  PLB                                       ; $8089C2 | | Data bank $81
  PLB                                       ; $8089C3 |/
  JSL.L CODE_FL_84C64E                      ; $8089C4 |
  PLB                                       ; $8089C8 |
  PLX                                       ; $8089C9 |
  RTL                                       ; $8089CA |

  LDA.B $A2                                 ; $8089CB |
  ORA.W #$8000                              ; $8089CD |
  STA.B $A2                                 ; $8089D0 |
  RTL                                       ; $8089D2 |

  LDA.B $A2                                 ; $8089D3 |
  AND.W #$7FFF                              ; $8089D5 |
  STA.B $A2                                 ; $8089D8 |
  RTL                                       ; $8089DA |


CODE_FL_8089DB:
  LDA.W #$0099                              ; $8089DB |
  STA.B $A2                                 ; $8089DE |
  RTL                                       ; $8089E0 |


CODE_8089E1:
  RTL                                       ; $8089E1 |

  LDA.B $E6                                 ; $8089E2 |
  AND.W #$7FFF                              ; $8089E4 |
  ORA.B $E4                                 ; $8089E7 |
  BNE CODE_8089E1                           ; $8089E9 |
  LDA.B $A2                                 ; $8089EB |
  BMI CODE_8089E1                           ; $8089ED |
  LDA.B $84                                 ; $8089EF |
  AND.W #$007F                              ; $8089F1 |
  BNE CODE_808A02                           ; $8089F4 |
  SEP #$20                                  ; $8089F6 |
  LDA.B $A2                                 ; $8089F8 |
  BEQ CODE_808A02                           ; $8089FA |
  SED                                       ; $8089FC |
  SBC.B #$01                                ; $8089FD |
  STA.B $A2                                 ; $8089FF |
  CLD                                       ; $808A01 |

CODE_808A02:
  REP #$20                                  ; $808A02 |
  LDA.B $A2                                 ; $808A04 |
  BEQ CODE_808A15                           ; $808A06 |
  CMP.W #$0010                              ; $808A08 |
  BCS CODE_8089E1                           ; $808A0B |
  LDA.B $84                                 ; $808A0D |
  AND.W #$003F                              ; $808A0F |
  BNE CODE_808A45                           ; $808A12 |
  RTL                                       ; $808A14 |


CODE_808A15:
  LDX.W #$0400                              ; $808A15 |
  LDA.W #$0000                              ; $808A18 |
  STA.W $1978                               ; $808A1B |
  LDA.B $18,X                               ; $808A1E |
  BEQ CODE_808A2D                           ; $808A20 |
  LDA.B $22,X                               ; $808A22 |
  CMP.W #$0014                              ; $808A24 |
  BEQ CODE_808A2D                           ; $808A27 |
  JSL.L CODE_FL_839270                      ; $808A29 |

CODE_808A2D:
  LDX.W #$04C0                              ; $808A2D |
  LDA.W #$0001                              ; $808A30 |
  STA.W $1978                               ; $808A33 |

  LDA.B $18,X                               ; $808A36 |

  BEQ CODE_808A45                           ; $808A38 |
  LDA.B $22,X                               ; $808A3A |
  CMP.W #$0014                              ; $808A3C |
  BEQ CODE_808A45                           ; $808A3F |
  JSL.L CODE_FL_839270                      ; $808A41 |

CODE_808A45:
  RTL                                       ; $808A45 |

  LDA.B !r_room_mode                        ; $808A46 |
  CMP.W #$0001                              ; $808A48 |
  BNE CODE_808A50                           ; $808A4B |
  LDA.B $A0                                 ; $808A4D |
  RTL                                       ; $808A4F |


CODE_808A50:
  LDA.B $CC                                 ; $808A50 |
  RTL                                       ; $808A52 |


set_room_mode:
  PHY                                       ; $808A53 |
  PHB                                       ; $808A54 |
  LDY.W #$0000                              ; $808A55 | Start with the first room mode threshold
  PEA.W $8181                               ; $808A58 |
  PLB                                       ; $808A5B |
  PLB                                       ; $808A5C |
  LDA.B !r_room_id                          ; $808A5D | Load current room ID

.find_room_mode
  CMP.W room_mode_thresholds,Y              ; $808A5F | Find the first threshold above the room ID
  BCC .set_mode                             ; $808A62 |
  INY                                       ; $808A64 |\
  INY                                       ; $808A65 | | Advance to the next threshold
  INY                                       ; $808A66 | |
  INY                                       ; $808A67 |/
  CPY.W #$000C                              ; $808A68 |
  BCC .find_room_mode                       ; $808A6B | Continue search

.set_mode
  LDA.B !r_room_mode                        ; $808A6D |
  STA.W $19B6                               ; $808A6F | Save previous room mode

  LDA.W room_mode_thresholds+2,Y            ; $808A72 | Load mode for the selected room range
  STA.B !r_room_mode                        ; $808A75 | Set current room mode
  PLB                                       ; $808A77 |
  PLY                                       ; $808A78 |
  RTL                                       ; $808A79 |


CODE_FL_808A7A:
  STA.B !r_room_id                          ; $808A7A |

CODE_FL_808A7C:
  JSL.L set_room_mode                       ; $808A7C |
  PHY                                       ; $808A80 |
  PHB                                       ; $808A81 |
  LDA.B !r_room_mode                        ; $808A82 |
  CMP.W #$0001                              ; $808A84 |
  BEQ CODE_808AA0                           ; $808A87 |
  PEA.W $8181                               ; $808A89 |
  PLB                                       ; $808A8C |
  PLB                                       ; $808A8D |
  LDA.B !r_room_id                          ; $808A8E |
  ASL A                                     ; $808A90 |
  ASL A                                     ; $808A91 |
  TAY                                       ; $808A92 |
  LDA.W DATA8_81ABF8+3,Y                    ; $808A93 |
  AND.W #$00FF                              ; $808A96 |
  STA.B $CC                                 ; $808A99 |
  STZ.B $8C                                 ; $808A9B |
  PLB                                       ; $808A9D |
  PLY                                       ; $808A9E |
  RTL                                       ; $808A9F |


CODE_808AA0:
  PEA.W $8181                               ; $808AA0 |
  PLB                                       ; $808AA3 |
  PLB                                       ; $808AA4 |
  LDA.B !r_room_id                          ; $808AA5 |
  ASL A                                     ; $808AA7 |
  ASL A                                     ; $808AA8 |
  TAY                                       ; $808AA9 |
  LDA.W DATA8_81ABF8+3,Y                    ; $808AAA |
  AND.W #$00FF                              ; $808AAD |
  STA.B $A0                                 ; $808AB0 |
  PLB                                       ; $808AB2 |
  PLY                                       ; $808AB3 |
  RTL                                       ; $808AB4 |


CODE_FL_808AB5:
  JSL.L CODE_FL_808ACA                      ; $808AB5 |
  LDA.B $08                                 ; $808AB9 |
  CLC                                       ; $808ABB |
  ADC.W $1662                               ; $808ABC |
  CLC                                       ; $808ABF |
  ADC.W $1762                               ; $808AC0 |
  SEC                                       ; $808AC3 |
  SBC.W #$0100                              ; $808AC4 |
  STA.B $0C                                 ; $808AC7 |
  RTL                                       ; $808AC9 |


CODE_FL_808ACA:
  LDA.B $0A                                 ; $808ACA |
  CLC                                       ; $808ACC |
  ADC.W $1672                               ; $808ACD |
  CLC                                       ; $808AD0 |
  ADC.W $1764                               ; $808AD1 |
  SEC                                       ; $808AD4 |
  SBC.W #$0100                              ; $808AD5 |
  STA.B $0E                                 ; $808AD8 |
  RTL                                       ; $808ADA |

  JSL.L CODE_FL_808ACA                      ; $808ADB |
  LDA.B $08                                 ; $808ADF |
  CLC                                       ; $808AE1 |
  ADC.W $1662                               ; $808AE2 |
  CLC                                       ; $808AE5 |
  ADC.W $1762                               ; $808AE6 |
  STA.B $0C                                 ; $808AE9 |
  RTL                                       ; $808AEB |

  LDA.B $0A                                 ; $808AEC |
  CLC                                       ; $808AEE |
  ADC.W $1672                               ; $808AEF |
  CLC                                       ; $808AF2 |
  ADC.W $1764                               ; $808AF3 |
  STA.B $0E                                 ; $808AF6 |
  RTL                                       ; $808AF8 |

  PHY                                       ; $808AF9 |

  PHB                                       ; $808AFA |
  PEA.W $8181                               ; $808AFB |
  PLB                                       ; $808AFE |
  PLB                                       ; $808AFF |
  JSR.W CODE_FN_808B6C                      ; $808B00 |
  LDA.W DATA8_81ABF8,Y                      ; $808B03 |
  AND.W #$FF00                              ; $808B06 |
  STA.B $00                                 ; $808B09 |
  LDA.B $08                                 ; $808B0B |
  SEC                                       ; $808B0D |
  SBC.B $00                                 ; $808B0E |

  CLC                                       ; $808B10 |
  ADC.W #$0100                              ; $808B11 |
  STA.B $0C                                 ; $808B14 |
  LDA.W DATA8_81ABF8+1,Y                    ; $808B16 |
  AND.W #$FF00                              ; $808B19 |
  STA.B $00                                 ; $808B1C |
  LDA.B $0A                                 ; $808B1E |
  SEC                                       ; $808B20 |
  SBC.B $00                                 ; $808B21 |
  CLC                                       ; $808B23 |
  ADC.W #$0100                              ; $808B24 |
  STA.B $0E                                 ; $808B27 |
  PLB                                       ; $808B29 |
  PLY                                       ; $808B2A |
  RTL                                       ; $808B2B |

  PHY                                       ; $808B2C |
  PHB                                       ; $808B2D |
  PEA.W $8181                               ; $808B2E |
  PLB                                       ; $808B31 |
  PLB                                       ; $808B32 |
  JSR.W CODE_FN_808B6C                      ; $808B33 |
  LDA.W DATA8_81ABF8,Y                      ; $808B36 |
  AND.W #$FF00                              ; $808B39 |
  STA.B $00                                 ; $808B3C |
  LDA.B $08                                 ; $808B3E |
  SEC                                       ; $808B40 |
  SBC.B $00                                 ; $808B41 |
  CLC                                       ; $808B43 |
  ADC.W #$0100                              ; $808B44 |
  STA.B $0C                                 ; $808B47 |
  PLB                                       ; $808B49 |
  PLY                                       ; $808B4A |
  RTL                                       ; $808B4B |

  PHY                                       ; $808B4C |
  PHB                                       ; $808B4D |
  PEA.W $8181                               ; $808B4E |
  PLB                                       ; $808B51 |
  PLB                                       ; $808B52 |
  JSR.W CODE_FN_808B6C                      ; $808B53 |
  LDA.W DATA8_81ABF8+1,Y                    ; $808B56 |
  AND.W #$FF00                              ; $808B59 |
  STA.B $00                                 ; $808B5C |
  LDA.B $0A                                 ; $808B5E |
  SEC                                       ; $808B60 |
  SBC.B $00                                 ; $808B61 |
  CLC                                       ; $808B63 |
  ADC.W #$0100                              ; $808B64 |
  STA.B $0E                                 ; $808B67 |

  PLB                                       ; $808B69 |
  PLY                                       ; $808B6A |
  RTL                                       ; $808B6B |


CODE_FN_808B6C:
  LDA.W $1760                               ; $808B6C |
  ASL A                                     ; $808B6F |
  TAY                                       ; $808B70 |
  LDA.W DATA16_81F6EF,Y                     ; $808B71 |
  STA.B $00                                 ; $808B74 |
  LDA.W #$007F                              ; $808B76 |
  STA.B $02                                 ; $808B79 |
  SEP #$20                                  ; $808B7B |
  LDA.B $0B                                 ; $808B7D |
  STA.W !reg_wrmpya                         ; $808B7F |
  LDA.W $1766                               ; $808B82 |
  STA.W !reg_wrmpyb                         ; $808B85 |
  REP #$20                                  ; $808B88 |
  LDA.B $09                                 ; $808B8A |
  AND.W #$00FF                              ; $808B8C |
  CLC                                       ; $808B8F |
  ADC.W !reg_rdmpyl                         ; $808B90 |
  TAY                                       ; $808B93 |
  LDA.B [$00],Y                             ; $808B94 |
  AND.W #$00FF                              ; $808B96 |
  ASL A                                     ; $808B99 |
  TAY                                       ; $808B9A |
  RTS                                       ; $808B9B |


CODE_FL_808B9C:
  JSL.L CODE_FL_808BB1                      ; $808B9C |
  LDA.B $08                                 ; $808BA0 |
  SEC                                       ; $808BA2 |
  SBC.W $1762                               ; $808BA3 |
  CLC                                       ; $808BA6 |
  ADC.W #$0100                              ; $808BA7 |
  SEC                                       ; $808BAA |
  SBC.W $1662                               ; $808BAB |
  STA.B $0C                                 ; $808BAE |
  RTL                                       ; $808BB0 |


CODE_FL_808BB1:
  LDA.B $0A                                 ; $808BB1 |
  SEC                                       ; $808BB3 |
  SBC.W $1764                               ; $808BB4 |
  CLC                                       ; $808BB7 |
  ADC.W #$0100                              ; $808BB8 |
  SEC                                       ; $808BBB |
  SBC.W $1672                               ; $808BBC |

  STA.B $0E                                 ; $808BBF |
  RTL                                       ; $808BC1 |


CODE_FL_808BC2:
  STZ.W $1662                               ; $808BC2 |
  STZ.W $1672                               ; $808BC5 |
  STZ.W $1682                               ; $808BC8 |
  STZ.W $1692                               ; $808BCB |
  STZ.W $16A2                               ; $808BCE |
  STZ.W $16B2                               ; $808BD1 |

  RTL                                       ; $808BD4 |

  LDA.W $1FFE                               ; $808BD5 |
  LSR A                                     ; $808BD8 |
  BCC CODE_808C2D                           ; $808BD9 |
  LDY.W #$5022                              ; $808BDB |
  LDA.W $1662                               ; $808BDE |
  STA.B $10                                 ; $808BE1 |
  JSR.W CODE_FN_808C2E                      ; $808BE3 |
  LDY.W #$5042                              ; $808BE6 |
  LDA.W $1672                               ; $808BE9 |
  STA.B $10                                 ; $808BEC |
  JSR.W CODE_FN_808C5A                      ; $808BEE |
  LDY.W #$502C                              ; $808BF1 |
  LDA.W $1662                               ; $808BF4 |
  CLC                                       ; $808BF7 |
  ADC.W $0409                               ; $808BF8 |
  STA.B $10                                 ; $808BFB |
  JSR.W CODE_FN_808C2E                      ; $808BFD |
  LDY.W #$504C                              ; $808C00 |
  LDA.W $1672                               ; $808C03 |
  CLC                                       ; $808C06 |
  ADC.W $040D                               ; $808C07 |
  STA.B $10                                 ; $808C0A |
  JSR.W CODE_FN_808C5A                      ; $808C0C |
  LDY.W #$5036                              ; $808C0F |
  LDA.W $1662                               ; $808C12 |
  CLC                                       ; $808C15 |
  ADC.W $04C9                               ; $808C16 |
  STA.B $10                                 ; $808C19 |
  JSR.W CODE_FN_808C2E                      ; $808C1B |
  LDY.W #$5056                              ; $808C1E |
  LDA.W $1672                               ; $808C21 |
  CLC                                       ; $808C24 |
  ADC.W $04C9                               ; $808C25 |
  STA.B $10                                 ; $808C28 |
  JSR.W CODE_FN_808C5A                      ; $808C2A |

CODE_808C2D:
  RTL                                       ; $808C2D |


CODE_FN_808C2E:
  JSL.L CODE_FL_809622                      ; $808C2E |
  LDA.W #$21D8                              ; $808C32 |
  JSL.L CODE_FL_809658                      ; $808C35 |
  LDA.B $11                                 ; $808C39 |
  LSR A                                     ; $808C3B |
  LSR A                                     ; $808C3C |
  LSR A                                     ; $808C3D |
  LSR A                                     ; $808C3E |
  JSR.W CODE_FN_808C86                      ; $808C3F |
  LDA.B $11                                 ; $808C42 |
  JSR.W CODE_FN_808C86                      ; $808C44 |
  LDA.B $10                                 ; $808C47 |
  LSR A                                     ; $808C49 |
  LSR A                                     ; $808C4A |
  LSR A                                     ; $808C4B |
  LSR A                                     ; $808C4C |
  JSR.W CODE_FN_808C86                      ; $808C4D |
  LDA.B $10                                 ; $808C50 |
  JSR.W CODE_FN_808C86                      ; $808C52 |
  JSL.L CODE_FL_809663                      ; $808C55 |
  RTS                                       ; $808C59 |


CODE_FN_808C5A:
  JSL.L CODE_FL_809622                      ; $808C5A |
  LDA.W #$21D9                              ; $808C5E |
  JSL.L CODE_FL_809658                      ; $808C61 |
  LDA.B $11                                 ; $808C65 |
  LSR A                                     ; $808C67 |
  LSR A                                     ; $808C68 |
  LSR A                                     ; $808C69 |
  LSR A                                     ; $808C6A |
  JSR.W CODE_FN_808C86                      ; $808C6B |
  LDA.B $11                                 ; $808C6E |
  JSR.W CODE_FN_808C86                      ; $808C70 |
  LDA.B $10                                 ; $808C73 |
  LSR A                                     ; $808C75 |
  LSR A                                     ; $808C76 |
  LSR A                                     ; $808C77 |
  LSR A                                     ; $808C78 |
  JSR.W CODE_FN_808C86                      ; $808C79 |
  LDA.B $10                                 ; $808C7C |
  JSR.W CODE_FN_808C86                      ; $808C7E |
  JSL.L CODE_FL_809663                      ; $808C81 |
  RTS                                       ; $808C85 |


CODE_FN_808C86:
  AND.W #$000F                              ; $808C86 |
  CMP.W #$000A                              ; $808C89 |
  BCC CODE_808C97                           ; $808C8C |
  CLC                                       ; $808C8E |
  ADC.W #$21B7                              ; $808C8F |
  JSL.L CODE_FL_809658                      ; $808C92 |
  RTS                                       ; $808C96 |


CODE_808C97:
  ORA.W #$21B0                              ; $808C97 |
  JSL.L CODE_FL_809658                      ; $808C9A |
  RTS                                       ; $808C9E |


CODE_FL_808C9F:
  LDA.L $7008E4                             ; $808C9F |
  CMP.W #$0001                              ; $808CA3 |
  BEQ CODE_FL_808CFC                        ; $808CA6 |
  JSL.L CODE_FL_808CB3                      ; $808CA8 |
  LDA.W #$7FFF                              ; $808CAC |
  STA.W $1C6C                               ; $808CAF |
  RTL                                       ; $808CB2 |


CODE_FL_808CB3:
  LDA.B !r_room_mode                        ; $808CB3 |
  STA.L $7008E4                             ; $808CB5 |
  REP #$30                                  ; $808CB9 |
  PHB                                       ; $808CBB |
  LDA.W #$0000                              ; $808CBC |
  STA.L $001C00                             ; $808CBF |
  LDA.W #$00FD                              ; $808CC3 |
  LDX.W #$1C01                              ; $808CC6 |
  TXY                                       ; $808CC9 |
  INY                                       ; $808CCA |
  MVN $00,$00                               ; $808CCB |
  PLB                                       ; $808CCE |
  REP #$30                                  ; $808CCF |
  PHB                                       ; $808CD1 |
  LDA.W #$0000                              ; $808CD2 |
  STA.L $7E8400                             ; $808CD5 |
  LDA.W #$3BFD                              ; $808CD9 |
  LDX.W #$8401                              ; $808CDC |
  TXY                                       ; $808CDF |
  INY                                       ; $808CE0 |
  MVN $7E,$7E                               ; $808CE1 |
  PLB                                       ; $808CE4 |
  REP #$30                                  ; $808CE5 |
  PHB                                       ; $808CE7 |
  LDA.W #$0000                              ; $808CE8 |
  STA.L $7E7C16                             ; $808CEB |
  LDA.W #$006B                              ; $808CEF |
  LDX.W #$7C17                              ; $808CF2 |
  TXY                                       ; $808CF5 |
  INY                                       ; $808CF6 |
  MVN $7E,$7E                               ; $808CF7 |
  PLB                                       ; $808CFA |
  RTL                                       ; $808CFB |


CODE_FL_808CFC:
  LDA.B !r_room_mode                        ; $808CFC |
  STA.L $7008E4                             ; $808CFE |
  REP #$30                                  ; $808D02 |
  PHB                                       ; $808D04 |
  LDA.W #$0000                              ; $808D05 |
  STA.L $001C00                             ; $808D08 |
  LDA.W #$0065                              ; $808D0C |
  LDX.W #$1C01                              ; $808D0F |
  TXY                                       ; $808D12 |
  INY                                       ; $808D13 |
  MVN $00,$00                               ; $808D14 |
  PLB                                       ; $808D17 |
  REP #$30                                  ; $808D18 |
  PHB                                       ; $808D1A |
  LDA.W #$0000                              ; $808D1B |
  STA.L $7E8400                             ; $808D1E |
  LDA.W #$077D                              ; $808D22 |
  LDX.W #$8401                              ; $808D25 |
  TXY                                       ; $808D28 |
  INY                                       ; $808D29 |
  MVN $7E,$7E                               ; $808D2A |
  PLB                                       ; $808D2D |
  REP #$30                                  ; $808D2E |
  PHB                                       ; $808D30 |
  LDA.W #$0000                              ; $808D31 |
  STA.L $7E7C16                             ; $808D34 |
  LDA.W #$006B                              ; $808D38 |
  LDX.W #$7C17                              ; $808D3B |
  TXY                                       ; $808D3E |
  INY                                       ; $808D3F |
  MVN $7E,$7E                               ; $808D40 |
  PLB                                       ; $808D43 |
  RTL                                       ; $808D44 |


CODE_FL_808D45:
  LDA.W #$0000                              ; $808D45 |

CODE_FL_808D48:
  STA.W $1FE0                               ; $808D48 |
  AND.W #$001F                              ; $808D4B |
  ORA.W #$0020                              ; $808D4E |
  STA.W $1FE2                               ; $808D51 |
  LDA.W $1FE0                               ; $808D54 |
  LSR A                                     ; $808D57 |
  LSR A                                     ; $808D58 |
  LSR A                                     ; $808D59 |
  LSR A                                     ; $808D5A |
  LSR A                                     ; $808D5B |
  AND.W #$001F                              ; $808D5C |
  ORA.W #$0040                              ; $808D5F |
  STA.W $1FE4                               ; $808D62 |
  LDA.W $1FE0                               ; $808D65 |
  XBA                                       ; $808D68 |
  LSR A                                     ; $808D69 |
  LSR A                                     ; $808D6A |
  AND.W #$001F                              ; $808D6B |
  ORA.W #$0080                              ; $808D6E |
  STA.W $1FE6                               ; $808D71 |
  RTL                                       ; $808D74 |


CODE_FL_808D75:
  LDY.W #$80AD                              ; $808D75 |

CODE_FL_808D78:
  STY.W $1FEC                               ; $808D78 |

CODE_FL_808D7B:
  PHB                                       ; $808D7B |
  PEA.W $8100                               ; $808D7C |
  PLB                                       ; $808D7F |
  PLB                                       ; $808D80 |
  SEP #$20                                  ; $808D81 |
  LDA.W $0000,Y                             ; $808D83 |
  STA.W $1FDC                               ; $808D86 |
  LDA.W $0001,Y                             ; $808D89 |
  STA.W $1FDE                               ; $808D8C |
  LDA.W $0002,Y                             ; $808D8F |
  STA.W $1FBE                               ; $808D92 |
  LDA.W $0003,Y                             ; $808D95 |
  STA.W $1FC0                               ; $808D98 |
  LDA.W $0004,Y                             ; $808D9B |
  CMP.B #$FF                                ; $808D9E |
  BEQ CODE_808DB7                           ; $808DA0 |
  STA.W $1FA4                               ; $808DA2 |
  LDA.W $0005,Y                             ; $808DA5 |
  STA.W $1FAC                               ; $808DA8 |
  LDA.W $0006,Y                             ; $808DAB |
  STA.W $1FAE                               ; $808DAE |
  LDA.W $0007,Y                             ; $808DB1 |
  STA.W $1FB0                               ; $808DB4 |

CODE_808DB7:
  REP #$20                                  ; $808DB7 |
  PLB                                       ; $808DB9 |
  RTL                                       ; $808DBA |


CODE_FL_808DBB:
  LDY.W #$81AA                              ; $808DBB |

CODE_FL_808DBE:
  PHB                                       ; $808DBE |
  PEA.W $8100                               ; $808DBF |
  PLB                                       ; $808DC2 |
  PLB                                       ; $808DC3 |
  SEP #$20                                  ; $808DC4 |
  LDA.W $0000,Y                             ; $808DC6 |
  STA.W $1FB4                               ; $808DC9 |
  LDA.W $0001,Y                             ; $808DCC |
  STA.W $1FB6                               ; $808DCF |
  LDA.W $0002,Y                             ; $808DD2 |
  STA.W $1FB8                               ; $808DD5 |
  LDA.W $0003,Y                             ; $808DD8 |
  STA.W $1FBA                               ; $808DDB |
  LDA.W $0004,Y                             ; $808DDE |
  STA.W $1FBC                               ; $808DE1 |
  LDA.W $0005,Y                             ; $808DE4 |
  STA.W $1FC2                               ; $808DE7 |
  LDA.W $0006,Y                             ; $808DEA |
  STA.W $1FC4                               ; $808DED |
  REP #$20                                  ; $808DF0 |
  PLB                                       ; $808DF2 |
  RTL                                       ; $808DF3 |


CODE_FL_808DF4:
  SEP #$20                                  ; $808DF4 |
  STA.W !reg_wrmpya                         ; $808DF6 |
  TYA                                       ; $808DF9 |
  STA.W !reg_wrmpyb                         ; $808DFA |
  NOP                                       ; $808DFD |
  XBA                                       ; $808DFE |
  REP #$20                                  ; $808DFF |
  LDA.W !reg_rdmpyl                         ; $808E01 |
  RTL                                       ; $808E04 |


CODE_FL_808E05:
  SEP #$20                                  ; $808E05 |
  CMP.B #$FF                                ; $808E07 |
  BNE CODE_808E1A                           ; $808E09 |
  STZ.B $00                                 ; $808E0B |
  STZ.B $03                                 ; $808E0D |
  REP #$20                                  ; $808E0F |
  STY.B $01                                 ; $808E11 |
  LDA.B $00                                 ; $808E13 |
  LDY.B $02                                 ; $808E15 |
  RTL                                       ; $808E17 |


CODE_FL_808E18:
  SEP #$20                                  ; $808E18 |

CODE_808E1A:
  STA.W !reg_wrmpya                         ; $808E1A |
  TYA                                       ; $808E1D |
  STA.W !reg_wrmpyb                         ; $808E1E |
  STZ.B $02                                 ; $808E21 |
  STZ.B $03                                 ; $808E23 |
  REP #$20                                  ; $808E25 |

  LDA.W !reg_rdmpyl                         ; $808E27 |
  STA.B $00                                 ; $808E2A |
  TYA                                       ; $808E2C |
  XBA                                       ; $808E2D |
  SEP #$20                                  ; $808E2E |
  STA.W !reg_wrmpyb                         ; $808E30 |
  NOP                                       ; $808E33 |
  NOP                                       ; $808E34 |
  CLC                                       ; $808E35 |

  REP #$20                                  ; $808E36 |

  LDA.W !reg_rdmpyl                         ; $808E38 |
  ADC.B $01                                 ; $808E3B |
  STA.B $01                                 ; $808E3D |
  LDY.B $02                                 ; $808E3F |
  LDA.B $00                                 ; $808E41 |
  RTL                                       ; $808E43 |


CODE_FL_808E44:
  SEP #$20                                  ; $808E44 |
  STA.W !reg_m7a                            ; $808E46 |
  LDA.B #$00                                ; $808E49 |
  XBA                                       ; $808E4B |
  STA.W !reg_m7a                            ; $808E4C |
  TYA                                       ; $808E4F |
  STA.W !reg_m7b                            ; $808E50 |
  STA.W !reg_m7b                            ; $808E53 |
  LDA.W !reg_mpyh                           ; $808E56 |
  BPL CODE_808E5E                           ; $808E59 |
  XBA                                       ; $808E5B |
  DEC A                                     ; $808E5C |
  XBA                                       ; $808E5D |

CODE_808E5E:
  REP #$20                                  ; $808E5E |
  TAY                                       ; $808E60 |
  LDA.W !reg_mpyl                           ; $808E61 |
  RTL                                       ; $808E64 |


CODE_FL_808E65:
  STA.W !reg_wrdivl                         ; $808E65 |

  SEP #$20                                  ; $808E68 |
  TYA                                       ; $808E6A |
  STA.W !reg_wrdivb                         ; $808E6B |
  LDA.B #$03                                ; $808E6E |

CODE_808E70:
  DEC A                                     ; $808E70 |
  BNE CODE_808E70                           ; $808E71 |
  REP #$20                                  ; $808E73 |
  LDA.W !reg_rddivl                         ; $808E75 |
  LDY.W !reg_rdmpyl                         ; $808E78 |
  RTL                                       ; $808E7B |


CODE_FL_808E7C:
  STA.B $02                                 ; $808E7C |
  STY.B $04                                 ; $808E7E |
  LDY.W #$0010                              ; $808E80 |
  LDA.W #$0000                              ; $808E83 |

CODE_808E86:
  ASL.B $02                                 ; $808E86 |
  ROL A                                     ; $808E88 |
  CMP.B $04                                 ; $808E89 |
  BCC CODE_808E8F                           ; $808E8B |
  SBC.B $04                                 ; $808E8D |

CODE_808E8F:
  ROL.B $00                                 ; $808E8F |
  DEY                                       ; $808E91 |
  BNE CODE_808E86                           ; $808E92 |
  LDA.B $00                                 ; $808E94 |
  RTL                                       ; $808E96 |


CODE_FL_808E97:
  STY.W !reg_wrdivl                         ; $808E97 |
  SEP #$20                                  ; $808E9A |
  STA.W !reg_wrdivb                         ; $808E9C |
  STA.B $03                                 ; $808E9F |
  LDA.B #$02                                ; $808EA1 |

CODE_808EA3:
  DEC A                                     ; $808EA3 |
  BNE CODE_808EA3                           ; $808EA4 |
  REP #$20                                  ; $808EA6 |
  LDA.W !reg_rddivl                         ; $808EA8 |
  STA.B $01                                 ; $808EAB |
  SEP #$20                                  ; $808EAD |
  LDA.W !reg_rdmpyl                         ; $808EAF |
  STA.W !reg_wrdivh                         ; $808EB2 |
  LDA.B $00                                 ; $808EB5 |
  STA.W !reg_wrdivl                         ; $808EB7 |
  LDA.B $03                                 ; $808EBA |
  STA.W !reg_wrdivb                         ; $808EBC |
  STZ.B $03                                 ; $808EBF |
  LDA.B #$03                                ; $808EC1 |

CODE_808EC3:
  DEC A                                     ; $808EC3 |
  BNE CODE_808EC3                           ; $808EC4 |
  LDA.W !reg_rddivl                         ; $808EC6 |

  STA.B $00                                 ; $808EC9 |
  REP #$20                                  ; $808ECB |
  LDA.B $00                                 ; $808ECD |
  LDY.B $02                                 ; $808ECF |
  RTL                                       ; $808ED1 |


CODE_FL_808ED2:
  REP #$20                                  ; $808ED2 |
  REP #$10                                  ; $808ED4 |
  PHX                                       ; $808ED6 |
  PHY                                       ; $808ED7 |
  CLC                                       ; $808ED8 |
  LDA.W #$04C0                              ; $808ED9 |
  STA.W $0416                               ; $808EDC |
  LDA.W #$0580                              ; $808EDF |

  STA.W $04D6                               ; $808EE2 |
  LDA.W #$0580                              ; $808EE5 |

CODE_808EE8:
  TAX                                       ; $808EE8 |
  ADC.W #$0050                              ; $808EE9 |
  STA.B $16,X                               ; $808EEC |
  CMP.W #$1660                              ; $808EEE |
  BCC CODE_808EE8                           ; $808EF1 |
  STZ.B $16,X                               ; $808EF3 |
  LDA.W #$0B70                              ; $808EF5 |
  STA.W $1B70                               ; $808EF8 |
  LDA.W #$0BC0                              ; $808EFB |
  STA.W $1B72                               ; $808EFE |
  LDA.W #$0C10                              ; $808F01 |
  STA.W $1B74                               ; $808F04 |
  LDA.W #$12F0                              ; $808F07 |
  STA.W $1B76                               ; $808F0A |
  LDA.W #$1340                              ; $808F0D |
  STA.W $1B78                               ; $808F10 |
  LDA.W #$1660                              ; $808F13 |
  STA.W $1B7A                               ; $808F16 |
  PLY                                       ; $808F19 |

  PLX                                       ; $808F1A |
  RTL                                       ; $808F1B |

  PHP                                       ; $808F1C |
  PHY                                       ; $808F1D |
  PHX                                       ; $808F1E |
  LDY.W #$0002                              ; $808F1F |
  BRA CODE_808F40                           ; $808F22 |


CODE_FL_808F24:
  PHX                                       ; $808F24 |
  TYX                                       ; $808F25 |
  JSL.L CODE_FL_808F2C                      ; $808F26 |
  PLX                                       ; $808F2A |
  RTL                                       ; $808F2B |


CODE_FL_808F2C:
  PHP                                       ; $808F2C |
  PHY                                       ; $808F2D |
  PHX                                       ; $808F2E |
  LDY.W #$000C                              ; $808F2F |
  CPX.W #$0580                              ; $808F32 |
  BCC CODE_808F40                           ; $808F35 |
  LDY.W #$0005                              ; $808F37 |
  CPX.W #$1660                              ; $808F3A |
  BCC CODE_808F40                           ; $808F3D |
  CLC                                       ; $808F3F |

CODE_808F40:
  STZ.B $00,X                               ; $808F40 |
  STZ.B $02,X                               ; $808F42 |
  STZ.B $04,X                               ; $808F44 |
  STZ.B $06,X                               ; $808F46 |
  STZ.B $08,X                               ; $808F48 |
  STZ.B $0A,X                               ; $808F4A |
  STZ.B $0C,X                               ; $808F4C |
  STZ.B $0E,X                               ; $808F4E |
  TXA                                       ; $808F50 |
  ADC.W #$0010                              ; $808F51 |
  TAX                                       ; $808F54 |
  DEY                                       ; $808F55 |
  BNE CODE_808F40                           ; $808F56 |
  PLX                                       ; $808F58 |
  CMP.W #$1660                              ; $808F59 |
  BEQ CODE_808F63                           ; $808F5C |
  STA.B $16,X                               ; $808F5E |
  PLY                                       ; $808F60 |
  PLP                                       ; $808F61 |
  RTL                                       ; $808F62 |


CODE_808F63:
  TDC                                       ; $808F63 |
  PLY                                       ; $808F64 |
  PLP                                       ; $808F65 |
  RTL                                       ; $808F66 |


CODE_FL_808F67:
  PHA                                       ; $808F67 |
  TDC                                       ; $808F68 |
  STA.L $7EDA06                             ; $808F69 |
  PLA                                       ; $808F6D |

CODE_FL_808F6E:
  PHA                                       ; $808F6E |
  LDA.B $A4                                 ; $808F6F |
  BEQ CODE_808F78                           ; $808F71 |
  LDA.W #$0002                              ; $808F73 |
  STA.B $D2                                 ; $808F76 |

CODE_808F78:
  TDC                                       ; $808F78 |
  STA.L $7EDA64                             ; $808F79 |
  PLA                                       ; $808F7D |
  RTL                                       ; $808F7E |


CODE_FL_808F7F:
  PHA                                       ; $808F7F |
  TDC                                       ; $808F80 |
  STA.L $7EDA06                             ; $808F81 |
  PLA                                       ; $808F85 |

CODE_FL_808F86:
  PHA                                       ; $808F86 |
  TDC                                       ; $808F87 |
  STA.L $7EDAB6                             ; $808F88 |
  PLA                                       ; $808F8C |
  STZ.W $16A2                               ; $808F8D |
  STZ.W $16A0                               ; $808F90 |
  RTL                                       ; $808F93 |


CODE_FL_808F94:
  PHA                                       ; $808F94 |
  TDC                                       ; $808F95 |
  STA.L $7EFFAC                             ; $808F96 |
  PLA                                       ; $808F9A |
  RTL                                       ; $808F9B |


CODE_FL_808F9C:
  PHA                                       ; $808F9C |
  TDC                                       ; $808F9D |
  STA.L $7EFFFE                             ; $808F9E |

  PLA                                       ; $808FA2 |
  RTL                                       ; $808FA3 |


CODE_FL_808FA4:
  PHA                                       ; $808FA4 |
  TDC                                       ; $808FA5 |
  STA.L $7EFFFE                             ; $808FA6 |
  PLA                                       ; $808FAA |
  RTL                                       ; $808FAB |


CODE_FL_808FAC:
  PHA                                       ; $808FAC |
  TDC                                       ; $808FAD |
  STA.L $7EFFFE                             ; $808FAE |
  PLA                                       ; $808FB2 |
  RTL                                       ; $808FB3 |


CODE_FL_808FB4:
  PHX                                       ; $808FB4 |
  LDX.W #$000A                              ; $808FB5 |
  BRA CODE_808FDC                           ; $808FB8 |


CODE_FL_808FBA:
  PHX                                       ; $808FBA |
  LDX.W #$0014                              ; $808FBB |
  BRA CODE_808FDC                           ; $808FBE |


CODE_FL_808FC0:
  PHX                                       ; $808FC0 |
  LDX.W #$001E                              ; $808FC1 |
  BRA CODE_808FDC                           ; $808FC4 |

  PHX                                       ; $808FC6 |
  LDX.W #$0028                              ; $808FC7 |
  BRA CODE_808FDC                           ; $808FCA |

  ORA.W #$2000                              ; $808FCC |
  PHX                                       ; $808FCF |
  LDX.W #$0032                              ; $808FD0 |
  BRA CODE_808FDC                           ; $808FD3 |


CODE_FL_808FD5:
  ORA.W #$2000                              ; $808FD5 |

CODE_FL_808FD8:
  PHX                                       ; $808FD8 |
  LDX.W #$0000                              ; $808FD9 |

CODE_808FDC:
  PHB                                       ; $808FDC |
  PHA                                       ; $808FDD |
  LDA.L DATA8_8183D9,X                      ; $808FDE |
  STA.B $00                                 ; $808FE2 |
  DEC A                                     ; $808FE4 |
  DEC A                                     ; $808FE5 |
  STA.B $02                                 ; $808FE6 |
  CLC                                       ; $808FE8 |
  ADC.L DATA8_8183DB,X                      ; $808FE9 |
  STA.B $06                                 ; $808FED |
  INC A                                     ; $808FEF |
  INC A                                     ; $808FF0 |
  STA.B $04                                 ; $808FF1 |
  LDA.L DATA8_8183E1,X                      ; $808FF3 |
  TAX                                       ; $808FF7 |
  PEA.W $7E00                               ; $808FF8 |
  PLB                                       ; $808FFB |
  PLB                                       ; $808FFC |
  PHX                                       ; $808FFD |
  LDA.W $0000,X                             ; $808FFE |
  TYX                                       ; $809001 |
  TAY                                       ; $809002 |
  BEQ CODE_809024                           ; $809003 |

CODE_809005:
  TXA                                       ; $809005 |
  CMP.B ($02),Y                             ; $809006 |
  BCS CODE_809018                           ; $809008 |
  LDA.B ($02),Y                             ; $80900A |
  STA.B ($00),Y                             ; $80900C |
  LDA.B ($06),Y                             ; $80900E |
  STA.B ($04),Y                             ; $809010 |
  DEY                                       ; $809012 |
  DEY                                       ; $809013 |
  BNE CODE_809005                           ; $809014 |
  BRA CODE_809024                           ; $809016 |


CODE_809018:
  BNE CODE_809024                           ; $809018 |
  TXA                                       ; $80901A |
  STA.B ($00),Y                             ; $80901B |
  PLX                                       ; $80901D |
  PLA                                       ; $80901E |
  STA.B ($04),Y                             ; $80901F |
  PLB                                       ; $809021 |
  PLX                                       ; $809022 |
  RTL                                       ; $809023 |


CODE_809024:
  TXA                                       ; $809024 |
  STA.B ($00),Y                             ; $809025 |
  PLX                                       ; $809027 |
  PLA                                       ; $809028 |
  STA.B ($04),Y                             ; $809029 |
  INC.W $0000,X                             ; $80902B |
  INC.W $0000,X                             ; $80902E |
  PLB                                       ; $809031 |
  PLX                                       ; $809032 |
  RTL                                       ; $809033 |


CODE_FL_809034:
  PHA                                       ; $809034 |
  SEP #$20                                  ; $809035 |
  LDA.W $1FC0                               ; $809037 |
  XBA                                       ; $80903A |
  LDA.W $1FBE                               ; $80903B |
  REP #$20                                  ; $80903E |
  ORA.W #$2000                              ; $809040 |
  STA.B $08                                 ; $809043 |
  LDA.W #$0004                              ; $809045 |
  STA.B $0A                                 ; $809048 |
  LDA.W #$0004                              ; $80904A |
  STA.B $0C                                 ; $80904D |
  LDX.W #$0032                              ; $80904F |
  BRA CODE_809076                           ; $809052 |


CODE_FL_809054:
  PHA                                       ; $809054 |
  SEP #$20                                  ; $809055 |
  LDA.W $1FC0                               ; $809057 |
  XBA                                       ; $80905A |
  LDA.W $1FBE                               ; $80905B |
  REP #$20                                  ; $80905E |
  ORA.W #$2000                              ; $809060 |
  STA.B $08                                 ; $809063 |
  STA.L $7EDA00                             ; $809065 |
  LDA.W #$0004                              ; $809069 |
  STA.B $0A                                 ; $80906C |
  LDA.W #$0004                              ; $80906E |
  STA.B $0C                                 ; $809071 |
  LDX.W #$0000                              ; $809073 |

CODE_809076:
  PHB                                       ; $809076 |
  PEA.W $7E00                               ; $809077 |
  PLB                                       ; $80907A |
  PLB                                       ; $80907B |
  STZ.B $00                                 ; $80907C |
  LDA.L DATA8_8183DB,X                      ; $80907E |
  STA.B $04                                 ; $809082 |
  CLC                                       ; $809084 |
  PHX                                       ; $809085 |
  LDA.L DATA8_8183E1,X                      ; $809086 |
  TAX                                       ; $80908A |
  LDA.W $0000,X                             ; $80908B |
  PLX                                       ; $80908E |
  ADC.L DATA8_8183D9,X                      ; $80908F |
  TAY                                       ; $809093 |
  LDA.W #$FFFF                              ; $809094 |
  STA.W $0000,Y                             ; $809097 |
  STY.B $06                                 ; $80909A |
  LDA.L DATA8_8183D9,X                      ; $80909C |
  TAY                                       ; $8090A0 |
  LDA.W $DA12                               ; $8090A1 |
  LSR A                                     ; $8090A4 |
  BCS CODE_8090A9                           ; $8090A5 |
  INX                                       ; $8090A7 |
  INX                                       ; $8090A8 |

CODE_8090A9:
  LDA.L DATA8_8183DD,X                      ; $8090A9 |
  TAX                                       ; $8090AD |
  LDA.B $08                                 ; $8090AE |
  JSR.W CODE_FN_809169                      ; $8090B0 |
  LDA.W $DA06                               ; $8090B3 |
  BEQ CODE_8090F0                           ; $8090B6 |

CODE_8090B8:
  LDA.W $0000,Y                             ; $8090B8 |
  CMP.W $DA08                               ; $8090BB |
  BCS CODE_8090CA                           ; $8090BE |
  JSR.W CODE_FN_80913A                      ; $8090C0 |
  JSR.W CODE_FN_809167                      ; $8090C3 |
  INY                                       ; $8090C6 |
  INY                                       ; $8090C7 |
  BRA CODE_8090B8                           ; $8090C8 |


CODE_8090CA:
  LDA.W $DA08                               ; $8090CA |
  JSR.W CODE_FN_80913A                      ; $8090CD |
  LDA.B $02                                 ; $8090D0 |
  PHA                                       ; $8090D2 |
  LDA.B $0A                                 ; $8090D3 |
  JSR.W CODE_FN_809176                      ; $8090D5 |
  LDA.W $DA0A                               ; $8090D8 |
  JSR.W CODE_FN_80913A                      ; $8090DB |
  PLA                                       ; $8090DE |
  STA.B $02                                 ; $8090DF |

CODE_8090E1:
  LDA.W $0000,Y                             ; $8090E1 |
  CMP.W $DA0A                               ; $8090E4 |
  BCS CODE_8090F0                           ; $8090E7 |
  JSR.W CODE_FN_809167                      ; $8090E9 |
  INY                                       ; $8090EC |
  INY                                       ; $8090ED |
  BRA CODE_8090E1                           ; $8090EE |


CODE_8090F0:
  LDA.W $00A4                               ; $8090F0 |
  BEQ CODE_80911A                           ; $8090F3 |

CODE_8090F5:
  LDA.W $0000,Y                             ; $8090F5 |
  CMP.W #$00BC                              ; $8090F8 |
  BCS CODE_809107                           ; $8090FB |
  JSR.W CODE_FN_80913A                      ; $8090FD |
  JSR.W CODE_FN_809167                      ; $809100 |
  INY                                       ; $809103 |
  INY                                       ; $809104 |
  BRA CODE_8090F5                           ; $809105 |


CODE_809107:
  LDA.W #$00BC                              ; $809107 |
  JSR.W CODE_FN_80913A                      ; $80910A |
  LDA.B $0C                                 ; $80910D |
  JSR.W CODE_FN_809176                      ; $80910F |
  LDA.W #$00DB                              ; $809112 |
  JSR.W CODE_FN_80913A                      ; $809115 |
  BRA CODE_809133                           ; $809118 |


CODE_80911A:
  CPY.B $06                                 ; $80911A |
  BEQ CODE_80912D                           ; $80911C |

CODE_80911E:
  LDA.W $0000,Y                             ; $80911E |
  JSR.W CODE_FN_80913A                      ; $809121 |
  JSR.W CODE_FN_809167                      ; $809124 |
  INY                                       ; $809127 |
  INY                                       ; $809128 |
  CPY.B $06                                 ; $809129 |
  BNE CODE_80911E                           ; $80912B |

CODE_80912D:
  LDA.W #$00E0                              ; $80912D |
  JSR.W CODE_FN_80913A                      ; $809130 |

CODE_809133:
  TDC                                       ; $809133 |
  STA.W $0000,Y                             ; $809134 |
  PLB                                       ; $809137 |
  PLA                                       ; $809138 |
  RTL                                       ; $809139 |


CODE_FN_80913A:
  PHA                                       ; $80913A |
  SEC                                       ; $80913B |
  SBC.B $00                                 ; $80913C |
  BEQ CODE_809163                           ; $80913E |
  CMP.W #$0080                              ; $809140 |
  BCC CODE_809158                           ; $809143 |
  SBC.W #$007F                              ; $809145 |
  PHA                                       ; $809148 |
  LDA.W #$007F                              ; $809149 |
  STA.W $0000,X                             ; $80914C |
  LDA.B $02                                 ; $80914F |
  STA.W $0001,X                             ; $809151 |
  INX                                       ; $809154 |
  INX                                       ; $809155 |
  INX                                       ; $809156 |
  PLA                                       ; $809157 |

CODE_809158:
  STA.W $0000,X                             ; $809158 |
  LDA.B $02                                 ; $80915B |
  STA.W $0001,X                             ; $80915D |
  INX                                       ; $809160 |
  INX                                       ; $809161 |
  INX                                       ; $809162 |

CODE_809163:
  PLA                                       ; $809163 |
  STA.B $00                                 ; $809164 |
  RTS                                       ; $809166 |


CODE_FN_809167:
  LDA.B ($04),Y                             ; $809167 |

CODE_FN_809169:
  BMI CODE_809170                           ; $809169 |
  CMP.W #$2000                              ; $80916B |
  BCS CODE_FN_809176                        ; $80916E |

CODE_809170:
  PHX                                       ; $809170 |
  TAX                                       ; $809171 |
  LDA.W $0000,X                             ; $809172 |
  PLX                                       ; $809175 |

CODE_FN_809176:
  STA.B $02                                 ; $809176 |
  RTS                                       ; $809178 |


CODE_FL_809179:
  PHA                                       ; $809179 |
  LDA.W #$16B2                              ; $80917A |
  STA.B $08                                 ; $80917D |
  LDA.W #$DA0C                              ; $80917F |
  STA.B $0A                                 ; $809182 |
  LDA.W #$0103                              ; $809184 |
  STA.B $0C                                 ; $809187 |
  LDX.W #$000A                              ; $809189 |
  BRA CODE_8091FA                           ; $80918C |


CODE_FL_80918E:
  PHA                                       ; $80918E |
  LDA.W #$16A2                              ; $80918F |
  STA.B $08                                 ; $809192 |
  LDA.W #$DA0E                              ; $809194 |
  STA.B $0A                                 ; $809197 |
  LDA.W #$0100                              ; $809199 |
  STA.B $0C                                 ; $80919C |
  LDX.W #$0014                              ; $80919E |
  BRA CODE_8091FA                           ; $8091A1 |


CODE_FL_8091A3:
  PHA                                       ; $8091A3 |
  SEP #$20                                  ; $8091A4 |
  LDA.W $1FAA                               ; $8091A6 |
  XBA                                       ; $8091A9 |
  LDA.W $1FA4                               ; $8091AA |
  REP #$20                                  ; $8091AD |
  STA.L $7EDA04                             ; $8091AF |
  AND.W #$00F8                              ; $8091B3 |

  ORA.W #$0001                              ; $8091B6 |
  STA.L $7EDA10                             ; $8091B9 |
  LDA.W #$DA04                              ; $8091BD |
  STA.B $08                                 ; $8091C0 |
  LDA.W #$DA10                              ; $8091C2 |
  STA.B $0A                                 ; $8091C5 |
  LDA.W #$0009                              ; $8091C7 |
  STA.B $0C                                 ; $8091CA |
  LDX.W #$001E                              ; $8091CC |
  BRA CODE_8091FA                           ; $8091CF |


CODE_FL_8091D1:
  PHA                                       ; $8091D1 |
  SEP #$20                                  ; $8091D2 |
  LDA.W $1FB2                               ; $8091D4 |
  XBA                                       ; $8091D7 |

  LDA.W $1FB0                               ; $8091D8 |
  REP #$20                                  ; $8091DB |
  STA.L $7EDA04                             ; $8091DD |
  AND.W #$FFFC                              ; $8091E1 |
  ORA.W #$0002                              ; $8091E4 |
  STA.L $7EDA10                             ; $8091E7 |
  STA.B $0C                                 ; $8091EB |
  LDA.W #$DA04                              ; $8091ED |
  STA.B $08                                 ; $8091F0 |
  LDA.W #$DA10                              ; $8091F2 |
  STA.B $0A                                 ; $8091F5 |
  LDX.W #$0028                              ; $8091F7 |

CODE_8091FA:
  PHB                                       ; $8091FA |
  PEA.W $7E00                               ; $8091FB |
  PLB                                       ; $8091FE |
  PLB                                       ; $8091FF |
  STZ.B $00                                 ; $809200 |
  LDA.L DATA8_8183DB,X                      ; $809202 |

  STA.B $04                                 ; $809206 |
  CLC                                       ; $809208 |

  PHX                                       ; $809209 |
  LDA.L DATA8_8183E1,X                      ; $80920A |
  TAX                                       ; $80920E |

  LDA.W $0000,X                             ; $80920F |
  PLX                                       ; $809212 |
  ADC.L DATA8_8183D9,X                      ; $809213 |
  TAY                                       ; $809217 |
  LDA.W #$FFFF                              ; $809218 |
  STA.W $0000,Y                             ; $80921B |
  STY.B $06                                 ; $80921E |

  LDA.L DATA8_8183D9,X                      ; $809220 |

  TAY                                       ; $809224 |

  LDA.W $DA12                               ; $809225 |
  LSR A                                     ; $809228 |
  BCS CODE_80922D                           ; $809229 |
  INX                                       ; $80922B |
  INX                                       ; $80922C |

CODE_80922D:
  LDA.L DATA8_8183DD,X                      ; $80922D |
  TAX                                       ; $809231 |
  LDA.B $08                                 ; $809232 |
  JSR.W CODE_FN_8092ED                      ; $809234 |
  LDA.W $DA06                               ; $809237 |
  BEQ CODE_809274                           ; $80923A |

CODE_80923C:
  LDA.W $0000,Y                             ; $80923C |
  CMP.W $DA08                               ; $80923F |
  BCS CODE_80924E                           ; $809242 |
  JSR.W CODE_FN_8092BE                      ; $809244 |
  JSR.W CODE_FN_8092EB                      ; $809247 |
  INY                                       ; $80924A |
  INY                                       ; $80924B |
  BRA CODE_80923C                           ; $80924C |


CODE_80924E:
  LDA.W $DA08                               ; $80924E |
  JSR.W CODE_FN_8092BE                      ; $809251 |
  LDA.B $02                                 ; $809254 |

  PHA                                       ; $809256 |
  LDA.B $0A                                 ; $809257 |
  JSR.W CODE_FN_8092ED                      ; $809259 |
  LDA.W $DA0A                               ; $80925C |
  JSR.W CODE_FN_8092BE                      ; $80925F |
  PLA                                       ; $809262 |
  STA.B $02                                 ; $809263 |

CODE_809265:
  LDA.W $0000,Y                             ; $809265 |
  CMP.W $DA0A                               ; $809268 |
  BCS CODE_809274                           ; $80926B |
  JSR.W CODE_FN_8092EB                      ; $80926D |
  INY                                       ; $809270 |
  INY                                       ; $809271 |
  BRA CODE_809265                           ; $809272 |


CODE_809274:
  LDA.W $00A4                               ; $809274 |
  BEQ CODE_80929E                           ; $809277 |

CODE_809279:
  LDA.W $0000,Y                             ; $809279 |
  CMP.W #$00BC                              ; $80927C |
  BCS CODE_80928B                           ; $80927F |
  JSR.W CODE_FN_8092BE                      ; $809281 |
  JSR.W CODE_FN_8092EB                      ; $809284 |
  INY                                       ; $809287 |
  INY                                       ; $809288 |
  BRA CODE_809279                           ; $809289 |


CODE_80928B:
  LDA.W #$00BC                              ; $80928B |
  JSR.W CODE_FN_8092BE                      ; $80928E |
  LDA.B $0C                                 ; $809291 |
  JSR.W CODE_FN_8092F3                      ; $809293 |
  LDA.W #$00DB                              ; $809296 |
  JSR.W CODE_FN_8092BE                      ; $809299 |
  BRA CODE_8092B7                           ; $80929C |


CODE_80929E:
  CPY.B $06                                 ; $80929E |
  BEQ CODE_8092B1                           ; $8092A0 |

CODE_8092A2:
  LDA.W $0000,Y                             ; $8092A2 |
  JSR.W CODE_FN_8092BE                      ; $8092A5 |
  JSR.W CODE_FN_8092EB                      ; $8092A8 |
  INY                                       ; $8092AB |
  INY                                       ; $8092AC |
  CPY.B $06                                 ; $8092AD |
  BNE CODE_8092A2                           ; $8092AF |

CODE_8092B1:
  LDA.W #$00E0                              ; $8092B1 |

  JSR.W CODE_FN_8092BE                      ; $8092B4 |

CODE_8092B7:
  TDC                                       ; $8092B7 |
  STA.W $0000,Y                             ; $8092B8 |
  PLB                                       ; $8092BB |
  PLA                                       ; $8092BC |
  RTL                                       ; $8092BD |


CODE_FN_8092BE:
  PHA                                       ; $8092BE |
  SEC                                       ; $8092BF |
  SBC.B $00                                 ; $8092C0 |

  BEQ CODE_8092E7                           ; $8092C2 |
  CMP.W #$0080                              ; $8092C4 |
  BCC CODE_8092DC                           ; $8092C7 |
  SBC.W #$007F                              ; $8092C9 |
  PHA                                       ; $8092CC |
  LDA.W #$007F                              ; $8092CD |
  STA.W $0000,X                             ; $8092D0 |
  LDA.B $02                                 ; $8092D3 |
  STA.W $0001,X                             ; $8092D5 |
  INX                                       ; $8092D8 |
  INX                                       ; $8092D9 |
  INX                                       ; $8092DA |
  PLA                                       ; $8092DB |

CODE_8092DC:
  STA.W $0000,X                             ; $8092DC |
  LDA.B $02                                 ; $8092DF |
  STA.W $0001,X                             ; $8092E1 |
  INX                                       ; $8092E4 |
  INX                                       ; $8092E5 |
  INX                                       ; $8092E6 |

CODE_8092E7:
  PLA                                       ; $8092E7 |
  STA.B $00                                 ; $8092E8 |
  RTS                                       ; $8092EA |


CODE_FN_8092EB:
  LDA.B ($04),Y                             ; $8092EB |

CODE_FN_8092ED:
  PHX                                       ; $8092ED |
  TAX                                       ; $8092EE |
  LDA.W $0000,X                             ; $8092EF |
  PLX                                       ; $8092F2 |

CODE_FN_8092F3:
  STA.B $02                                 ; $8092F3 |
  RTS                                       ; $8092F5 |


CODE_FL_8092F6:
  LDX.W $19AA                               ; $8092F6 |
  BEQ CODE_809346                           ; $8092F9 |
  LDA.W #!reg_mdmaen                        ; $8092FB |
  TCD                                       ; $8092FE |
  SEP #$20                                  ; $8092FF |
  PHB                                       ; $809301 |
  PEA.W $7E00                               ; $809302 |
  PLB                                       ; $809305 |
  PLB                                       ; $809306 |
  STZ.W $8400,X                             ; $809307 |
  LDX.W #$0000                              ; $80930A |
  LDY.W $8400,X                             ; $80930D |

CODE_809310:
  STY.B $FA                                 ; $809310 |
  LDY.W $8480,X                             ; $809312 |
  STY.B $F7                                 ; $809315 |
  LDY.W #$1801                              ; $809317 |
  STY.B $F5                                 ; $80931A |
  LDA.W $84C0,X                             ; $80931C |
  STA.B $F9                                 ; $80931F |
  REP #$20                                  ; $809321 |
  LDA.W $8440,X                             ; $809323 |
  STA.L $002116                             ; $809326 |
  SEP #$21                                  ; $80932A |
  LDA.B #$80                                ; $80932C |
  STA.L $002115                             ; $80932E |
  ROL A                                     ; $809332 |
  STA.B $00                                 ; $809333 |
  INX                                       ; $809335 |
  INX                                       ; $809336 |
  LDY.W $8400,X                             ; $809337 |
  BNE CODE_809310                           ; $80933A |
  STZ.W $8400                               ; $80933C |
  PLB                                       ; $80933F |
  REP #$20                                  ; $809340 |
  LDA.W #$0000                              ; $809342 |
  TCD                                       ; $809345 |

CODE_809346:
  STZ.W $19AA                               ; $809346 |
  RTL                                       ; $809349 |


CODE_FL_80934A:
  PHB                                       ; $80934A |
  PEA.W $7E00                               ; $80934B |
  PLB                                       ; $80934E |
  PLB                                       ; $80934F |
  PHX                                       ; $809350 |
  LDX.W $19AA                               ; $809351 |
  STA.W $8480,X                             ; $809354 |
  LDA.B $00                                 ; $809357 |
  STA.W $84C0,X                             ; $809359 |
  PLA                                       ; $80935C |
  STA.W $8400,X                             ; $80935D |
  TYA                                       ; $809360 |
  STA.W $8440,X                             ; $809361 |
  INX                                       ; $809364 |
  INX                                       ; $809365 |
  STX.W $19AA                               ; $809366 |
  STZ.W $8400,X                             ; $809369 |
  PLB                                       ; $80936C |
  RTL                                       ; $80936D |


CODE_FL_80936E:
  STZ.B $00                                 ; $80936E |
  LDA.W #$1770                              ; $809370 |
  TCD                                       ; $809373 |
  LDY.W #$0001                              ; $809374 |
  LDA.W #$0080                              ; $809377 |

  STA.W !reg_vmain                          ; $80937A |
  LDA.W #$1801                              ; $80937D |
  STA.W !reg_dmap0                          ; $809380 |
  LDA.B $00                                 ; $809383 |
  BEQ CODE_8093B6                           ; $809385 |
  STA.W !reg_das0l                          ; $809387 |
  SEP #$20                                  ; $80938A |
  INC.W $0000                               ; $80938C |
  LDA.B $06                                 ; $80938F |
  STA.W !reg_a1b0                           ; $809391 |
  REP #$20                                  ; $809394 |
  LDA.W #$6000                              ; $809396 |
  STA.W !reg_vmaddl                         ; $809399 |
  LDA.B $04                                 ; $80939C |
  STA.W !reg_a1t0l                          ; $80939E |
  STY.W !reg_mdmaen                         ; $8093A1 |
  LDA.B $08                                 ; $8093A4 |
  STA.W !reg_das0l                          ; $8093A6 |
  LDA.W #$6100                              ; $8093A9 |
  STA.W !reg_vmaddl                         ; $8093AC |
  STY.W !reg_mdmaen                         ; $8093AF |
  STZ.B $00                                 ; $8093B2 |
  STZ.B $08                                 ; $8093B4 |

CODE_8093B6:
  LDA.B $0C                                 ; $8093B6 |
  BEQ CODE_8093D6                           ; $8093B8 |

  STA.W !reg_das0l                          ; $8093BA |
  SEP #$20                                  ; $8093BD |
  LDA.B $12                                 ; $8093BF |
  STA.W !reg_a1b0                           ; $8093C1 |
  REP #$20                                  ; $8093C4 |
  LDA.W #$6200                              ; $8093C6 |
  STA.W !reg_vmaddl                         ; $8093C9 |
  LDA.B $10                                 ; $8093CC |
  STA.W !reg_a1t0l                          ; $8093CE |
  STY.W !reg_mdmaen                         ; $8093D1 |
  STZ.B $0C                                 ; $8093D4 |

CODE_8093D6:
  LDA.B $14                                 ; $8093D6 |
  BEQ CODE_809409                           ; $8093D8 |

  STA.W !reg_das0l                          ; $8093DA |
  SEP #$20                                  ; $8093DD |
  INC.W $0000                               ; $8093DF |
  LDA.B $1A                                 ; $8093E2 |
  STA.W !reg_a1b0                           ; $8093E4 |
  REP #$20                                  ; $8093E7 |
  LDA.W #$6300                              ; $8093E9 |
  STA.W !reg_vmaddl                         ; $8093EC |
  LDA.B $18                                 ; $8093EF |
  STA.W !reg_a1t0l                          ; $8093F1 |
  STY.W !reg_mdmaen                         ; $8093F4 |
  LDA.B $1C                                 ; $8093F7 |
  STA.W !reg_das0l                          ; $8093F9 |
  LDA.W #$6400                              ; $8093FC |
  STA.W !reg_vmaddl                         ; $8093FF |
  STY.W !reg_mdmaen                         ; $809402 |
  STZ.B $14                                 ; $809405 |
  STZ.B $1C                                 ; $809407 |

CODE_809409:
  LDA.B $20                                 ; $809409 |
  BEQ CODE_809429                           ; $80940B |
  STA.W !reg_das0l                          ; $80940D |
  SEP #$20                                  ; $809410 |
  LDA.B $26                                 ; $809412 |
  STA.W !reg_a1b0                           ; $809414 |
  REP #$20                                  ; $809417 |
  LDA.W #$6500                              ; $809419 |
  STA.W !reg_vmaddl                         ; $80941C |
  LDA.B $24                                 ; $80941F |
  STA.W !reg_a1t0l                          ; $809421 |
  STY.W !reg_mdmaen                         ; $809424 |
  STZ.B $20                                 ; $809427 |

CODE_809429:
  LDA.W $0000                               ; $809429 |
  BNE CODE_80948E                           ; $80942C |
  LDA.B $28                                 ; $80942E |
  BEQ CODE_80945E                           ; $809430 |
  STA.W !reg_das0l                          ; $809432 |
  SEP #$20                                  ; $809435 |
  LDA.B $2E                                 ; $809437 |
  STA.W !reg_a1b0                           ; $809439 |
  REP #$20                                  ; $80943C |
  LDA.W #$6600                              ; $80943E |
  STA.W !reg_vmaddl                         ; $809441 |
  LDA.B $2C                                 ; $809444 |
  STA.W !reg_a1t0l                          ; $809446 |
  STY.W !reg_mdmaen                         ; $809449 |
  LDA.B $30                                 ; $80944C |
  STA.W !reg_das0l                          ; $80944E |
  LDA.W #$6700                              ; $809451 |
  STA.W !reg_vmaddl                         ; $809454 |
  STY.W !reg_mdmaen                         ; $809457 |
  STZ.B $28                                 ; $80945A |
  STZ.B $30                                 ; $80945C |

CODE_80945E:
  LDA.B $34                                 ; $80945E |
  BEQ CODE_80948E                           ; $809460 |
  STA.W !reg_das0l                          ; $809462 |
  SEP #$20                                  ; $809465 |
  LDA.B $3A                                 ; $809467 |
  STA.W !reg_a1b0                           ; $809469 |
  REP #$20                                  ; $80946C |
  LDA.W #$6800                              ; $80946E |
  STA.W !reg_vmaddl                         ; $809471 |
  LDA.B $38                                 ; $809474 |
  STA.W !reg_a1t0l                          ; $809476 |
  STY.W !reg_mdmaen                         ; $809479 |
  LDA.B $3C                                 ; $80947C |
  STA.W !reg_das0l                          ; $80947E |
  LDA.W #$6900                              ; $809481 |
  STA.W !reg_vmaddl                         ; $809484 |
  STY.W !reg_mdmaen                         ; $809487 |
  STZ.B $34                                 ; $80948A |
  STZ.B $3C                                 ; $80948C |

CODE_80948E:
  LDA.W #$0000                              ; $80948E |
  TCD                                       ; $809491 |
  RTL                                       ; $809492 |


CODE_FL_809493:
  LDA.W $00A4                               ; $809493 |
  BEQ CODE_8094AF                           ; $809496 |
  LDA.W $1770                               ; $809498 |
  ORA.W $177C                               ; $80949B |
  ORA.W $1784                               ; $80949E |
  ORA.W $1790                               ; $8094A1 |

  ORA.W $1798                               ; $8094A4 |
  ORA.W $17A4                               ; $8094A7 |
  BNE CODE_8094AF                           ; $8094AA |
  JMP.W CODE_JP_80952F                      ; $8094AC |


CODE_8094AF:
  RTL                                       ; $8094AF |

  LDX.W #$0010                              ; $8094B0 |
  LDA.B $D8                                 ; $8094B3 |

CODE_8094B5:
  LSR A                                     ; $8094B5 |
  BCC CODE_8094BC                           ; $8094B6 |
  DEX                                       ; $8094B8 |
  DEX                                       ; $8094B9 |
  BNE CODE_8094B5                           ; $8094BA |

CODE_8094BC:
  LDA.W DATA16_818427,X                     ; $8094BC |
  TCD                                       ; $8094BF |
  SEP #$20                                  ; $8094C0 |
  LDA.B #$7E                                ; $8094C2 |
  STA.B $F9                                 ; $8094C4 |
  LDA.B #$80                                ; $8094C6 |
  STA.W !reg_vmain                          ; $8094C8 |
  REP #$20                                  ; $8094CB |
  LDA.W #$1801                              ; $8094CD |
  STA.B $F5                                 ; $8094D0 |
  LDA.W #$0100                              ; $8094D2 |
  STA.B $FA                                 ; $8094D5 |
  LDA.W #$5700                              ; $8094D7 |
  STA.W !reg_vmaddl                         ; $8094DA |

  LDA.W #$7F00                              ; $8094DD |
  STA.B $F7                                 ; $8094E0 |
  SEP #$20                                  ; $8094E2 |
  LDA.W DATA8_818415,X                      ; $8094E4 |
  STA.W !reg_mdmaen                         ; $8094E7 |
  REP #$20                                  ; $8094EA |
  LDA.W #$0000                              ; $8094EC |
  TCD                                       ; $8094EF |

  RTL                                       ; $8094F0 |

  LDX.W #$0010                              ; $8094F1 |
  LDA.B $D8                                 ; $8094F4 |

CODE_8094F6:
  LSR A                                     ; $8094F6 |
  BCC CODE_8094FD                           ; $8094F7 |
  DEX                                       ; $8094F9 |
  DEX                                       ; $8094FA |
  BNE CODE_8094F6                           ; $8094FB |

CODE_8094FD:
  LDA.W DATA16_818427,X                     ; $8094FD |
  TCD                                       ; $809500 |
  SEP #$20                                  ; $809501 |
  LDA.B #$7E                                ; $809503 |
  STA.B $F9                                 ; $809505 |
  LDA.B #$80                                ; $809507 |
  STA.W !reg_vmain                          ; $809509 |
  REP #$20                                  ; $80950C |
  LDA.W #$1801                              ; $80950E |
  STA.B $F5                                 ; $809511 |
  LDA.W #$0100                              ; $809513 |
  STA.B $FA                                 ; $809516 |
  LDA.W #$5700                              ; $809518 |
  STA.W !reg_vmaddl                         ; $80951B |
  STA.B $F7                                 ; $80951E |
  SEP #$20                                  ; $809520 |
  LDA.W DATA8_818415,X                      ; $809522 |
  STA.W !reg_mdmaen                         ; $809525 |
  REP #$20                                  ; $809528 |
  LDA.W #$0000                              ; $80952A |
  TCD                                       ; $80952D |
  RTL                                       ; $80952E |


CODE_JP_80952F:
  LDX.W #$0010                              ; $80952F |
  LDA.B $D8                                 ; $809532 |

CODE_809534:
  LSR A                                     ; $809534 |
  BCC CODE_80953B                           ; $809535 |
  DEX                                       ; $809537 |
  DEX                                       ; $809538 |
  BNE CODE_809534                           ; $809539 |

CODE_80953B:
  LDA.W DATA16_818427,X                     ; $80953B |
  TCD                                       ; $80953E |
  SEP #$20                                  ; $80953F |
  LDA.B #$7E                                ; $809541 |
  STA.B $F9                                 ; $809543 |
  LDA.B #$80                                ; $809545 |
  STA.W !reg_vmain                          ; $809547 |
  REP #$20                                  ; $80954A |
  LDA.W #$1801                              ; $80954C |
  STA.B $F5                                 ; $80954F |
  LDA.W #$0100                              ; $809551 |
  STA.B $FA                                 ; $809554 |
  LDA.W #$5700                              ; $809556 |
  STA.W !reg_vmaddl                         ; $809559 |
  LDA.W #$1820                              ; $80955C |
  STA.B $F7                                 ; $80955F |
  SEP #$20                                  ; $809561 |
  LDA.W DATA8_818415,X                      ; $809563 |
  STA.W !reg_mdmaen                         ; $809566 |
  REP #$20                                  ; $809569 |
  LDA.W #$0000                              ; $80956B |
  TCD                                       ; $80956E |
  RTL                                       ; $80956F |


CODE_FL_809570:
  LDA.W #!reg_mdmaen                        ; $809570 |
  TCD                                       ; $809573 |
  LDY.W #$0001                              ; $809574 |
  LDX.W #$19D2                              ; $809577 |

  CPX.W $19D0                               ; $80957A |
  BCS CODE_JP_8095BC                        ; $80957D |
  SEP #$20                                  ; $80957F |
  LDA.B #$7F                                ; $809581 |
  STA.B $F9                                 ; $809583 |
  INC A                                     ; $809585 |
  STA.W !reg_vmain                          ; $809586 |
  REP #$20                                  ; $809589 |
  LDA.W #$1801                              ; $80958B |
  STA.B $F5                                 ; $80958E |

CODE_809590:
  LDA.W #$0008                              ; $809590 |
  STA.B $FA                                 ; $809593 |
  LDA.W $0002,X                             ; $809595 |
  STA.W !reg_vmaddl                         ; $809598 |
  LDA.W $0000,X                             ; $80959B |
  STA.B $F7                                 ; $80959E |
  STY.B $00                                 ; $8095A0 |
  TXA                                       ; $8095A2 |
  ADC.W #$0004                              ; $8095A3 |
  TAX                                       ; $8095A6 |
  CPX.W $19D0                               ; $8095A7 |
  BCC CODE_809590                           ; $8095AA |
  LDA.W #$19D2                              ; $8095AC |
  STA.W $19D0                               ; $8095AF |
  JMP.W CODE_JP_8095BC                      ; $8095B2 |


CODE_FL_8095B5:
  LDA.W #!reg_mdmaen                        ; $8095B5 |
  TCD                                       ; $8095B8 |
  LDY.W #$0001                              ; $8095B9 |

CODE_JP_8095BC:
  LDX.W #$7000                              ; $8095BC |

.CODE_8095BF
  CPX.W $0050                               ; $8095BF |
  BCS .CODE_809600                          ; $8095C2 |
  LDA.L $7E0004,X                           ; $8095C4 |
  STA.W !reg_vmaddl                         ; $8095C8 |
  LDA.L $7E0006,X                           ; $8095CB |
  STA.B !reg_a1t0l-!reg_mdmaen              ; $8095CF |
  LDA.L $7E0009,X                           ; $8095D1 |
  STA.B !reg_das0l-!reg_mdmaen              ; $8095D5 |
  LDA.L $7E0002,X                           ; $8095D7 |
  STA.B !reg_dmap0-!reg_mdmaen              ; $8095DB |
  SEP #$20                                  ; $8095DD |
  LDA.L $7E0000,X                           ; $8095DF |
  STA.W !reg_vmain                          ; $8095E3 |
  XBA                                       ; $8095E6 |
  CMP.B #$39                                ; $8095E7 |
  BCC .CODE_8095EF                          ; $8095E9 |
  CLC                                       ; $8095EB |
  LDA.W !reg_rdvram                         ; $8095EC |

.CODE_8095EF
  LDA.L $7E0008,X                           ; $8095EF |
  STA.B !reg_a1b0-!reg_mdmaen               ; $8095F3 |
  STY.B !reg_mdmaen-!reg_mdmaen             ; $8095F5 |
  REP #$20                                  ; $8095F7 |
  TXA                                       ; $8095F9 |

  ADC.W #$000B                              ; $8095FA |
  TAX                                       ; $8095FD |
  BRA .CODE_8095BF                          ; $8095FE |


.CODE_809600
  LDA.W #$0000                              ; $809600 |
  TCD                                       ; $809603 |
  LDA.W #$7000                              ; $809604 |
  STA.B $50                                 ; $809607 |
  LDA.W #$7400                              ; $809609 |
  STA.B $52                                 ; $80960C |
  RTL                                       ; $80960E |


CODE_FL_80960F:
  LDA.W #$0000                              ; $80960F |
  LDX.B $50                                 ; $809612 |
  STA.L $7E0000,X                           ; $809614 |

  LDA.W #$1800                              ; $809618 |
  BRA CODE_80962E                           ; $80961B |


CODE_FL_80961D:
  LDA.W #$0081                              ; $80961D |

  BRA CODE_FL_809625                        ; $809620 |


CODE_FL_809622:
  LDA.W #$0080                              ; $809622 |

CODE_FL_809625:
  LDX.B $50                                 ; $809625 |
  STA.L $7E0000,X                           ; $809627 |
  LDA.W #$1801                              ; $80962B |

CODE_80962E:
  STA.L $7E0002,X                           ; $80962E |
  TYA                                       ; $809632 |
  STA.L $7E0004,X                           ; $809633 |
  LDA.B $52                                 ; $809637 |
  STA.L $7E0006,X                           ; $809639 |
  LDA.W #$007E                              ; $80963D |
  STA.L $7E0008,X                           ; $809640 |
  TXA                                       ; $809644 |
  CLC                                       ; $809645 |
  ADC.W #$000B                              ; $809646 |
  STA.B $50                                 ; $809649 |
  RTL                                       ; $80964B |

  SEP #$20                                  ; $80964C |

CODE_FL_80964E:
  LDX.B $52                                 ; $80964E |
  STA.L $7E0000,X                           ; $809650 |
  INX                                       ; $809654 |
  STX.B $52                                 ; $809655 |
  RTL                                       ; $809657 |


CODE_FL_809658:
  LDX.B $52                                 ; $809658 |
  STA.L $7E0000,X                           ; $80965A |
  INX                                       ; $80965E |
  INX                                       ; $80965F |

  STX.B $52                                 ; $809660 |
  RTL                                       ; $809662 |


CODE_FL_809663:
  LDX.B $50                                 ; $809663 |
  SEC                                       ; $809665 |
  LDA.B $52                                 ; $809666 |

  SBC.L $7E0000-5,X                         ; $809668 |
  STA.L $7E0000-2,X                         ; $80966C |

  RTL                                       ; $809670 |


CODE_FL_809671:
  PHX                                       ; $809671 |
  LDX.B $50                                 ; $809672 |
  STA.L $7E0006,X                           ; $809674 |

  LDA.B $00                                 ; $809678 |
  STA.L $7E0008,X                           ; $80967A |
  TYA                                       ; $80967E |
  STA.L $7E0004,X                           ; $80967F |
  LDA.W #$0080                              ; $809683 |

  STA.L $7E0000,X                           ; $809686 |
  LDA.W #$1801                              ; $80968A |
  STA.L $7E0002,X                           ; $80968D |
  PLA                                       ; $809691 |
  STA.L $7E0009,X                           ; $809692 |
  TXA                                       ; $809696 |
  CLC                                       ; $809697 |
  ADC.W #$000B                              ; $809698 |
  STA.B $50                                 ; $80969B |
  RTL                                       ; $80969D |


CODE_FL_80969E:
  PHX                                       ; $80969E |
  LDX.B $50                                 ; $80969F |
  STA.L $7E0006,X                           ; $8096A1 |
  LDA.B $00                                 ; $8096A5 |
  STA.L $7E0008,X                           ; $8096A7 |
  TYA                                       ; $8096AB |
  STA.L $7E0004,X                           ; $8096AC |
  LDA.W #$0080                              ; $8096B0 |
  STA.L $7E0000,X                           ; $8096B3 |
  LDA.W #$3981                              ; $8096B7 |
  STA.L $7E0002,X                           ; $8096BA |
  PLA                                       ; $8096BE |
  STA.L $7E0009,X                           ; $8096BF |
  TXA                                       ; $8096C3 |
  CLC                                       ; $8096C4 |
  ADC.W #$000B                              ; $8096C5 |
  STA.B $50                                 ; $8096C8 |
  RTL                                       ; $8096CA |


CODE_FL_8096CB:
  PHX                                       ; $8096CB |
  LDX.B $50                                 ; $8096CC |
  STA.L $7E0006,X                           ; $8096CE |
  LDA.B $00                                 ; $8096D2 |
  STA.L $7E0008,X                           ; $8096D4 |
  TYA                                       ; $8096D8 |
  STA.L $7E0004,X                           ; $8096D9 |
  LDA.W #$0080                              ; $8096DD |
  STA.L $7E0000,X                           ; $8096E0 |
  LDA.W #$1900                              ; $8096E4 |
  STA.L $7E0002,X                           ; $8096E7 |
  PLA                                       ; $8096EB |
  STA.L $7E0009,X                           ; $8096EC |
  TXA                                       ; $8096F0 |
  CLC                                       ; $8096F1 |
  ADC.W #$000B                              ; $8096F2 |
  STA.B $50                                 ; $8096F5 |
  RTL                                       ; $8096F7 |


CODE_FL_8096F8:
  PHX                                       ; $8096F8 |
  LDX.B $50                                 ; $8096F9 |
  STA.L $7E0006,X                           ; $8096FB |
  LDA.B $00                                 ; $8096FF |
  STA.L $7E0008,X                           ; $809701 |
  TYA                                       ; $809705 |
  STA.L $7E0004,X                           ; $809706 |
  LDA.W #$0000                              ; $80970A |
  STA.L $7E0000,X                           ; $80970D |
  LDA.W #$1800                              ; $809711 |
  STA.L $7E0002,X                           ; $809714 |
  PLA                                       ; $809718 |
  STA.L $7E0009,X                           ; $809719 |
  TXA                                       ; $80971D |
  CLC                                       ; $80971E |
  ADC.W #$000B                              ; $80971F |
  STA.B $50                                 ; $809722 |
  RTL                                       ; $809724 |


CODE_FL_809725:
  TYA                                       ; $809725 |
  ORA.B $5E                                 ; $809726 |
  STA.B $5E                                 ; $809728 |
  RTL                                       ; $80972A |


CODE_FL_80972B:
  TYA                                       ; $80972B |
  ORA.B $60                                 ; $80972C |
  STA.B $60                                 ; $80972E |
  TYA                                       ; $809730 |
  ASL A                                     ; $809731 |
  BCC CODE_809738                           ; $809732 |
  JSL.L CODE_FL_808F67                      ; $809734 |

CODE_809738:
  ASL A                                     ; $809738 |
  BCC CODE_80973F                           ; $809739 |
  JSL.L CODE_FL_808F7F                      ; $80973B |

CODE_80973F:
  ASL A                                     ; $80973F |
  BCC CODE_809746                           ; $809740 |
  JSL.L CODE_FL_808F94                      ; $809742 |

CODE_809746:
  ASL A                                     ; $809746 |
  BCC CODE_80974D                           ; $809747 |
  JSL.L CODE_FL_808FAC                      ; $809749 |

CODE_80974D:
  ASL A                                     ; $80974D |
  BCC CODE_809754                           ; $80974E |

  JSL.L CODE_FL_808F9C                      ; $809750 |

CODE_809754:
  ASL A                                     ; $809754 |
  BCC CODE_80975B                           ; $809755 |
  JSL.L CODE_FL_808FA4                      ; $809757 |

CODE_80975B:
  RTL                                       ; $80975B |


CODE_FL_80975C:
  TYA                                       ; $80975C |
  ORA.B $62                                 ; $80975D |
  STA.B $62                                 ; $80975F |
  RTL                                       ; $809761 |


CODE_FL_809762:
  TYA                                       ; $809762 |
  EOR.W #$FFFF                              ; $809763 |
  AND.B $5E                                 ; $809766 |

  STA.B $5E                                 ; $809768 |
  RTL                                       ; $80976A |


CODE_FL_80976B:
  TYA                                       ; $80976B |
  EOR.W #$FFFF                              ; $80976C |
  AND.B $60                                 ; $80976F |
  STA.B $60                                 ; $809771 |
  RTL                                       ; $809773 |

  TYA                                       ; $809774 |
  EOR.W #$FFFF                              ; $809775 |
  AND.B $62                                 ; $809778 |
  STA.B $62                                 ; $80977A |
  RTL                                       ; $80977C |


CODE_FL_80977D:
  STZ.B $5E                                 ; $80977D |
  STZ.B $60                                 ; $80977F |
  STZ.B $62                                 ; $809781 |
  RTL                                       ; $809783 |


CODE_FL_809784:
  SEP #$20                                  ; $809784 |

  LDA.W $1FF2                               ; $809786 |
  BEQ CODE_8097CF                           ; $809789 |
  LDX.W #$4370                              ; $80978B |
  LDA.B #$07                                ; $80978E |

CODE_809790:
  STA.B $08                                 ; $809790 |
  XBA                                       ; $809792 |
  LDA.B #$00                                ; $809793 |
  XBA                                       ; $809795 |
  ASL A                                     ; $809796 |
  ASL A                                     ; $809797 |
  ASL A                                     ; $809798 |
  TAY                                       ; $809799 |
  LDA.W $1D00,Y                             ; $80979A |
  STA.B $00,X                               ; $80979D |
  LDA.W $1D01,Y                             ; $80979F |

  STA.B $01,X                               ; $8097A2 |

  LDA.W $1D02,Y                             ; $8097A4 |
  STA.B $02,X                               ; $8097A7 |
  LDA.W $1D03,Y                             ; $8097A9 |
  STA.B $03,X                               ; $8097AC |
  LDA.W $1D04,Y                             ; $8097AE |
  STA.B $04,X                               ; $8097B1 |
  LDA.W $1D07,Y                             ; $8097B3 |

  STA.B $07,X                               ; $8097B6 |
  REP #$20                                  ; $8097B8 |
  TXA                                       ; $8097BA |
  SEC                                       ; $8097BB |
  SBC.W #$0010                              ; $8097BC |
  TAX                                       ; $8097BF |
  SEP #$20                                  ; $8097C0 |
  LDA.B $08                                 ; $8097C2 |
  DEC A                                     ; $8097C4 |
  BEQ CODE_8097CC                           ; $8097C5 |
  CMP.W $1FF6                               ; $8097C7 |
  BCS CODE_809790                           ; $8097CA |

CODE_8097CC:
  LDA.W $1FF2                               ; $8097CC |

CODE_8097CF:
  STA.W !reg_hdmaen                         ; $8097CF |
  REP #$20                                  ; $8097D2 |
  RTL                                       ; $8097D4 |


CODE_FL_8097D5:
  LDA.B $60                                 ; $8097D5 |
  ASL A                                     ; $8097D7 |
  BCC CODE_8097DE                           ; $8097D8 |
  JSL.L CODE_FL_809054                      ; $8097DA |

CODE_8097DE:
  ASL A                                     ; $8097DE |
  BCC CODE_8097E5                           ; $8097DF |
  JSL.L CODE_FL_809179                      ; $8097E1 |

CODE_8097E5:
  ASL A                                     ; $8097E5 |
  BCC CODE_8097EC                           ; $8097E6 |
  JSL.L CODE_FL_80918E                      ; $8097E8 |

CODE_8097EC:
  ASL A                                     ; $8097EC |
  BCC CODE_8097F3                           ; $8097ED |
  JSL.L CODE_FL_809034                      ; $8097EF |

CODE_8097F3:
  ASL A                                     ; $8097F3 |
  BCC CODE_8097FA                           ; $8097F4 |
  JSL.L CODE_FL_8091A3                      ; $8097F6 |

CODE_8097FA:
  ASL A                                     ; $8097FA |
  BCC CODE_809801                           ; $8097FB |
  JSL.L CODE_FL_8091D1                      ; $8097FD |

CODE_809801:
  LDA.L $7EDA12                             ; $809801 |
  EOR.W #$0001                              ; $809805 |
  STA.L $7EDA12                             ; $809808 |
  REP #$20                                  ; $80980C |
  LDY.W #$0007                              ; $80980E |
  STY.B $08                                 ; $809811 |
  LDY.W #$0010                              ; $809813 |
  LDX.W #$FFFE                              ; $809816 |
  LDA.B $5E                                 ; $809819 |
  JSR.W CODE_FN_809852                      ; $80981B |
  LDY.W #$0010                              ; $80981E |
  LDX.W #$001E                              ; $809821 |
  LDA.B $60                                 ; $809824 |
  JSR.W CODE_FN_809852                      ; $809826 |
  LDY.W #$0010                              ; $809829 |
  LDX.W #$003E                              ; $80982C |
  LDA.B $62                                 ; $80982F |
  JSR.W CODE_FN_809852                      ; $809831 |
  LDY.B $08                                 ; $809834 |
  INY                                       ; $809836 |
  LDA.W #$0000                              ; $809837 |

  CPY.W #$0008                              ; $80983A |
  BCS CODE_809842                           ; $80983D |
  LDA.W DATA8_818439,Y                      ; $80983F |

CODE_809842:
  STA.W $1FF2                               ; $809842 |
  RTL                                       ; $809845 |


CODE_809846:
  ASL A                                     ; $809846 |
  BCC CODE_80987B                           ; $809847 |
  PHA                                       ; $809849 |
  PHX                                       ; $80984A |
  PHY                                       ; $80984B |
  JSR.W CODE_FN_809881                      ; $80984C |
  PLY                                       ; $80984F |
  PLX                                       ; $809850 |
  PLA                                       ; $809851 |

CODE_FN_809852:
  BEQ CODE_809880                           ; $809852 |
  CMP.W #$1000                              ; $809854 |
  BCS CODE_80987B                           ; $809857 |
  CMP.W #$0100                              ; $809859 |
  BCC CODE_80986E                           ; $80985C |
  ASL A                                     ; $80985E |
  ASL A                                     ; $80985F |
  ASL A                                     ; $809860 |
  ASL A                                     ; $809861 |
  PHA                                       ; $809862 |
  TXA                                       ; $809863 |
  ADC.W #$0008                              ; $809864 |
  TAX                                       ; $809867 |
  DEY                                       ; $809868 |
  DEY                                       ; $809869 |
  DEY                                       ; $80986A |
  DEY                                       ; $80986B |
  BRA CODE_80987A                           ; $80986C |


CODE_80986E:
  XBA                                       ; $80986E |
  PHA                                       ; $80986F |
  TXA                                       ; $809870 |
  ADC.W #$0010                              ; $809871 |
  TAX                                       ; $809874 |
  TYA                                       ; $809875 |
  SBC.W #$0007                              ; $809876 |
  TAY                                       ; $809879 |

CODE_80987A:
  PLA                                       ; $80987A |

CODE_80987B:
  INX                                       ; $80987B |
  INX                                       ; $80987C |
  DEY                                       ; $80987D |
  BPL CODE_809846                           ; $80987E |

CODE_809880:
  RTS                                       ; $809880 |


CODE_FN_809881:
  LDA.B $08                                 ; $809881 |
  BEQ CODE_8098D6                           ; $809883 |
  LDY.W PTR16_818441,X                      ; $809885 |

CODE_809888:
  LDA.B $08                                 ; $809888 |
  ASL A                                     ; $80988A |
  ASL A                                     ; $80988B |
  ASL A                                     ; $80988C |
  ORA.W #$1D00                              ; $80988D |

  TAX                                       ; $809890 |
  LDA.W $0000,Y                             ; $809891 |
  STA.B $00,X                               ; $809894 |

  XBA                                       ; $809896 |
  ASL A                                     ; $809897 |
  BCC CODE_80989D                           ; $809898 |
  STZ.B $00,X                               ; $80989A |
  RTS                                       ; $80989C |


CODE_80989D:
  PHX                                       ; $80989D |
  STZ.B $06                                 ; $80989E |
  LDX.W $0002,Y                             ; $8098A0 |
  LDA.L $7E0000,X                           ; $8098A3 |
  PLX                                       ; $8098A7 |
  LSR A                                     ; $8098A8 |
  LDA.W $0004,Y                             ; $8098A9 |
  BCC CODE_8098B1                           ; $8098AC |
  LDA.W $0006,Y                             ; $8098AE |

CODE_8098B1:
  BMI CODE_8098BE                           ; $8098B1 |
  ORA.W #$8000                              ; $8098B3 |
  STA.B $02,X                               ; $8098B6 |
  SEP #$20                                  ; $8098B8 |
  LDA.B #$7E                                ; $8098BA |
  BRA CODE_8098C4                           ; $8098BC |


CODE_8098BE:
  STA.B $02,X                               ; $8098BE |
  SEP #$20                                  ; $8098C0 |
  PHB                                       ; $8098C2 |
  PLA                                       ; $8098C3 |

CODE_8098C4:
  STA.B $04,X                               ; $8098C4 |
  LDA.B #$7E                                ; $8098C6 |
  STA.B $07,X                               ; $8098C8 |
  REP #$20                                  ; $8098CA |
  TYA                                       ; $8098CC |
  CLC                                       ; $8098CD |
  ADC.W #$0008                              ; $8098CE |
  TAY                                       ; $8098D1 |
  DEC.B $08                                 ; $8098D2 |
  BNE CODE_809888                           ; $8098D4 |

CODE_8098D6:
  RTS                                       ; $8098D6 |

  LDY.W #$0400                              ; $8098D7 |
  LDA.B $32,X                               ; $8098DA |
  BIT.W #$1000                              ; $8098DC |
  BEQ CODE_FL_8098E4                        ; $8098DF |
  LDY.W #$04C0                              ; $8098E1 |

CODE_FL_8098E4:
  LDA.W #$00DC                              ; $8098E4 |
  CPY.W $00DC                               ; $8098E7 |
  BEQ CODE_8098F5                           ; $8098EA |
  LDA.W #$00DE                              ; $8098EC |
  CPY.W $00DE                               ; $8098EF |
  BEQ CODE_8098F5                           ; $8098F2 |
  TDC                                       ; $8098F4 |

CODE_8098F5:
  STA.B $48,X                               ; $8098F5 |
  RTL                                       ; $8098F7 |


CODE_FL_8098F8:
  LDY.W #$8001                              ; $8098F8 |
  BRA CODE_809900                           ; $8098FB |


CODE_FL_8098FD:
  LDY.W #$0001                              ; $8098FD |

CODE_809900:
  LDA.B $40,X                               ; $809900 |
  BEQ CODE_809927                           ; $809902 |

  LDA.L $7E7C16                             ; $809904 |
  BNE CODE_80991D                           ; $809908 |
  STY.B $E4                                 ; $80990A |
  LDY.W #$8001                              ; $80990C |
  LDA.B ($48,X)                             ; $80990F |
  CMP.W #$0400                              ; $809911 |
  BEQ CODE_80991D                           ; $809914 |
  INY                                       ; $809916 |
  CMP.W #$04C0                              ; $809917 |
  BEQ CODE_80991D                           ; $80991A |
  INY                                       ; $80991C |

CODE_80991D:
  LDA.B $40,X                               ; $80991D |
  JSL.L CODE_FL_809941                      ; $80991F |
  BCC CODE_809928                           ; $809923 |
  STZ.B $E4                                 ; $809925 |

CODE_809927:
  SEC                                       ; $809927 |

CODE_809928:
  RTL                                       ; $809928 |


CODE_FL_809929:
  PHA                                       ; $809929 |
  JSL.L CODE_FL_809EBF                      ; $80992A |
  PLA                                       ; $80992E |
  LDY.W #$0000                              ; $80992F |
  BRA CODE_FL_809941                        ; $809932 |


CODE_FL_809934:
  LDY.W #$0003                              ; $809934 |
  BRA CODE_FL_809941                        ; $809937 |


CODE_FL_809939:
  LDY.W #$0002                              ; $809939 |
  BRA CODE_FL_809941                        ; $80993C |


CODE_FL_80993E:
  LDY.W #$0001                              ; $80993E |

CODE_FL_809941:
  PHY                                       ; $809941 |
  PHX                                       ; $809942 |
  PHB                                       ; $809943 |
  PEA.W $7E00                               ; $809944 |
  PLB                                       ; $809947 |
  PLB                                       ; $809948 |
  STY.B $04                                 ; $809949 |
  LDY.W $7C16                               ; $80994B |
  BNE CODE_80995B                           ; $80994E |
  BIT.W #$FFFF                              ; $809950 |
  BEQ CODE_809991                           ; $809953 |
  LDY.W #$0004                              ; $809955 |
  STY.W $7C4E                               ; $809958 |

CODE_80995B:
  CPX.W $7C1A                               ; $80995B |
  BEQ CODE_809966                           ; $80995E |
  CLC                                       ; $809960 |
  LDY.W $7C16                               ; $809961 |
  BNE CODE_809992                           ; $809964 |

CODE_809966:
  LDY.W #$000C                              ; $809966 |
  STY.W $7C82                               ; $809969 |

CODE_80996C:
  LDY.B $04                                 ; $80996C |
  STZ.W $7C1E                               ; $80996E |
  JSL.L CODE_FL_8099B2                      ; $809971 |
  CLC                                       ; $809975 |
  LDA.W $7C18                               ; $809976 |
  ORA.W $7C4C                               ; $809979 |
  BNE CODE_809996                           ; $80997C |
  JSL.L set_text                            ; $80997E |
  STZ.W $7C36                               ; $809982 |
  STZ.W $7C0E                               ; $809985 |
  STZ.W $7C3A                               ; $809988 |
  STZ.W $7C4C                               ; $80998B |
  STZ.W $7C74                               ; $80998E |

CODE_809991:
  SEC                                       ; $809991 |

CODE_809992:
  PLB                                       ; $809992 |
  PLX                                       ; $809993 |
  PLY                                       ; $809994 |
  RTL                                       ; $809995 |


CODE_809996:
  LDA.W $7C5A                               ; $809996 |
  BEQ CODE_809992                           ; $809999 |
  LDA.W $7C02                               ; $80999B |
  ORA.W $7C04                               ; $80999E |
  BNE CODE_809992                           ; $8099A1 |
  LDA.W $7C38                               ; $8099A3 |
  BEQ CODE_809992                           ; $8099A6 |
  DEC.W $7C82                               ; $8099A8 |
  BMI CODE_809992                           ; $8099AB |
  LDA.W $7C18                               ; $8099AD |
  BRA CODE_80996C                           ; $8099B0 |


CODE_FL_8099B2:
  STA.B $04                                 ; $8099B2 |
  LDA.W $7C16                               ; $8099B4 |
  BEQ .CODE_809A02                          ; $8099B7 |
  JSR.W CODE_FN_809B37                      ; $8099B9 |
  LDA.W $7C4C                               ; $8099BC |
  BNE .CODE_8099FE                          ; $8099BF |
  LDA.W $7C3A                               ; $8099C1 |
  BEQ .CODE_8099C9                          ; $8099C4 |
  JMP.W CODE_JP_80A216                      ; $8099C6 |


.CODE_8099C9
  LDA.W $7C00                               ; $8099C9 |
  BEQ .CODE_8099D4                          ; $8099CC |
  STZ.W $7C00                               ; $8099CE |
  STA.W $7C02                               ; $8099D1 |

.CODE_8099D4
  LDA.W $7C02                               ; $8099D4 |
  BNE .CODE_8099FD                          ; $8099D7 |
  LDA.L $007C20                             ; $8099D9 |
  BNE .CODE_8099ED                          ; $8099DD |
  LDA.W $7C4E                               ; $8099DF |
  LSR A                                     ; $8099E2 |
  BEQ .CODE_8099ED                          ; $8099E3 |
  LDA.W $DA06                               ; $8099E5 |
  BNE .CODE_8099ED                          ; $8099E8 |
  JMP.W CODE_JP_809BD0                      ; $8099EA |


.CODE_8099ED
  LDA.W $7C0E                               ; $8099ED |
  BNE .CODE_8099F5                          ; $8099F0 |
  JMP.W CODE_JP_809BD0                      ; $8099F2 |


.CODE_8099F5
  DEC.W $7C0E                               ; $8099F5 |
  BNE .CODE_8099FD                          ; $8099F8 |
  JMP.W CODE_JP_809BD0                      ; $8099FA |


.CODE_8099FD
  RTL                                       ; $8099FD |


.CODE_8099FE
  JML.L CODE_JL_80AD13                      ; $8099FE |


.CODE_809A02
  LDA.B $04                                 ; $809A02 |
  JSL.L set_text                            ; $809A04 |
  STA.W $7C18                               ; $809A08 |
  STX.W $7C1A                               ; $809A0B |
  STY.W $7C1C                               ; $809A0E |
  STZ.W $7C74                               ; $809A11 |
  STZ.W $7C3A                               ; $809A14 |
  LDA.W #$0004                              ; $809A17 |
  STA.W $7C0C                               ; $809A1A |
  STA.W $7C0E                               ; $809A1D |
  STZ.W $7C20                               ; $809A20 |
  LDA.W #$0001                              ; $809A23 |
  STA.W $7C10                               ; $809A26 |
  LDA.W #$0046                              ; $809A29 |
  STA.W $7C12                               ; $809A2C |
  LDA.W #$3000                              ; $809A2F |
  STA.W $7C30                               ; $809A32 |
  STZ.W $7C02                               ; $809A35 |
  STZ.W $7C00                               ; $809A38 |
  STZ.W $7C04                               ; $809A3B |
  STZ.W $7C60                               ; $809A3E |
  STZ.W $7C0A                               ; $809A41 |
  STZ.W $7C0E                               ; $809A44 |
  STZ.W $7C14                               ; $809A47 |
  STZ.W $7C42                               ; $809A4A |
  STZ.W $7C66                               ; $809A4D |
  STZ.W $7C68                               ; $809A50 |
  STZ.W $7C5C                               ; $809A53 |
  LDA.W #$FFFF                              ; $809A56 |
  STA.W $7C5A                               ; $809A59 |
  JSL.L CODE_FL_809A7F                      ; $809A5C |
  STZ.W $DA06                               ; $809A60 |
  LDX.W $7C16                               ; $809A63 |
  TXA                                       ; $809A66 |
  BPL .CODE_809A6F                          ; $809A67 |
  LDA.L $BD0000,X                           ; $809A69 |
  BRA .CODE_809A73                          ; $809A6D |


.CODE_809A6F
  LDA.L $B68000,X                           ; $809A6F |

.CODE_809A73
  AND.W #$00FF                              ; $809A73 |
  BNE .CODE_809A7E                          ; $809A76 |
  STZ.W $7C18                               ; $809A78 |
  STZ.W $7C4C                               ; $809A7B |

.CODE_809A7E
  RTL                                       ; $809A7E |


CODE_FL_809A7F:
  LDA.W $7C4E                               ; $809A7F |
  LSR A                                     ; $809A82 |
  BEQ CODE_809AC4                           ; $809A83 |
  LDA.W $7C4E                               ; $809A85 |

  AND.W #$0001                              ; $809A88 |
  STA.W $7C2E                               ; $809A8B |
  LDA.W #$0002                              ; $809A8E |
  STA.W $7C26                               ; $809A91 |
  STA.W $7C22                               ; $809A94 |
  LDA.W #$001B                              ; $809A97 |
  STA.W $7C2A                               ; $809A9A |
  LDA.W #$0021                              ; $809A9D |
  LDY.B !r_room_mode                        ; $809AA0 |
  CPY.W #$0004                              ; $809AA2 |
  BNE CODE_809AAA                           ; $809AA5 |
  LDA.W #$0035                              ; $809AA7 |

CODE_809AAA:
  STA.W $7C28                               ; $809AAA |
  STA.W $7C24                               ; $809AAD |
  LDA.W #$0006                              ; $809AB0 |
  LDY.W $7C2E                               ; $809AB3 |
  BEQ CODE_809ABB                           ; $809AB6 |
  LDA.W #$0004                              ; $809AB8 |

CODE_809ABB:
  STA.W $7C2C                               ; $809ABB |
  STZ.W $7C58                               ; $809ABE |
  JSR.W CODE_FN_80A185                      ; $809AC1 |

CODE_809AC4:
  CLC                                       ; $809AC4 |
  RTL                                       ; $809AC5 |


CODE_FN_809AC6:
  BIT.W $7C5A                               ; $809AC6 |
  BMI CODE_809ACC                           ; $809AC9 |

CODE_809ACB:
  RTS                                       ; $809ACB |


CODE_809ACC:
  PLA                                       ; $809ACC |
  JSL.L CODE_FL_80A60E                      ; $809ACD |
  JML.L CODE_JL_80AD2D                      ; $809AD1 |


CODE_FN_809AD5:
  BIT.W $7C5A                               ; $809AD5 |
  BMI CODE_809ACC                           ; $809AD8 |
  LDA.W $7C4E                               ; $809ADA |
  LSR A                                     ; $809ADD |
  BEQ CODE_809ACB                           ; $809ADE |
  LDA.W $DA06                               ; $809AE0 |
  BNE CODE_809ACB                           ; $809AE3 |
  PLA                                       ; $809AE5 |
  JSL.L CODE_FL_80A60E                      ; $809AE6 |
  JML.L CODE_JL_80AE34                      ; $809AEA |


CODE_FN_809AEE:
  LDA.W $7C14                               ; $809AEE |
  BNE CODE_809B10                           ; $809AF1 |
  BIT.W $7C5A                               ; $809AF3 |
  BMI CODE_809B10                           ; $809AF6 |
  LDA.W $7C5A                               ; $809AF8 |
  BNE CODE_809B10                           ; $809AFB |
  LDA.W $7C4E                               ; $809AFD |
  LSR A                                     ; $809B00 |
  BEQ CODE_809B10                           ; $809B01 |
  LDA.W $7C0E                               ; $809B03 |
  BNE CODE_809B10                           ; $809B06 |
  JSR.W CODE_FN_809B82                      ; $809B08 |
  BIT.W #$0040                              ; $809B0B |
  BNE CODE_809B11                           ; $809B0E |

CODE_809B10:
  RTS                                       ; $809B10 |


CODE_809B11:
  PLA                                       ; $809B11 |
  JSL.L CODE_FL_809B17                      ; $809B12 |
  RTS                                       ; $809B16 |


CODE_FL_809B17:
  INC.W $7C5C                               ; $809B17 |
  LDA.W $7C26                               ; $809B1A |
  STA.W $7C22                               ; $809B1D |
  LDA.W $7C28                               ; $809B20 |
  STA.W $7C24                               ; $809B23 |
  STZ.W $7C36                               ; $809B26 |
  STZ.W $7C0E                               ; $809B29 |
  JML.L CODE_JL_809B30                      ; $809B2C |


CODE_JL_809B30:
  STZ.W $7C18                               ; $809B30 |
  JML.L CODE_JL_80AF25                      ; $809B33 |


CODE_FN_809B37:
  JSR.W CODE_FN_809AEE                      ; $809B37 |
  JSR.W CODE_FN_809B82                      ; $809B3A |
  BIT.W #$C0C0                              ; $809B3D |
  BEQ CODE_809B45                           ; $809B40 |
  STZ.W $7C0E                               ; $809B42 |

CODE_809B45:
  LDA.W $7C36                               ; $809B45 |
  BNE CODE_809B4B                           ; $809B48 |
  RTS                                       ; $809B4A |


CODE_809B4B:
  LDA.W $7C14                               ; $809B4B |
  BIT.W #$0002                              ; $809B4E |
  BNE CODE_809B62                           ; $809B51 |
  LDA.W $7C1C                               ; $809B53 |
  BEQ CODE_809B62                           ; $809B56 |
  JSR.W CODE_FN_809BA9                      ; $809B58 |
  BIT.W #$8000                              ; $809B5B |
  BNE CODE_809B6C                           ; $809B5E |
  PLA                                       ; $809B60 |
  RTL                                       ; $809B61 |


CODE_809B62:
  LDA.W $7C0E                               ; $809B62 |
  BEQ CODE_809B6C                           ; $809B65 |
  DEC.W $7C0E                               ; $809B67 |
  PLA                                       ; $809B6A |
  RTL                                       ; $809B6B |


CODE_809B6C:
  LDA.W $7C36                               ; $809B6C |
  CMP.W #$0002                              ; $809B6F |
  BNE CODE_809B7B                           ; $809B72 |
  LDA.W #$0019                              ; $809B74 |
  JSL.L put_char                            ; $809B77 |

CODE_809B7B:
  STZ.W $7C36                               ; $809B7B |
  STZ.W $7C0E                               ; $809B7E |
  RTS                                       ; $809B81 |


CODE_FN_809B82:
  LDA.W $7C14                               ; $809B82 |
  BIT.W #$0002                              ; $809B85 |
  BNE CODE_809BA5                           ; $809B88 |
  LDA.W $7C1C                               ; $809B8A |
  BEQ CODE_809BA5                           ; $809B8D |
  DEC A                                     ; $809B8F |

  BNE CODE_809B98                           ; $809B90 |
  LDA.B $28                                 ; $809B92 |
  AND.W $7C38                               ; $809B94 |
  RTS                                       ; $809B97 |


CODE_809B98:
  DEC A                                     ; $809B98 |
  BNE CODE_809BA1                           ; $809B99 |
  LDA.B $2A                                 ; $809B9B |
  AND.W $7C38                               ; $809B9D |
  RTS                                       ; $809BA0 |


CODE_809BA1:
  LDA.B $28                                 ; $809BA1 |
  ORA.B $2A                                 ; $809BA3 |

CODE_809BA5:
  AND.W $7C38                               ; $809BA5 |
  RTS                                       ; $809BA8 |


CODE_FN_809BA9:
  LDA.W $7C14                               ; $809BA9 |
  BIT.W #$0002                              ; $809BAC |
  BNE CODE_809BA5                           ; $809BAF |
  LDA.W $7C1C                               ; $809BB1 |
  BEQ CODE_809BA5                           ; $809BB4 |
  DEC A                                     ; $809BB6 |
  BNE CODE_809BBF                           ; $809BB7 |
  LDA.B $30                                 ; $809BB9 |
  AND.W $7C38                               ; $809BBB |
  RTS                                       ; $809BBE |


CODE_809BBF:
  DEC A                                     ; $809BBF |
  BNE CODE_809BC8                           ; $809BC0 |
  LDA.B $32                                 ; $809BC2 |
  AND.W $7C38                               ; $809BC4 |
  RTS                                       ; $809BC7 |


CODE_809BC8:
  LDA.B $30                                 ; $809BC8 |
  ORA.B $32                                 ; $809BCA |
  AND.W $7C38                               ; $809BCC |
  RTS                                       ; $809BCF |


CODE_JP_809BD0:
  TSC                                       ; $809BD0 |
  STA.W $7C32                               ; $809BD1 |
  LDA.W #$FFFF                              ; $809BD4 |
  STA.W $7C38                               ; $809BD7 |
  LDA.W $7C0C                               ; $809BDA |
  STA.W $7C0E                               ; $809BDD |
  STZ.W $7C20                               ; $809BE0 |
  LDA.W $7C4E                               ; $809BE3 |
  LSR A                                     ; $809BE6 |
  BEQ CODE_809BF1                           ; $809BE7 |
  LDA.W #$000A                              ; $809BE9 |
  LDY.W $DA06                               ; $809BEC |
  BEQ CODE_809C01                           ; $809BEF |

CODE_809BF1:
  JSR.W CODE_FN_809B82                      ; $809BF1 |
  LDY.W #$0006                              ; $809BF4 |
  BIT.W #$C0C0                              ; $809BF7 |
  BNE CODE_809BFF                           ; $809BFA |
  LDY.W $7C10                               ; $809BFC |

CODE_809BFF:
  TYA                                       ; $809BFF |
  DEC A                                     ; $809C00 |

CODE_809C01:
  STA.B $02                                 ; $809C01 |

CODE_JP_809C03:
  JSL.L get_next_char                       ; $809C03 |
  AND.W #$00FF                              ; $809C07 |
  BNE CODE_809C0F                           ; $809C0A |
  JMP.W CODE_JL_809B30                      ; $809C0C |


CODE_809C0F:
  CMP.W #$0018                              ; $809C0F |
  BCS CODE_809C17                           ; $809C12 |
  JMP.W CODE_JP_809DBE                      ; $809C14 |


CODE_809C17:
  CMP.W #$00B0                              ; $809C17 |
  BCC CODE_809C1F                           ; $809C1A |
  JMP.W CODE_JP_809D9B                      ; $809C1C |


CODE_809C1F:
  JSR.W CODE_FN_809AC6                      ; $809C1F |
  PHA                                       ; $809C22 |
  LDA.W $7C4E                               ; $809C23 |
  LSR A                                     ; $809C26 |
  BEQ CODE_809C2E                           ; $809C27 |
  LDA.W $DA06                               ; $809C29 |
  BEQ CODE_809C36                           ; $809C2C |

CODE_809C2E:
  LDA.W $7C3A                               ; $809C2E |
  BNE CODE_809C36                           ; $809C31 |
  INC.W $7C34                               ; $809C33 |

CODE_809C36:
  PLA                                       ; $809C36 |
  JSL.L put_char                            ; $809C37 |

CODE_JP_809C3B:
  JSL.L CODE_FL_809D4F                      ; $809C3B |

CODE_JP_809C3F:
  BCC CODE_809C4D                           ; $809C3F |
  LDA.W $7C3A                               ; $809C41 |
  BEQ CODE_809C49                           ; $809C44 |
  JMP.W CODE_JP_809FEA                      ; $809C46 |


CODE_809C49:
  JML.L CODE_JL_80B022                      ; $809C49 |


CODE_809C4D:
  BIT.B $02                                 ; $809C4D |
  BPL CODE_JP_809C03                        ; $809C4F |
  RTL                                       ; $809C51 |


CODE_FL_809C52:
  PHB                                       ; $809C52 |
  PHA                                       ; $809C53 |
  PHX                                       ; $809C54 |
  PHY                                       ; $809C55 |
  PEA.W $7E00                               ; $809C56 |
  PLB                                       ; $809C59 |
  PLB                                       ; $809C5A |
  JSL.L put_char                            ; $809C5B |
  PLY                                       ; $809C5F |
  PLX                                       ; $809C60 |
  PLA                                       ; $809C61 |
  PLB                                       ; $809C62 |
  RTL                                       ; $809C63 |


put_char:
  STA.B $06                                 ; $809C64 |
  CMP.W #$0018                              ; $809C66 |
  BNE .CODE_809C6E                          ; $809C69 |
  JMP.W .CODE_JP_809D18                     ; $809C6B |


.CODE_809C6E
  JSR.W CODE_FN_809D1B                      ; $809C6E |
  DEC.B $02                                 ; $809C71 |
  LDA.W $7C2E                               ; $809C73 |
  BNE .CODE_809C9F                          ; $809C76 |
  LDA.W #$0006                              ; $809C78 |
  STA.W $0009,X                             ; $809C7B |
  LDY.B $06                                 ; $809C7E |
  LDA.W #$0310                              ; $809C80 |
  CPY.W #$0088                              ; $809C83 |
  BCC .CODE_809C93                          ; $809C86 |
  LDA.W #$039E                              ; $809C88 |
  CPY.W #$00A8                              ; $809C8B |
  BCC .CODE_809C93                          ; $809C8E |
  LDA.W #$039D                              ; $809C90 |

.CODE_809C93
  TXY                                       ; $809C93 |
  AND.W #$E3FF                              ; $809C94 |
  ORA.W $7C30                               ; $809C97 |
  JSL.L CODE_FL_809658                      ; $809C9A |
  TYX                                       ; $809C9E |

.CODE_809C9F
  LDA.B $06                                 ; $809C9F |
  CMP.W #$0088                              ; $809CA1 |
  BCC .CODE_809CAE                          ; $809CA4 |
  TAX                                       ; $809CA6 |
  LDA.L UNREACH_818A81,X                    ; $809CA7 |
  AND.W #$00FF                              ; $809CAB |

.CODE_809CAE
  ASL A                                     ; $809CAE |
  ASL A                                     ; $809CAF |
  TAX                                       ; $809CB0 |
  LDA.L DATA8_8188E9,X                      ; $809CB1 |
  TXY                                       ; $809CB5 |
  AND.W #$E3FF                              ; $809CB6 |
  ORA.W $7C30                               ; $809CB9 |
  JSL.L CODE_FL_809658                      ; $809CBC |
  TYX                                       ; $809CC0 |
  LDA.L UNREACH_8188EB,X                    ; $809CC1 |
  TXY                                       ; $809CC5 |
  AND.W #$E3FF                              ; $809CC6 |
  ORA.W $7C30                               ; $809CC9 |
  JSL.L CODE_FL_809658                      ; $809CCC |
  TYX                                       ; $809CD0 |
  LDA.W $7C2E                               ; $809CD1 |
  BEQ .CODE_JP_809D18                       ; $809CD4 |
  LDY.B $06                                 ; $809CD6 |
  LDA.W #$0300                              ; $809CD8 |
  CPY.W #$0088                              ; $809CDB |
  BCC .CODE_JP_809D18                       ; $809CDE |
  LDA.W #$0200                              ; $809CE0 |
  CPY.W #$00A8                              ; $809CE3 |
  BCC .CODE_809CEB                          ; $809CE6 |
  LDA.W #$01F8                              ; $809CE8 |

.CODE_809CEB
  PHA                                       ; $809CEB |
  INC.W $7C22                               ; $809CEC |
  JSR.W CODE_FN_809D1B                      ; $809CEF |
  DEC.W $7C22                               ; $809CF2 |
  DEC.B $02                                 ; $809CF5 |
  PLX                                       ; $809CF7 |
  LDA.L DATA8_8188E9,X                      ; $809CF8 |
  TXY                                       ; $809CFC |
  AND.W #$E3FF                              ; $809CFD |
  ORA.W $7C30                               ; $809D00 |
  JSL.L CODE_FL_809658                      ; $809D03 |
  TYX                                       ; $809D07 |
  LDA.L UNREACH_8188EB,X                    ; $809D08 |
  TXY                                       ; $809D0C |
  AND.W #$E3FF                              ; $809D0D |
  ORA.W $7C30                               ; $809D10 |
  JSL.L CODE_FL_809658                      ; $809D13 |
  TYX                                       ; $809D17 |

.CODE_JP_809D18
  LDA.B $06                                 ; $809D18 |
  RTL                                       ; $809D1A |


CODE_FN_809D1B:
  JSR.W CODE_FN_809D2F                      ; $809D1B |
  TAY                                       ; $809D1E |
  LDX.W $0050                               ; $809D1F |
  PHX                                       ; $809D22 |
  JSL.L CODE_FL_80961D                      ; $809D23 |
  PLX                                       ; $809D27 |
  LDA.W #$0004                              ; $809D28 |
  STA.W $0009,X                             ; $809D2B |
  RTS                                       ; $809D2E |


CODE_FN_809D2F:
  CLC                                       ; $809D2F |
  LDA.W $7C24                               ; $809D30 |
  ASL A                                     ; $809D33 |
  ASL A                                     ; $809D34 |
  ASL A                                     ; $809D35 |
  ASL A                                     ; $809D36 |
  ASL A                                     ; $809D37 |
  ADC.W $7C22                               ; $809D38 |
  PHA                                       ; $809D3B |
  LDA.B !r_room_mode                        ; $809D3C |
  CMP.W #$0004                              ; $809D3E |
  BEQ CODE_809D49                           ; $809D41 |
  PLA                                       ; $809D43 |
  CLC                                       ; $809D44 |
  ADC.W #$5000                              ; $809D45 |
  RTS                                       ; $809D48 |


CODE_809D49:
  PLA                                       ; $809D49 |
  CLC                                       ; $809D4A |
  ADC.W #$4800                              ; $809D4B |
  RTS                                       ; $809D4E |


CODE_FL_809D4F:
  CMP.W #$0016                              ; $809D4F |
  BCC CODE_809D59                           ; $809D52 |
  CMP.W #$0018                              ; $809D54 |
  BCC CODE_809D7B                           ; $809D57 |

CODE_809D59:
  TAY                                       ; $809D59 |
  CLC                                       ; $809D5A |
  LDA.W $7C22                               ; $809D5B |
  ADC.W $7C2E                               ; $809D5E |
  INC A                                     ; $809D61 |
  SEC                                       ; $809D62 |
  SBC.W $7C26                               ; $809D63 |
  CMP.W $7C2A                               ; $809D66 |
  BCS CODE_FL_809D7D                        ; $809D69 |
  CPY.W #$0088                              ; $809D6B |
  BCC CODE_809D78                           ; $809D6E |
  LDA.W $7C2E                               ; $809D70 |
  BEQ CODE_809D78                           ; $809D73 |
  INC.W $7C22                               ; $809D75 |

CODE_809D78:
  INC.W $7C22                               ; $809D78 |

CODE_809D7B:
  CLC                                       ; $809D7B |
  RTL                                       ; $809D7C |


CODE_FL_809D7D:
  LDA.W $7C26                               ; $809D7D |
  STA.W $7C22                               ; $809D80 |
  LDA.W $7C2E                               ; $809D83 |
  EOR.W #$0001                              ; $809D86 |
  LSR A                                     ; $809D89 |
  LDA.W #$0002                              ; $809D8A |
  ADC.W $7C24                               ; $809D8D |
  STA.W $7C24                               ; $809D90 |
  SEC                                       ; $809D93 |
  SBC.W $7C28                               ; $809D94 |
  CMP.W $7C2C                               ; $809D97 |
  RTL                                       ; $809D9A |


CODE_JP_809D9B:
  PHX                                       ; $809D9B |
  ASL A                                     ; $809D9C |
  TAX                                       ; $809D9D |
  LDA.L PTR16_809DA8-($B0*2),X              ; $809D9E |
  PLX                                       ; $809DA2 |
  STA.B $00                                 ; $809DA3 |
  JMP.W ($0000)                             ; $809DA5 |

PTR16_809DA8:
  dw CODE_809F04                            ; $809DA8 | $B0
  dw CODE_809F77                            ; $809DAA | $B1
  dw CODE_80A935                            ; $809DAC | $B2
  dw CODE_80ABCD                            ; $809DAE | $B3
  dw CODE_80A011                            ; $809DB0 | $B4
  dw CODE_80A02A                            ; $809DB2 | $B5: one-byte selector
  dw CODE_80A04E                            ; $809DB4 | $B6
  dw CODE_80A1C2                            ; $809DB6 | $B7
  dw CODE_80A356                            ; $809DB8 | $B8
  dw CODE_80A35B                            ; $809DBA | $B9
  dw CODE_JP_80A344                         ; $809DBC | $BA

CODE_JP_809DBE:
  DEC A                                     ; $809DBE |
  PHX                                       ; $809DBF |
  ASL A                                     ; $809DC0 |
  TAX                                       ; $809DC1 |
  LDA.L PTR16_809DCC,X                      ; $809DC2 |
  PLX                                       ; $809DC6 |
  STA.B $00                                 ; $809DC7 |
  JMP.W ($0000)                             ; $809DC9 |

PTR16_809DCC:
  dw CODE_809E7F                            ; $809DCC |
  dw CODE_809E72                            ; $809DCE |
  dw CODE_809E7B                            ; $809DD0 |
  dw CODE_809EA9                            ; $809DD2 |
  dw CODE_809E89                            ; $809DD4 |
  dw CODE_809EA2                            ; $809DD6 |
  dw CODE_FL_809EBF                         ; $809DD8 |
  dw CODE_809EB5                            ; $809DDA |
  dw CODE_809E8D                            ; $809DDC |
  dw CODE_809EC9                            ; $809DDE |
  dw CODE_809ED2                            ; $809DE0 |
  dw CODE_809E09                            ; $809DE2 |
  dw CODE_809E20                            ; $809DE4 |
  dw CODE_809E2E                            ; $809DE6 |
  dw CODE_809DFA                            ; $809DE8 |
  dw CODE_809E3C                            ; $809DEA |
  dw CODE_809E44                            ; $809DEC |
  dw CODE_809E62                            ; $809DEE |
  dw CODE_809E6A                            ; $809DF0 |
  dw CODE_809E4C                            ; $809DF2 |
  dw CODE_809E54                            ; $809DF4 |
  dw CODE_809EF2                            ; $809DF6 |
  dw CODE_809EFB                            ; $809DF8 |

CODE_809DFA:
  JSR.W CODE_FN_809AD5                      ; $809DFA |
  LDY.W #$00D8                              ; $809DFD |
  JSL.L CODE_FL_808993                      ; $809E00 |
  LDA.W #$00B4                              ; $809E04 |
  BRA CODE_FL_809E15                        ; $809E07 |


CODE_809E09:
  LDA.W $7C76                               ; $809E09 |
  LDY.W $7C78                               ; $809E0C |

CODE_FL_809E0F:
  PHY                                       ; $809E0F |
  JSL.L CODE_FL_8089BD                      ; $809E10 |
  PLA                                       ; $809E14 |

CODE_FL_809E15:
  CLC                                       ; $809E15 |
  ADC.W $7C0E                               ; $809E16 |
  STA.W $7C0E                               ; $809E19 |
  STZ.W $7C38                               ; $809E1C |
  RTL                                       ; $809E1F |


CODE_809E20:
  LDA.W $7C80                               ; $809E20 |
  LDY.W $7C7E                               ; $809E23 |
  PHA                                       ; $809E26 |
  JSL.L CODE_FL_808993                      ; $809E27 |
  PLA                                       ; $809E2B |
  BRA CODE_FL_809E15                        ; $809E2C |


CODE_809E2E:
  LDA.W $7C7E                               ; $809E2E |
  LDY.W $7C80                               ; $809E31 |

CODE_FL_809E34:
  PHY                                       ; $809E34 |
  JSL.L push_sound_queue                    ; $809E35 |
  PLA                                       ; $809E39 |
  BRA CODE_FL_809E15                        ; $809E3A |


CODE_809E3C:
  LDA.W #$0098                              ; $809E3C |
  LDY.W #$00B4                              ; $809E3F |
  BRA CODE_FL_809E0F                        ; $809E42 |


CODE_809E44:
  LDA.W #$0054                              ; $809E44 |
  LDY.W #$005A                              ; $809E47 |
  BRA CODE_FL_809E0F                        ; $809E4A |


CODE_809E4C:
  LDA.W #$00F8                              ; $809E4C |

  LDY.W #$0036                              ; $809E4F |
  BRA CODE_FL_809E0F                        ; $809E52 |


CODE_809E54:
  LDA.W #$0100                              ; $809E54 |
  STA.W $7C04                               ; $809E57 |
  LDA.W #$0000                              ; $809E5A |
  LDY.W #$005A                              ; $809E5D |
  BRA CODE_FL_809E0F                        ; $809E60 |


CODE_809E62:
  LDA.W #$00CC                              ; $809E62 |
  LDY.W #$0050                              ; $809E65 |
  BRA CODE_FL_809E0F                        ; $809E68 |


CODE_809E6A:
  LDA.W #$0015                              ; $809E6A |
  LDY.W #$0050                              ; $809E6D |
  BRA CODE_FL_809E34                        ; $809E70 |


CODE_809E72:
  LDA.W #$0001                              ; $809E72 |
  STA.W $7C60                               ; $809E75 |
  JMP.W CODE_JP_809C03                      ; $809E78 |


CODE_809E7B:
  JML.L CODE_JL_80B022                      ; $809E7B |


CODE_809E7F:
  JSL.L get_next_char                       ; $809E7F |
  AND.W #$00FF                              ; $809E83 |
  JMP.W CODE_JP_809C03                      ; $809E86 |


CODE_809E89:
  JML.L CODE_JL_80AD2D                      ; $809E89 |


CODE_809E8D:
  JSR.W CODE_FN_809AD5                      ; $809E8D |
  LDA.W #$0002                              ; $809E90 |
  STA.W $7C36                               ; $809E93 |
  LDA.W $7C12                               ; $809E96 |
  STA.W $7C0E                               ; $809E99 |
  LDA.W #$0009                              ; $809E9C |
  JMP.W put_char                            ; $809E9F |


CODE_809EA2:
  JSL.L CODE_FL_809D7D                      ; $809EA2 |
  JMP.W CODE_JP_809C3F                      ; $809EA6 |


CODE_809EA9:
  LDA.W $7C26                               ; $809EA9 |
  CMP.W $7C22                               ; $809EAC |
  BNE CODE_809EA2                           ; $809EAF |
  CLC                                       ; $809EB1 |
  JMP.W CODE_JP_809C3F                      ; $809EB2 |


CODE_809EB5:
  LDA.W $7C14                               ; $809EB5 |
  ORA.W #$0002                              ; $809EB8 |
  STA.W $7C14                               ; $809EBB |
  RTL                                       ; $809EBE |


CODE_FL_809EBF:
  LDA.W $7C14                               ; $809EBF |
  ORA.W #$0001                              ; $809EC2 |
  STA.W $7C14                               ; $809EC5 |
  RTL                                       ; $809EC8 |


CODE_809EC9:
  LDA.W #$0001                              ; $809EC9 |
  STA.W $7C74                               ; $809ECC |
  JMP.W CODE_JP_809C03                      ; $809ECF |


CODE_809ED2:
  JSR.W CODE_FN_809AD5                      ; $809ED2 |
  LDA.W #$0328                              ; $809ED5 |
  JSL.L CODE_FL_86C9D4                      ; $809ED8 |
  BCS CODE_809EED                           ; $809EDC |
  LDA.W #$0080                              ; $809EDE |
  STA.W $0009,Y                             ; $809EE1 |
  STA.W $000D,Y                             ; $809EE4 |
  LDA.W #$0042                              ; $809EE7 |
  JMP.W CODE_FL_809E15                      ; $809EEA |


CODE_809EED:
  JSL.L CODE_FL_80A60E                      ; $809EED |
  RTL                                       ; $809EF1 |


CODE_809EF2:
  LDA.W #$0004                              ; $809EF2 |
  JSR.W CODE_FN_80AB3B                      ; $809EF5 |
  JMP.W CODE_JP_809C3F                      ; $809EF8 |


CODE_809EFB:
  LDA.W #$0007                              ; $809EFB |
  JSR.W CODE_FN_80AB3B                      ; $809EFE |
  JMP.W CODE_JP_809C3F                      ; $809F01 |


CODE_809F04:
  LDA.W $7C3A                               ; $809F04 |
  BNE CODE_809F2A                           ; $809F07 |
  JSR.W CODE_FN_80A65B                      ; $809F09 |
  LDX.W $7C16                               ; $809F0C |
  BPL CODE_809F17                           ; $809F0F |
  LDA.L $BD0000,X                           ; $809F11 |
  BRA CODE_809F1B                           ; $809F15 |


CODE_809F17:
  LDA.L $B68000,X                           ; $809F17 |

CODE_809F1B:
  INX                                       ; $809F1B |
  INX                                       ; $809F1C |
  STX.W $7C16                               ; $809F1D |
  BCC CODE_809F27                           ; $809F20 |
  JSL.L set_text                            ; $809F22 |
  RTL                                       ; $809F26 |


CODE_809F27:
  JMP.W CODE_JP_809C03                      ; $809F27 |


CODE_809F2A:
  JSR.W CODE_FN_80A65B                      ; $809F2A |
  BCS CODE_809F74                           ; $809F2D |

CODE_809F2F:
  JSL.L get_next_char                       ; $809F2F |
  AND.W #$00FF                              ; $809F33 |
  CMP.W #$0016                              ; $809F36 |
  BCS CODE_809F3E                           ; $809F39 |
  JMP.W CODE_JP_80A465                      ; $809F3B |


CODE_809F3E:
  CMP.W #$00B0                              ; $809F3E |
  BNE CODE_809F46                           ; $809F41 |
  JMP.W CODE_JP_80A465                      ; $809F43 |


CODE_809F46:
  CMP.W #$00B1                              ; $809F46 |
  BNE CODE_809F4E                           ; $809F49 |
  JMP.W CODE_JP_80A465                      ; $809F4B |


CODE_809F4E:
  CMP.W #$00B8                              ; $809F4E |
  BEQ CODE_809F60                           ; $809F51 |
  CMP.W #$00B9                              ; $809F53 |
  BEQ CODE_809F60                           ; $809F56 |
  CMP.W #$00BA                              ; $809F58 |
  BCC CODE_809F2F                           ; $809F5B |
  JMP.W CODE_JP_80A344                      ; $809F5D |


CODE_809F60:
  LDX.W $7C16                               ; $809F60 |
  BPL CODE_809F6B                           ; $809F63 |
  LDA.L $BD0000,X                           ; $809F65 |
  BRA CODE_809F6F                           ; $809F69 |


CODE_809F6B:
  LDA.L $B68000,X                           ; $809F6B |

CODE_809F6F:
  INX                                       ; $809F6F |
  INX                                       ; $809F70 |
  STX.W $7C16                               ; $809F71 |

CODE_809F74:
  JMP.W CODE_JP_809C03                      ; $809F74 |


CODE_809F77:
  LDA.W $7C3A                               ; $809F77 |
  BNE CODE_809F2A                           ; $809F7A |
  JSR.W CODE_FN_80A65B                      ; $809F7C |
  LDX.W $7C16                               ; $809F7F |
  BPL CODE_809F8A                           ; $809F82 |
  LDA.L $BD0000,X                           ; $809F84 |
  BRA CODE_809F8E                           ; $809F88 |


CODE_809F8A:
  LDA.L $B68000,X                           ; $809F8A |

CODE_809F8E:
  INX                                       ; $809F8E |
  INX                                       ; $809F8F |
  STX.W $7C16                               ; $809F90 |
  BCS CODE_809F9A                           ; $809F93 |
  JSL.L set_text                            ; $809F95 |
  RTL                                       ; $809F99 |


CODE_809F9A:
  JMP.W CODE_JP_809C03                      ; $809F9A |

  JSR.W CODE_FN_80A65B                      ; $809F9D |
  BCC CODE_809FE7                           ; $809FA0 |

CODE_809FA2:
  JSL.L get_next_char                       ; $809FA2 |
  AND.W #$00FF                              ; $809FA6 |
  CMP.W #$0016                              ; $809FA9 |
  BCS CODE_809FB1                           ; $809FAC |
  JMP.W CODE_JP_80A465                      ; $809FAE |


CODE_809FB1:
  CMP.W #$00B0                              ; $809FB1 |
  BNE CODE_809FB9                           ; $809FB4 |
  JMP.W CODE_JP_80A465                      ; $809FB6 |


CODE_809FB9:
  CMP.W #$00B1                              ; $809FB9 |
  BNE CODE_809FC1                           ; $809FBC |
  JMP.W CODE_JP_80A465                      ; $809FBE |


CODE_809FC1:
  CMP.W #$00B8                              ; $809FC1 |
  BEQ CODE_809FD3                           ; $809FC4 |
  CMP.W #$00B9                              ; $809FC6 |
  BEQ CODE_809FD3                           ; $809FC9 |
  CMP.W #$00BA                              ; $809FCB |
  BCC CODE_809FA2                           ; $809FCE |
  JMP.W CODE_JP_80A344                      ; $809FD0 |


CODE_809FD3:
  LDX.W $7C16                               ; $809FD3 |
  BPL CODE_809FDE                           ; $809FD6 |
  LDA.L $BD0000,X                           ; $809FD8 |
  BRA CODE_809FE2                           ; $809FDC |


CODE_809FDE:
  LDA.L $B68000,X                           ; $809FDE |

CODE_809FE2:
  INX                                       ; $809FE2 |
  INX                                       ; $809FE3 |
  STX.W $7C16                               ; $809FE4 |

CODE_809FE7:
  JMP.W CODE_JP_809C03                      ; $809FE7 |


CODE_JP_809FEA:
  LDY.W #$8051                              ; $809FEA |
  BRA CODE_80A001                           ; $809FED |


CODE_JP_809FEF:
  LDY.W #$805E                              ; $809FEF |
  BRA CODE_80A001                           ; $809FF2 |


CODE_JP_809FF4:
  LDY.W #$8068                              ; $809FF4 |
  BRA CODE_80A001                           ; $809FF7 |


CODE_JP_809FF9:
  LDY.W #$8072                              ; $809FF9 |
  BRA CODE_80A001                           ; $809FFC |


CODE_JP_809FFE:
  LDY.W #$807C                              ; $809FFE |

CODE_80A001:
  LDA.W $7C32                               ; $80A001 |
  TCS                                       ; $80A004 |
  BIT.W $7C1E                               ; $80A005 |
  BMI CODE_80A00D                           ; $80A008 |
  JMP.W CODE_JL_809B30                      ; $80A00A |


CODE_80A00D:
  LDA.W #$FFFF                              ; $80A00D |
  RTL                                       ; $80A010 |


CODE_80A011:
  LDX.W $7C16                               ; $80A011 |
  BPL CODE_80A01C                           ; $80A014 |
  LDA.L $BD0000,X                           ; $80A016 |
  BRA CODE_80A020                           ; $80A01A |


CODE_80A01C:
  LDA.L $B68000,X                           ; $80A01C |

CODE_80A020:
  INX                                       ; $80A020 |
  INX                                       ; $80A021 |
  STX.W $7C16                               ; $80A022 |
  JSL.L set_text                            ; $80A025 |
  RTL                                       ; $80A029 |


CODE_80A02A:
  ; $B5 handler: consume one selector byte, not a 16-bit text pointer.
  STZ.W $7C52                               ; $80A02A |
  LDX.W $7C16                               ; $80A02D |
  TXA                                       ; $80A030 |
  BPL CODE_80A039                           ; $80A031 |
  LDA.L $BD0000,X                           ; $80A033 |
  BRA CODE_80A03D                           ; $80A037 |


CODE_80A039:
  LDA.L $B68000,X                           ; $80A039 |

CODE_80A03D:
  AND.W #$00FF                              ; $80A03D |
  INC.W $7C16                               ; $80A040 |
  LDY.W #$0002                              ; $80A043 |
  STY.W $7C4C                               ; $80A046 |
  CMP.W #$00FF                              ; $80A049 |
  BNE CODE_80A063                           ; $80A04C |

CODE_80A04E:
  STZ.W $7C52                               ; $80A04E |
  LDA.W #$0001                              ; $80A051 |
  STA.W $7C50                               ; $80A054 |

CODE_FL_80A057:
  BIT.W $7C5A                               ; $80A057 |
  BPL CODE_80A062                           ; $80A05A |
  LDA.W #$0001                              ; $80A05C |
  STA.W $7C4C                               ; $80A05F |

CODE_80A062:
  RTL                                       ; $80A062 |


CODE_80A063:
  STA.W $7C50                               ; $80A063 |
  CPY.W #$0001                              ; $80A066 |
  BNE CODE_80A06F                           ; $80A069 |
  JSL.L CODE_FL_80A057                      ; $80A06B |

CODE_80A06F:
  TAY                                       ; $80A06F |

  BNE CODE_80A078                           ; $80A070 |
  LDA.W #$0001                              ; $80A072 |
  STA.W $7C4C                               ; $80A075 |

CODE_80A078:
  LDX.W $7C16                               ; $80A078 |
  TXA                                       ; $80A07B |
  BPL CODE_80A084                           ; $80A07C |
  LDA.L $BD0000,X                           ; $80A07E |
  BRA CODE_80A088                           ; $80A082 |


CODE_80A084:
  LDA.L $B68000,X                           ; $80A084 |

CODE_80A088:
  AND.W #$00FF                              ; $80A088 |
  INC.W $7C16                               ; $80A08B |
  CMP.W #$00FF                              ; $80A08E |
  BNE CODE_80A096                           ; $80A091 |
  JMP.W CODE_JP_80A184                      ; $80A093 |


CODE_80A096:
  STA.W $7C4E                               ; $80A096 |
  JSL.L CODE_FL_809A7F                      ; $80A099 |

  LDA.W $7C50                               ; $80A09D |
  CMP.W #$0001                              ; $80A0A0 |
  BNE CODE_80A0AB                           ; $80A0A3 |
  LDA.W #$0001                              ; $80A0A5 |
  STA.W $7C4C                               ; $80A0A8 |

CODE_80A0AB:
  LDX.W $7C16                               ; $80A0AB |
  TXA                                       ; $80A0AE |

  BPL CODE_80A0B7                           ; $80A0AF |
  LDA.L $BD0000,X                           ; $80A0B1 |
  BRA CODE_80A0BB                           ; $80A0B5 |


CODE_80A0B7:
  LDA.L $B68000,X                           ; $80A0B7 |

CODE_80A0BB:
  AND.W #$00FF                              ; $80A0BB |
  INC.W $7C16                               ; $80A0BE |
  CMP.W #$00FF                              ; $80A0C1 |
  BNE CODE_80A0C9                           ; $80A0C4 |
  JMP.W CODE_JP_80A184                      ; $80A0C6 |


CODE_80A0C9:
  STA.B $04                                 ; $80A0C9 |
  ASL A                                     ; $80A0CB |
  LDY.W $7C2E                               ; $80A0CC |
  BNE CODE_80A0D3                           ; $80A0CF |
  ADC.B $04                                 ; $80A0D1 |

CODE_80A0D3:
  STA.W $7C2C                               ; $80A0D3 |
  JSR.W CODE_FN_80A185                      ; $80A0D6 |
  LDX.W $7C16                               ; $80A0D9 |
  TXA                                       ; $80A0DC |

  BPL CODE_80A0E5                           ; $80A0DD |
  LDA.L $BD0000,X                           ; $80A0DF |
  BRA CODE_80A0E9                           ; $80A0E3 |


CODE_80A0E5:
  LDA.L $B68000,X                           ; $80A0E5 |

CODE_80A0E9:
  AND.W #$00FF                              ; $80A0E9 |
  INC.W $7C16                               ; $80A0EC |
  CMP.W #$00FF                              ; $80A0EF |
  BNE CODE_80A0F7                           ; $80A0F2 |
  JMP.W CODE_JP_80A184                      ; $80A0F4 |


CODE_80A0F7:
  CLC                                       ; $80A0F7 |
  STA.W $7C54                               ; $80A0F8 |
  ADC.B $04                                 ; $80A0FB |
  STA.W $7C56                               ; $80A0FD |
  LDA.W $7C4E                               ; $80A100 |
  LSR A                                     ; $80A103 |
  BNE CODE_80A10F                           ; $80A104 |
  LDA.W $7C54                               ; $80A106 |

  LSR A                                     ; $80A109 |
  LSR A                                     ; $80A10A |

  LSR A                                     ; $80A10B |
  STA.W $7C28                               ; $80A10C |

CODE_80A10F:
  LDX.W $7C16                               ; $80A10F |
  TXA                                       ; $80A112 |
  BPL CODE_80A11B                           ; $80A113 |
  LDA.L $BD0000,X                           ; $80A115 |
  BRA CODE_80A11F                           ; $80A119 |


CODE_80A11B:
  LDA.L $B68000,X                           ; $80A11B |

CODE_80A11F:
  AND.W #$00FF                              ; $80A11F |
  INC.W $7C16                               ; $80A122 |
  CMP.W #$00FF                              ; $80A125 |
  BEQ CODE_JP_80A184                        ; $80A128 |
  STA.W $7C2A                               ; $80A12A |
  LDX.W $7C16                               ; $80A12D |
  TXA                                       ; $80A130 |
  BPL CODE_80A139                           ; $80A131 |
  LDA.L $BD0000,X                           ; $80A133 |
  BRA CODE_80A13D                           ; $80A137 |


CODE_80A139:
  LDA.L $B68000,X                           ; $80A139 |

CODE_80A13D:
  AND.W #$00FF                              ; $80A13D |
  INC.W $7C16                               ; $80A140 |
  CMP.W #$00FF                              ; $80A143 |
  BCS CODE_JP_80A184                        ; $80A146 |
  STA.W $7C26                               ; $80A148 |
  LDX.W $7C16                               ; $80A14B |
  TXA                                       ; $80A14E |
  BPL CODE_80A157                           ; $80A14F |
  LDA.L $BD0000,X                           ; $80A151 |
  BRA CODE_80A15B                           ; $80A155 |


CODE_80A157:
  LDA.L $B68000,X                           ; $80A157 |

CODE_80A15B:
  AND.W #$00FF                              ; $80A15B |
  INC.W $7C16                               ; $80A15E |
  CMP.W #$00FF                              ; $80A161 |
  BCS CODE_JP_80A184                        ; $80A164 |
  STA.W $7C58                               ; $80A166 |

CODE_80A169:
  LDX.W $7C16                               ; $80A169 |
  TXA                                       ; $80A16C |
  BPL CODE_80A175                           ; $80A16D |
  LDA.L $BD0000,X                           ; $80A16F |

  BRA CODE_80A179                           ; $80A173 |


CODE_80A175:
  LDA.L $B68000,X                           ; $80A175 |

CODE_80A179:
  AND.W #$00FF                              ; $80A179 |
  INC.W $7C16                               ; $80A17C |
  CMP.W #$00FF                              ; $80A17F |
  BNE CODE_80A169                           ; $80A182 |

CODE_JP_80A184:
  RTL                                       ; $80A184 |


CODE_FN_80A185:
  LDY.W $7C4E                               ; $80A185 |
  LDA.W $7C2C                               ; $80A188 |
  CPY.W #$0004                              ; $80A18B |
  BCC CODE_80A192                           ; $80A18E |
  INC A                                     ; $80A190 |
  INC A                                     ; $80A191 |

CODE_80A192:
  ASL A                                     ; $80A192 |
  ASL A                                     ; $80A193 |
  ASL A                                     ; $80A194 |
  STA.B $04                                 ; $80A195 |
  LDA.W #$0004                              ; $80A197 |
  CMP.W #$0004                              ; $80A19A |
  BMI CODE_80A1AF                           ; $80A19D |
  CLC                                       ; $80A19F |
  STA.W $7C54                               ; $80A1A0 |
  ADC.B $04                                 ; $80A1A3 |
  STA.W $7C56                               ; $80A1A5 |
  LDA.W #$0002                              ; $80A1A8 |
  STA.W $7C58                               ; $80A1AB |
  RTS                                       ; $80A1AE |


CODE_80A1AF:
  SEC                                       ; $80A1AF |
  LDA.W #$00B8                              ; $80A1B0 |
  STA.W $7C56                               ; $80A1B3 |
  SBC.B $04                                 ; $80A1B6 |
  STA.W $7C54                               ; $80A1B8 |
  LDA.W #$0001                              ; $80A1BB |
  STA.W $7C58                               ; $80A1BE |

  RTS                                       ; $80A1C1 |


CODE_80A1C2:
  JSR.W CODE_FN_809AD5                      ; $80A1C2 |
  LDX.W $7C16                               ; $80A1C5 |
  TXA                                       ; $80A1C8 |
  BPL CODE_80A1D1                           ; $80A1C9 |
  LDA.L $BD0000,X                           ; $80A1CB |
  BRA CODE_80A1D5                           ; $80A1CF |


CODE_80A1D1:
  LDA.L $B68000,X                           ; $80A1D1 |

CODE_80A1D5:
  AND.W #$00FF                              ; $80A1D5 |
  INC.W $7C16                               ; $80A1D8 |
  ORA.W #$0001                              ; $80A1DB |
  STA.W $7C3E                               ; $80A1DE |
  LDA.W #$0001                              ; $80A1E1 |
  STA.W $7C3A                               ; $80A1E4 |
  LDA.W $7C22                               ; $80A1E7 |
  CMP.W $7C26                               ; $80A1EA |
  BEQ CODE_80A1F8                           ; $80A1ED |
  JSL.L CODE_FL_809D7D                      ; $80A1EF |
  BCC CODE_80A1F8                           ; $80A1F3 |
  JMP.W CODE_JP_809FEF                      ; $80A1F5 |


CODE_80A1F8:
  STZ.W $7C40                               ; $80A1F8 |
  LDA.W $7C16                               ; $80A1FB |
  STA.W $7C3C                               ; $80A1FE |

  LDA.W $7C22                               ; $80A201 |
  STA.W $7C46                               ; $80A204 |
  LDA.W $7C24                               ; $80A207 |
  STA.W $7C48                               ; $80A20A |
  RTL                                       ; $80A20D |

  JML.L CODE_JL_80AD2D                      ; $80A20E |

  STZ.W $7C3A                               ; $80A212 |
  RTL                                       ; $80A215 |


CODE_JP_80A216:
  TSC                                       ; $80A216 |
  STA.W $7C32                               ; $80A217 |
  LDA.W $7C38                               ; $80A21A |
  INC A                                     ; $80A21D |
  BNE CODE_80A22B                           ; $80A21E |
  LDA.W $7C0E                               ; $80A220 |
  BEQ CODE_80A22B                           ; $80A223 |
  DEC.W $7C0E                               ; $80A225 |
  BEQ CODE_80A22B                           ; $80A228 |
  RTL                                       ; $80A22A |


CODE_80A22B:
  LDA.W #$FFFF                              ; $80A22B |
  STA.W $7C38                               ; $80A22E |
  STZ.W $7C0E                               ; $80A231 |
  LDA.W #$000A                              ; $80A234 |
  STA.B $02                                 ; $80A237 |
  LDA.W $7C3A                               ; $80A239 |
  PHX                                       ; $80A23C |
  ASL A                                     ; $80A23D |
  TAX                                       ; $80A23E |
  LDA.L PTR16_80A249,X                      ; $80A23F |
  PLX                                       ; $80A243 |
  STA.B $00                                 ; $80A244 |
  JMP.W ($0000)                             ; $80A246 |

PTR16_80A249:
  dw CODE_JP_809FEA                         ; $80A249 |
  dw CODE_80A3BC                            ; $80A24B |
  dw CODE_JP_809C03                         ; $80A24D |
  dw CODE_80A257                            ; $80A24F |
  dw CODE_JP_809C03                         ; $80A251 |
  dw CODE_80A283                            ; $80A253 |
  dw CODE_JP_809C03                         ; $80A255 |

CODE_80A257:
  LDA.W $7C40                               ; $80A257 |
  JSL.L CODE_FL_80A3DA                      ; $80A25A |
  BIT.W $7C40                               ; $80A25E |
  BPL CODE_80A266                           ; $80A261 |
  JMP.W CODE_JP_80A344                      ; $80A263 |


CODE_80A266:
  LDA.W #$0004                              ; $80A266 |
  STA.W $7C3A                               ; $80A269 |
  LDA.W #$0009                              ; $80A26C |
  JSL.L put_char                            ; $80A26F |
  LDA.W $7C3E                               ; $80A273 |
  LSR A                                     ; $80A276 |
  TAY                                       ; $80A277 |
  BNE CODE_80A27D                           ; $80A278 |
  JMP.W CODE_JP_80A3D3                      ; $80A27A |


CODE_80A27D:
  LDA.W #$0009                              ; $80A27D |
  JMP.W CODE_JP_809C3B                      ; $80A280 |


CODE_80A283:
  JSR.W CODE_FN_809BA9                      ; $80A283 |
  PHA                                       ; $80A286 |
  LDA.W $7C3E                               ; $80A287 |
  LSR A                                     ; $80A28A |
  PLA                                       ; $80A28B |
  STA.B $04                                 ; $80A28C |
  BIT.W #$8000                              ; $80A28E |
  BNE CODE_80A2EF                           ; $80A291 |
  LDY.W $7C40                               ; $80A293 |
  LDA.W $7C3E                               ; $80A296 |
  AND.W #$00FE                              ; $80A299 |
  TAX                                       ; $80A29C |
  LDA.L DATA8_818B31,X                      ; $80A29D |
  BIT.B $04                                 ; $80A2A1 |
  BEQ CODE_80A2A6                           ; $80A2A3 |
  DEY                                       ; $80A2A5 |

CODE_80A2A6:
  LDA.L DATA8_818B37,X                      ; $80A2A6 |
  BIT.B $04                                 ; $80A2AA |
  BEQ CODE_80A2AF                           ; $80A2AC |
  INY                                       ; $80A2AE |

CODE_80A2AF:
  CPY.W $7C40                               ; $80A2AF |
  BNE CODE_80A2B5                           ; $80A2B2 |
  RTL                                       ; $80A2B4 |


CODE_80A2B5:
  PHY                                       ; $80A2B5 |
  LDA.W $7C40                               ; $80A2B6 |
  JSL.L CODE_FL_80A3DA                      ; $80A2B9 |
  LDA.W #$0019                              ; $80A2BD |
  JSL.L put_char                            ; $80A2C0 |
  PLA                                       ; $80A2C4 |
  JSL.L CODE_FL_80A3DA                      ; $80A2C5 |
  LDA.W #$0009                              ; $80A2C9 |
  JSL.L put_char                            ; $80A2CC |
  LDY.W #$0046                              ; $80A2D0 |
  LDA.W #$0046                              ; $80A2D3 |
  JSL.L CODE_FL_809E34                      ; $80A2D6 |
  LDA.W $7C3E                               ; $80A2DA |
  LSR A                                     ; $80A2DD |
  BEQ CODE_80A2E3                           ; $80A2DE |
  JMP.W CODE_JP_80A3CC                      ; $80A2E0 |


CODE_80A2E3:
  LDA.W #$0006                              ; $80A2E3 |
  STA.W $7C3A                               ; $80A2E6 |
  LDA.W #$0009                              ; $80A2E9 |
  JMP.W CODE_JP_809C3B                      ; $80A2EC |


CODE_80A2EF:
  JSL.L CODE_FL_809EBF                      ; $80A2EF |

  LDA.W $7C44                               ; $80A2F3 |
  BNE CODE_80A302                           ; $80A2F6 |
  LDY.W #$0046                              ; $80A2F8 |

  LDA.W #$0047                              ; $80A2FB |
  JSL.L CODE_FL_809E34                      ; $80A2FE |

CODE_80A302:
  JSL.L CODE_FL_809EBF                      ; $80A302 |
  LDA.W $7C40                               ; $80A306 |
  JSL.L CODE_FL_80A3DA                      ; $80A309 |
  LDA.W $7C40                               ; $80A30D |
  INC A                                     ; $80A310 |
  STA.W $7C42                               ; $80A311 |

CODE_80A314:
  JSL.L get_next_char                       ; $80A314 |
  AND.W #$00FF                              ; $80A318 |
  CMP.W #$00B8                              ; $80A31B |
  BEQ CODE_80A325                           ; $80A31E |
  CMP.W #$00B9                              ; $80A320 |

  BNE CODE_80A314                           ; $80A323 |

CODE_80A325:
  LDX.W $7C16                               ; $80A325 |
  BPL CODE_80A330                           ; $80A328 |
  LDA.L $BD0000,X                           ; $80A32A |
  BRA CODE_80A334                           ; $80A32E |


CODE_80A330:
  LDA.L $B68000,X                           ; $80A330 |

CODE_80A334:
  INX                                       ; $80A334 |
  INX                                       ; $80A335 |
  STX.W $7C16                               ; $80A336 |

CODE_80A339:
  JSL.L set_text                            ; $80A339 |
  STZ.W $7C3A                               ; $80A33D |
  JML.L CODE_JL_80AD2D                      ; $80A340 |


CODE_JP_80A344:
  JSL.L CODE_FL_809EBF                      ; $80A344 |
  LDA.W #$FFFF                              ; $80A348 |
  STA.W $7C42                               ; $80A34B |
  JSL.L CODE_FL_80A3DA                      ; $80A34E |
  LDA.B $06                                 ; $80A352 |
  BRA CODE_80A339                           ; $80A354 |


CODE_80A356:
  STZ.W $7C44                               ; $80A356 |
  BRA CODE_80A361                           ; $80A359 |


CODE_80A35B:
  LDA.W #$0001                              ; $80A35B |

  STA.W $7C44                               ; $80A35E |

CODE_80A361:
  LDA.W #$000A                              ; $80A361 |
  STA.B $02                                 ; $80A364 |
  LDA.W $7C3A                               ; $80A366 |
  PHX                                       ; $80A369 |
  ASL A                                     ; $80A36A |
  TAX                                       ; $80A36B |
  LDA.L PTR16_80A376,X                      ; $80A36C |
  PLX                                       ; $80A370 |
  STA.B $00                                 ; $80A371 |
  JMP.W ($0000)                             ; $80A373 |

PTR16_80A376:
  dw CODE_JP_809FEA                         ; $80A376 |
  dw CODE_JP_809FEA                         ; $80A378 |
  dw CODE_80A384                            ; $80A37A |
  dw CODE_JP_809FEA                         ; $80A37C |
  dw CODE_JP_80A3D3                         ; $80A37E |
  dw CODE_JP_809FEA                         ; $80A380 |
  dw CODE_JP_80A3CC                         ; $80A382 |

CODE_80A384:
  LDX.W $7C16                               ; $80A384 |
  BPL CODE_80A38F                           ; $80A387 |
  LDA.L $BD0000,X                           ; $80A389 |
  BRA CODE_80A393                           ; $80A38D |


CODE_80A38F:
  LDA.L $B68000,X                           ; $80A38F |

CODE_80A393:
  INX                                       ; $80A393 |
  INX                                       ; $80A394 |
  STX.W $7C16                               ; $80A395 |
  JSL.L get_next_char                       ; $80A398 |
  AND.W #$00FF                              ; $80A39C |
  CMP.W #$00BA                              ; $80A39F |
  BEQ CODE_JP_80A3CC                        ; $80A3A2 |
  JSL.L CODE_FL_80A60E                      ; $80A3A4 |
  LDA.W $7C3E                               ; $80A3A8 |
  LSR A                                     ; $80A3AB |
  BEQ CODE_JP_80A3CC                        ; $80A3AC |
  CMP.W #$0002                              ; $80A3AE |
  BNE CODE_80A3BC                           ; $80A3B1 |
  JSL.L CODE_FL_809D7D                      ; $80A3B3 |
  BCC CODE_80A3BC                           ; $80A3B7 |
  JMP.W CODE_JP_809FEF                      ; $80A3B9 |


CODE_80A3BC:
  LDA.W #$0002                              ; $80A3BC |
  STA.W $7C3A                               ; $80A3BF |
  LDA.W #$0019                              ; $80A3C2 |
  JSL.L put_char                            ; $80A3C5 |
  JMP.W CODE_JP_809C3B                      ; $80A3C9 |


CODE_JP_80A3CC:
  LDA.W #$0003                              ; $80A3CC |
  STA.W $7C3A                               ; $80A3CF |

  RTL                                       ; $80A3D2 |


CODE_JP_80A3D3:
  LDA.W #$0005                              ; $80A3D3 |
  STA.W $7C3A                               ; $80A3D6 |
  RTL                                       ; $80A3D9 |


CODE_FL_80A3DA:
  STA.B $04                                 ; $80A3DA |
  LDA.W $7C3C                               ; $80A3DC |
  JSL.L set_text                            ; $80A3DF |
  JSR.W CODE_FN_80A49F                      ; $80A3E3 |
  LDA.W #$FFFF                              ; $80A3E6 |
  STA.W $7C40                               ; $80A3E9 |

CODE_JP_80A3EC:
  JSL.L get_next_char                       ; $80A3EC |
  AND.W #$00FF                              ; $80A3F0 |
  CMP.W #$00B0                              ; $80A3F3 |
  BNE CODE_80A402                           ; $80A3F6 |
  JSR.W CODE_FN_80A65B                      ; $80A3F8 |
  BCS CODE_80A400                           ; $80A3FB |
  JMP.W CODE_JP_80A4AC                      ; $80A3FD |


CODE_80A400:
  BRA CODE_80A40F                           ; $80A400 |


CODE_80A402:
  CMP.W #$00B1                              ; $80A402 |
  BNE CODE_80A416                           ; $80A405 |
  JSR.W CODE_FN_80A65B                      ; $80A407 |
  BCC CODE_80A40F                           ; $80A40A |
  JMP.W CODE_JP_80A4AC                      ; $80A40C |


CODE_80A40F:
  JSL.L get_next_char                       ; $80A40F |
  AND.W #$00FF                              ; $80A413 |

CODE_80A416:
  CMP.W #$0016                              ; $80A416 |
  BCC CODE_JP_80A465                        ; $80A419 |
  CMP.W #$00BA                              ; $80A41B |
  BCC CODE_80A423                           ; $80A41E |
  JMP.W CODE_JP_80A4F0                      ; $80A420 |


CODE_80A423:
  JSL.L CODE_FL_80A60E                      ; $80A423 |
  INC.W $7C40                               ; $80A427 |
  LDY.B $04                                 ; $80A42A |
  BNE CODE_80A431                           ; $80A42C |
  JMP.W CODE_FL_80A494                      ; $80A42E |


CODE_80A431:
  LDA.W #$0019                              ; $80A431 |
  JSL.L CODE_FL_809D4F                      ; $80A434 |
  BCS CODE_JP_80A465                        ; $80A438 |

CODE_80A43A:
  JSL.L get_next_char                       ; $80A43A |
  AND.W #$00FF                              ; $80A43E |
  CMP.W #$0016                              ; $80A441 |
  BCC CODE_JP_80A465                        ; $80A444 |
  CMP.W #$00B0                              ; $80A446 |
  BEQ CODE_JP_80A465                        ; $80A449 |
  CMP.W #$00B1                              ; $80A44B |
  BEQ CODE_JP_80A465                        ; $80A44E |
  CMP.W #$00B8                              ; $80A450 |
  BEQ CODE_80A468                           ; $80A453 |
  CMP.W #$00B9                              ; $80A455 |
  BEQ CODE_80A468                           ; $80A458 |
  CMP.W #$00BA                              ; $80A45A |
  BCS CODE_JP_80A465                        ; $80A45D |
  JSL.L CODE_FL_809D4F                      ; $80A45F |
  BCC CODE_80A43A                           ; $80A463 |

CODE_JP_80A465:
  JMP.W CODE_JP_809FEF                      ; $80A465 |


CODE_80A468:
  LDA.W $7C3E                               ; $80A468 |
  LSR A                                     ; $80A46B |
  CMP.W #$0002                              ; $80A46C |
  BNE CODE_80A477                           ; $80A46F |
  JSL.L CODE_FL_809D7D                      ; $80A471 |
  BCS CODE_JP_80A465                        ; $80A475 |

CODE_80A477:
  JSL.L CODE_FL_80A494                      ; $80A477 |
  LDX.W $7C16                               ; $80A47B |
  BPL CODE_80A486                           ; $80A47E |
  LDA.L $BD0000,X                           ; $80A480 |
  BRA CODE_80A48A                           ; $80A484 |


CODE_80A486:
  LDA.L $B68000,X                           ; $80A486 |

CODE_80A48A:
  INX                                       ; $80A48A |
  INX                                       ; $80A48B |
  STX.W $7C16                               ; $80A48C |
  DEC.B $04                                 ; $80A48F |
  JMP.W CODE_JP_80A3EC                      ; $80A491 |


CODE_FL_80A494:
  LDA.W $7C3E                               ; $80A494 |
  LSR A                                     ; $80A497 |
  BNE CODE_80A49D                           ; $80A498 |
  JSR.W CODE_FN_80A49F                      ; $80A49A |

CODE_80A49D:
  CLC                                       ; $80A49D |
  RTL                                       ; $80A49E |


CODE_FN_80A49F:
  LDA.W $7C46                               ; $80A49F |
  STA.W $7C22                               ; $80A4A2 |
  LDA.W $7C48                               ; $80A4A5 |
  STA.W $7C24                               ; $80A4A8 |
  RTS                                       ; $80A4AB |


CODE_JP_80A4AC:
  JSL.L get_next_char                       ; $80A4AC |
  AND.W #$00FF                              ; $80A4B0 |
  CMP.W #$0016                              ; $80A4B3 |
  BCC CODE_JP_80A465                        ; $80A4B6 |
  CMP.W #$00B0                              ; $80A4B8 |
  BEQ CODE_JP_80A465                        ; $80A4BB |
  CMP.W #$00B1                              ; $80A4BD |
  BEQ CODE_JP_80A465                        ; $80A4C0 |
  CMP.W #$00B8                              ; $80A4C2 |
  BNE CODE_80A4CA                           ; $80A4C5 |
  JMP.W CODE_JP_80A4D9                      ; $80A4C7 |


CODE_80A4CA:
  CMP.W #$00B9                              ; $80A4CA |
  BNE CODE_80A4D2                           ; $80A4CD |
  JMP.W CODE_JP_80A4D9                      ; $80A4CF |


CODE_80A4D2:
  CMP.W #$00BA                              ; $80A4D2 |
  BCC CODE_JP_80A4AC                        ; $80A4D5 |
  BRA CODE_JP_80A465                        ; $80A4D7 |


CODE_JP_80A4D9:
  LDX.W $7C16                               ; $80A4D9 |
  BPL CODE_80A4E4                           ; $80A4DC |
  LDA.L $BD0000,X                           ; $80A4DE |
  BRA CODE_80A4E8                           ; $80A4E2 |


CODE_80A4E4:
  LDA.L $B68000,X                           ; $80A4E4 |

CODE_80A4E8:
  INX                                       ; $80A4E8 |
  INX                                       ; $80A4E9 |
  STX.W $7C16                               ; $80A4EA |
  JMP.W CODE_JP_80A3EC                      ; $80A4ED |


CODE_JP_80A4F0:
  LDA.W $7C16                               ; $80A4F0 |
  STA.B $06                                 ; $80A4F3 |
  TDC                                       ; $80A4F5 |
  BIT.B $04                                 ; $80A4F6 |
  BPL CODE_80A4FF                           ; $80A4F8 |
  LDA.W $7C40                               ; $80A4FA |
  BMI CODE_FL_80A494                        ; $80A4FD |

CODE_80A4FF:
  JMP.W CODE_FL_80A3DA                      ; $80A4FF |


get_next_char:
  LDA.W !r_text_ptr_l                       ; $80A502 |
  STA.W $7C6A                               ; $80A505 |
  LDA.W !r_text_op_arg_l                    ; $80A508 |
  STA.W $7C6C                               ; $80A50B |
  LDA.W !r_text_token_l                     ; $80A50E |
  STA.W $7C6E                               ; $80A511 |
  CMP.W #$00F0                              ; $80A514 |
  BCC .below_f0                             ; $80A517 |
  JMP.W .dispatch_copy                      ; $80A519 |

.below_f0
  CMP.W #$00E0                              ; $80A51C |
  BCC .below_e0                             ; $80A51F |
  JMP.W .dispatch_repeat                    ; $80A521 |

.below_e0
  CMP.W #$00D0                              ; $80A524 |
  BCS .dispatch_dictionary                  ; $80A527 |
  CMP.W #$00C0                              ; $80A529 |
  BCC .read_next_token                      ; $80A52C |
  JMP.W .dispatch_repeated_space            ; $80A52E |

.read_next_token
  STZ.W !r_text_op_arg_l                    ; $80A531 |
  LDX.W !r_text_ptr_l                       ; $80A534 |
  TXA                                       ; $80A537 |
  BPL ..low_offset                          ; $80A538 |
  LDA.L $BD0000,X                           ; $80A53A |
  BRA ..loaded                              ; $80A53E |

..low_offset
  LDA.L $B68000,X                           ; $80A540 |

..loaded
  AND.W #$00FF                              ; $80A544 |
  STA.W !r_text_token_l                     ; $80A547 |
  INC.W !r_text_ptr_l                       ; $80A54A |
  CMP.W #$00F0                              ; $80A54D |
  BCS .read_copy_pointer                    ; $80A550 |
  CMP.W #$00E0                              ; $80A552 |
  BCC ..others                              ; $80A555 |
  JMP.W .read_repeated_char                 ; $80A557 |

..others
  CMP.W #$00C0                              ; $80A55A |
  BCS get_next_char                         ; $80A55D |
  RTL                                       ; $80A55F |

.read_copy_pointer
  LDX.W !r_text_ptr_l                       ; $80A560 |
  BPL ..low_offset                          ; $80A563 |
  LDA.L $BD0000,X                           ; $80A565 |
  BRA ..loaded                              ; $80A569 |

..low_offset
  LDA.L $B68000,X                           ; $80A56B |

..loaded
  AND.W #$FFFF                              ; $80A56F |
  STA.W !r_text_copy_ptr_l                  ; $80A572 |
  INC.W !r_text_ptr_l                       ; $80A575 |
  INC.W !r_text_ptr_l                       ; $80A578 |
  JMP.W get_next_char                       ; $80A57B |


.dispatch_dictionary
  SBC.W #$00D0                              ; $80A57E |
  ASL A                                     ; $80A581 |
  TAX                                       ; $80A582 |
  LDA.L dictionary_texts,X                  ; $80A583 |
  ADC.W !r_text_op_arg_l                    ; $80A587 |
  TAX                                       ; $80A58A |
  TXA                                       ; $80A58B |
  BPL ..low_offset                          ; $80A58C |
  LDA.L $BD0000,X                           ; $80A58E |
  BRA ..loaded                              ; $80A592 |

..low_offset
  LDA.L $B68000,X                           ; $80A594 |

..loaded
  AND.W #$00FF                              ; $80A598 |
  BNE ..return_char                         ; $80A59B |
  JMP.W .read_next_token                    ; $80A59D |

..return_char
  INC.W !r_text_op_arg_l                    ; $80A5A0 |
  RTL                                       ; $80A5A3 |


.dispatch_copy
  SBC.W #$00EC                              ; $80A5A4 |
  CLC                                       ; $80A5A7 |
  SBC.W !r_text_op_arg_l                    ; $80A5A8 |
  BPL ..copy                                ; $80A5AB |
  JMP.W .read_next_token                    ; $80A5AD |

..copy
  CLC                                       ; $80A5B0 |
  LDA.W !r_text_copy_ptr_l                  ; $80A5B1 |
  ADC.W !r_text_op_arg_l                    ; $80A5B4 |
  TAX                                       ; $80A5B7 |
  TXA                                       ; $80A5B8 |
  BPL ..low_offset                          ; $80A5B9 |
  LDA.L $BD0000,X                           ; $80A5BB |
  BRA ..loaded                              ; $80A5BF |

..low_offset
  LDA.L $B68000,X                           ; $80A5C1 |

..loaded
  AND.W #$00FF                              ; $80A5C5 |
  INC.W !r_text_op_arg_l                    ; $80A5C8 |
  RTL                                       ; $80A5CB |


.dispatch_repeated_space
  SBC.W #$00BE                              ; $80A5CC |
  CLC                                       ; $80A5CF |
  SBC.W !r_text_op_arg_l                    ; $80A5D0 |
  BPL ..return_char                         ; $80A5D3 |
  JMP.W .read_next_token                    ; $80A5D5 |

..return_char
  LDA.W #$0018                              ; $80A5D8 |
  INC.W !r_text_op_arg_l                    ; $80A5DB |
  RTL                                       ; $80A5DE |


.read_repeated_char
  LDX.W !r_text_ptr_l                       ; $80A5DF |
  TXA                                       ; $80A5E2 |
  BPL ..low_offset                          ; $80A5E3 |
  LDA.L $BD0000,X                           ; $80A5E5 |
  BRA ..loaded                              ; $80A5E9 |

..low_offset
  LDA.L $B68000,X                           ; $80A5EB |

..loaded
  AND.W #$00FF                              ; $80A5EF |
  STA.W !r_text_repeat_char_l               ; $80A5F2 |
  INC.W !r_text_ptr_l                       ; $80A5F5 |
  BRL get_next_char                         ; $80A5F8 |


.dispatch_repeat
  SBC.W #$00DD                              ; $80A5FB |
  CLC                                       ; $80A5FE |
  SBC.W !r_text_op_arg_l                    ; $80A5FF |
  BPL ..return_char                         ; $80A602 |
  JMP.W .read_next_token                    ; $80A604 |

..return_char
  LDA.W !r_text_repeat_char_l               ; $80A607 |
  INC.W !r_text_op_arg_l                    ; $80A60A |
  RTL                                       ; $80A60D |


CODE_FL_80A60E:
  LDA.W $7C6A                               ; $80A60E |
  STA.W $7C16                               ; $80A611 |
  LDA.W $7C6C                               ; $80A614 |
  STA.W $7C64                               ; $80A617 |
  LDA.W $7C6E                               ; $80A61A |
  STA.W $7C62                               ; $80A61D |
  RTL                                       ; $80A620 |


set_text:
  STA.W $7C6A                               ; $80A621 |
  STA.W $7C16                               ; $80A624 |
  STZ.W $7C6C                               ; $80A627 |
  STZ.W $7C64                               ; $80A62A |
  STZ.W $7C6E                               ; $80A62D |
  STZ.W $7C62                               ; $80A630 |
  RTL                                       ; $80A633 |


CODE_FL_80A634:
  PHB                                       ; $80A634 |
  PHX                                       ; $80A635 |
  PHY                                       ; $80A636 |
  PEA.W $7E00                               ; $80A637 |
  PLB                                       ; $80A63A |
  PLB                                       ; $80A63B |
  PHA                                       ; $80A63C |
  LDA.W #$FFFF                              ; $80A63D |
  STA.W $7C1E                               ; $80A640 |
  PLA                                       ; $80A643 |
  JSL.L CODE_FL_80A64F                      ; $80A644 |
  PLY                                       ; $80A648 |
  PLX                                       ; $80A649 |
  PLB                                       ; $80A64A |
  AND.W #$FFFF                              ; $80A64B |
  RTL                                       ; $80A64E |


CODE_FL_80A64F:
  TAY                                       ; $80A64F |
  TSC                                       ; $80A650 |
  STA.L $7E7C32                             ; $80A651 |
  TYA                                       ; $80A655 |
  JSR.W CODE_FN_80A66F                      ; $80A656 |
  TDC                                       ; $80A659 |
  RTL                                       ; $80A65A |


CODE_FN_80A65B:
  LDX.W $7C16                               ; $80A65B |
  BPL CODE_80A666                           ; $80A65E |
  LDA.L $BD0000,X                           ; $80A660 |
  BRA CODE_80A66A                           ; $80A664 |


CODE_80A666:
  LDA.L $B68000,X                           ; $80A666 |

CODE_80A66A:
  INX                                       ; $80A66A |
  INX                                       ; $80A66B |
  STX.W $7C16                               ; $80A66C |

CODE_FN_80A66F:
  CMP.W #$0400                              ; $80A66F |
  BCC CODE_80A6D4                           ; $80A672 |
  LDX.W #$0000                              ; $80A674 |
  CMP.W #$0500                              ; $80A677 |
  BCC CODE_80A6F7                           ; $80A67A |
  INX                                       ; $80A67C |
  INX                                       ; $80A67D |
  CMP.W #$0600                              ; $80A67E |
  BCC CODE_80A6F7                           ; $80A681 |
  INX                                       ; $80A683 |
  INX                                       ; $80A684 |
  CMP.W #$0700                              ; $80A685 |
  BCC CODE_80A6F7                           ; $80A688 |
  INX                                       ; $80A68A |
  INX                                       ; $80A68B |
  CMP.W #$0800                              ; $80A68C |
  BCC CODE_80A6F7                           ; $80A68F |
  CMP.W #$0900                              ; $80A691 |
  BCS CODE_80A699                           ; $80A694 |
  JMP.W CODE_JP_80A7EE                      ; $80A696 |


CODE_80A699:
  CMP.W #$0A00                              ; $80A699 |
  BCS CODE_80A6A1                           ; $80A69C |
  JMP.W CODE_JP_80A7F8                      ; $80A69E |


CODE_80A6A1:
  CMP.W #$0B00                              ; $80A6A1 |
  BCS CODE_80A6A9                           ; $80A6A4 |
  JMP.W CODE_JP_80A81C                      ; $80A6A6 |


CODE_80A6A9:
  CMP.W #$0C00                              ; $80A6A9 |
  BCS CODE_80A6B1                           ; $80A6AC |
  JMP.W CODE_JP_80A802                      ; $80A6AE |


CODE_80A6B1:
  CMP.W #$1000                              ; $80A6B1 |
  BCS CODE_80A6B9                           ; $80A6B4 |
  JMP.W CODE_JP_80A80E                      ; $80A6B6 |


CODE_80A6B9:
  CMP.W #$1400                              ; $80A6B9 |
  BCS CODE_80A6C1                           ; $80A6BC |
  JMP.W CODE_JP_809FF4                      ; $80A6BE |


CODE_80A6C1:
  CMP.W #$8000                              ; $80A6C1 |
  BCS CODE_80A6C9                           ; $80A6C4 |
  JMP.W CODE_JP_80A84F                      ; $80A6C6 |


CODE_80A6C9:
  CMP.W #$9000                              ; $80A6C9 |
  BCS CODE_80A6D1                           ; $80A6CC |
  JMP.W CODE_JP_80A868                      ; $80A6CE |


CODE_80A6D1:
  JMP.W CODE_JP_80A8C9                      ; $80A6D1 |


CODE_80A6D4:
  TAY                                       ; $80A6D4 |
  LSR A                                     ; $80A6D5 |
  LSR A                                     ; $80A6D6 |
  LSR A                                     ; $80A6D7 |
  PHA                                       ; $80A6D8 |
  TYA                                       ; $80A6D9 |
  AND.W #$0007                              ; $80A6DA |
  TAX                                       ; $80A6DD |
  LDA.L DATA8_80A6EF,X                      ; $80A6DE |
  PLX                                       ; $80A6E2 |
  AND.L $700210,X                           ; $80A6E3 |
  AND.W #$00FF                              ; $80A6E7 |
  CLC                                       ; $80A6EA |
  BEQ CODE_80A6EE                           ; $80A6EB |
  SEC                                       ; $80A6ED |

CODE_80A6EE:
  RTS                                       ; $80A6EE |


DATA8_80A6EF:
  db $01,$02,$04,$08,$10,$20,$40,$80        ; $80A6EF |

CODE_80A6F7:
  CLC                                       ; $80A6F7 |
  ADC.L DATA16_80A7A4,X                     ; $80A6F8 |
  TAY                                       ; $80A6FC |
  LDA.W #$0001                              ; $80A6FD |
  CPY.W #$0001                              ; $80A700 |
  BNE CODE_80A708                           ; $80A703 |
  JMP.W CODE_JP_80A86C                      ; $80A705 |


CODE_80A708:
  LDA.W #$0005                              ; $80A708 |
  CPY.W #$0002                              ; $80A70B |
  BNE CODE_80A713                           ; $80A70E |
  JMP.W CODE_JP_80A86C                      ; $80A710 |


CODE_80A713:
  LDA.W #$000A                              ; $80A713 |
  CPY.W #$0003                              ; $80A716 |
  BNE CODE_80A71E                           ; $80A719 |
  JMP.W CODE_JP_80A86C                      ; $80A71B |


CODE_80A71E:
  LDA.W #$0001                              ; $80A71E |
  LDX.W #$00A0                              ; $80A721 |
  CPY.W #$0201                              ; $80A724 |
  BNE CODE_80A72C                           ; $80A727 |
  JMP.W CODE_FN_80A7AC                      ; $80A729 |


CODE_80A72C:
  INC A                                     ; $80A72C |
  CPY.W #$0202                              ; $80A72D |
  BNE CODE_80A735                           ; $80A730 |
  JMP.W CODE_FN_80A7AC                      ; $80A732 |


CODE_80A735:
  INC A                                     ; $80A735 |
  CPY.W #$0203                              ; $80A736 |
  BNE CODE_80A73E                           ; $80A739 |
  JMP.W CODE_FN_80A7AC                      ; $80A73B |


CODE_80A73E:
  LDA.W #$0001                              ; $80A73E |
  CPY.W #$0204                              ; $80A741 |
  BNE CODE_80A749                           ; $80A744 |
  JMP.W CODE_JP_80A8DE                      ; $80A746 |


CODE_80A749:
  INC A                                     ; $80A749 |
  CPY.W #$0205                              ; $80A74A |
  BNE CODE_80A752                           ; $80A74D |
  JMP.W CODE_JP_80A8DE                      ; $80A74F |


CODE_80A752:
  INC A                                     ; $80A752 |
  CPY.W #$0206                              ; $80A753 |
  BNE CODE_80A75B                           ; $80A756 |
  JMP.W CODE_JP_80A8DE                      ; $80A758 |


CODE_80A75B:
  LDA.W #$0001                              ; $80A75B |
  CPY.W #$0207                              ; $80A75E |
  BNE CODE_80A766                           ; $80A761 |
  JMP.W CODE_JP_80A8D4                      ; $80A763 |


CODE_80A766:
  INC A                                     ; $80A766 |
  CPY.W #$0208                              ; $80A767 |

  BNE CODE_80A76F                           ; $80A76A |
  JMP.W CODE_JP_80A8D4                      ; $80A76C |


CODE_80A76F:
  INC A                                     ; $80A76F |
  CPY.W #$0209                              ; $80A770 |
  BNE CODE_80A778                           ; $80A773 |
  JMP.W CODE_JP_80A8D4                      ; $80A775 |


CODE_80A778:
  CPY.W #$0301                              ; $80A778 |
  BCS CODE_80A78F                           ; $80A77B |
  LDX.W #$00AA                              ; $80A77D |
  SEC                                       ; $80A780 |
  TYA                                       ; $80A781 |
  SBC.W #$0209                              ; $80A782 |

CODE_80A785:
  DEC A                                     ; $80A785 |
  BEQ CODE_80A7B5                           ; $80A786 |
  INX                                       ; $80A788 |
  INX                                       ; $80A789 |
  CPX.W #$00B6                              ; $80A78A |
  BCC CODE_80A785                           ; $80A78D |

CODE_80A78F:
  LDX.W #$00B6                              ; $80A78F |
  SEC                                       ; $80A792 |
  TYA                                       ; $80A793 |
  SBC.W #$0300                              ; $80A794 |

CODE_80A797:
  DEC A                                     ; $80A797 |
  BEQ CODE_80A7B5                           ; $80A798 |
  INX                                       ; $80A79A |
  INX                                       ; $80A79B |
  CPX.W #$00D9                              ; $80A79C |
  BCC CODE_80A797                           ; $80A79F |
  JMP.W CODE_JP_809FEF                      ; $80A7A1 |


DATA16_80A7A4:
  dw $FC00,$FC00,$FC00,$FC00                ; $80A7A4 |

CODE_FN_80A7AC:
  STA.B $04                                 ; $80A7AC |
  LDA.L $700200,X                           ; $80A7AE |
  CMP.B $04                                 ; $80A7B2 |
  RTS                                       ; $80A7B4 |


CODE_80A7B5:
  JSR.W CODE_FN_80A7AC                      ; $80A7B5 |
  SEC                                       ; $80A7B8 |
  AND.W #$FFFF                              ; $80A7B9 |
  BNE CODE_80A7BF                           ; $80A7BC |
  CLC                                       ; $80A7BE |

CODE_80A7BF:
  RTS                                       ; $80A7BF |


CODE_FN_80A7C0:
  STA.B $04                                 ; $80A7C0 |
  PHX                                       ; $80A7C2 |
  LDA.B $A0                                 ; $80A7C3 |
  ASL A                                     ; $80A7C5 |
  TAX                                       ; $80A7C6 |
  PLA                                       ; $80A7C7 |
  CLC                                       ; $80A7C8 |
  ADC.L DATA16_80A7E0,X                     ; $80A7C9 |
  TAX                                       ; $80A7CD |
  LDA.L $700200,X                           ; $80A7CE |
  CMP.B $04                                 ; $80A7D2 |
  RTS                                       ; $80A7D4 |


CODE_FN_80A7D5:
  JSR.W CODE_FN_80A7C0                      ; $80A7D5 |
  SEC                                       ; $80A7D8 |
  BIT.W #$FFFF                              ; $80A7D9 |
  BNE CODE_80A7DF                           ; $80A7DC |
  CLC                                       ; $80A7DE |

CODE_80A7DF:
  RTS                                       ; $80A7DF |


DATA16_80A7E0:
  dw $0148,$0198,$01E8,$0238                ; $80A7E0 |
  dw $0288,$02D8,$0328                      ; $80A7E8 |

CODE_JP_80A7EE:
  SEC                                       ; $80A7EE |
  SBC.W #$0800                              ; $80A7EF |
  CMP.B $C0                                 ; $80A7F2 |
  BEQ CODE_80A7F7                           ; $80A7F4 |
  CLC                                       ; $80A7F6 |

CODE_80A7F7:
  RTS                                       ; $80A7F7 |


CODE_JP_80A7F8:
  SEC                                       ; $80A7F8 |
  SBC.W #$0900                              ; $80A7F9 |
  CMP.B $A0                                 ; $80A7FC |
  BEQ CODE_80A801                           ; $80A7FE |
  CLC                                       ; $80A800 |

CODE_80A801:
  RTS                                       ; $80A801 |


CODE_JP_80A802:
  SEC                                       ; $80A802 |
  SBC.W #$0C00                              ; $80A803 |
  CMP.L $700758                             ; $80A806 |
  BEQ CODE_80A80D                           ; $80A80A |
  CLC                                       ; $80A80C |

CODE_80A80D:
  RTS                                       ; $80A80D |


CODE_JP_80A80E:
  SEC                                       ; $80A80E |
  SBC.W #$0B00                              ; $80A80F |
  ASL A                                     ; $80A812 |
  ASL A                                     ; $80A813 |
  XBA                                       ; $80A814 |
  CMP.W $7C30                               ; $80A815 |
  BEQ CODE_80A81B                           ; $80A818 |
  CLC                                       ; $80A81A |

CODE_80A81B:
  RTS                                       ; $80A81B |


CODE_JP_80A81C:
  SEC                                       ; $80A81C |
  SBC.W #$0A00                              ; $80A81D |
  TAY                                       ; $80A820 |
  LDA.W $7C1C                               ; $80A821 |
  BNE CODE_80A829                           ; $80A824 |
  LDA.W #$0003                              ; $80A826 |

CODE_80A829:
  LSR A                                     ; $80A829 |
  PHA                                       ; $80A82A |
  BCC CODE_80A83A                           ; $80A82B |
  LDA.W $0492                               ; $80A82D |
  AND.W #$0010                              ; $80A830 |
  BNE CODE_80A83A                           ; $80A833 |
  CPY.W $0418                               ; $80A835 |
  BEQ CODE_80A84D                           ; $80A838 |

CODE_80A83A:
  PLA                                       ; $80A83A |
  LSR A                                     ; $80A83B |
  PHA                                       ; $80A83C |
  BCC CODE_80A84C                           ; $80A83D |
  LDA.W $0552                               ; $80A83F |
  AND.W #$0010                              ; $80A842 |
  BNE CODE_80A84C                           ; $80A845 |
  CPY.W $04D8                               ; $80A847 |
  BEQ CODE_80A84D                           ; $80A84A |

CODE_80A84C:
  CLC                                       ; $80A84C |

CODE_80A84D:
  PLA                                       ; $80A84D |
  RTS                                       ; $80A84E |


CODE_JP_80A84F:
  SEC                                       ; $80A84F |
  SBC.W #$1000                              ; $80A850 |
  PHA                                       ; $80A853 |
  XBA                                       ; $80A854 |
  AND.W #$00FE                              ; $80A855 |
  TAY                                       ; $80A858 |
  PLA                                       ; $80A859 |
  AND.W #$01FF                              ; $80A85A |
  STA.B $04                                 ; $80A85D |
  LDA.W $7C00,Y                             ; $80A85F |
  CMP.B $04                                 ; $80A862 |
  BEQ CODE_80A867                           ; $80A864 |
  CLC                                       ; $80A866 |

CODE_80A867:
  RTS                                       ; $80A867 |


CODE_JP_80A868:
  SEC                                       ; $80A868 |
  SBC.W #$8000                              ; $80A869 |

CODE_JP_80A86C:
  JSL.L CODE_FL_80A877                      ; $80A86C |
  SED                                       ; $80A870 |
  LDA.B $BE                                 ; $80A871 |
  CMP.B $04                                 ; $80A873 |
  CLD                                       ; $80A875 |
  RTS                                       ; $80A876 |


CODE_FL_80A877:
  LDY.W #$03E8                              ; $80A877 |
  JSL.L CODE_FL_80A8AF                      ; $80A87A |
  XBA                                       ; $80A87E |
  ASL A                                     ; $80A87F |
  ASL A                                     ; $80A880 |
  ASL A                                     ; $80A881 |
  ASL A                                     ; $80A882 |
  STA.B $04                                 ; $80A883 |
  PHB                                       ; $80A885 |
  PEA.W $8181                               ; $80A886 |
  PLB                                       ; $80A889 |
  PLB                                       ; $80A88A |
  TYA                                       ; $80A88B |
  LDY.W #$0064                              ; $80A88C |
  JSL.L CODE_FL_808E65                      ; $80A88F |
  XBA                                       ; $80A893 |
  ORA.B $04                                 ; $80A894 |
  STA.B $04                                 ; $80A896 |
  TYA                                       ; $80A898 |
  LDY.W #$000A                              ; $80A899 |
  JSL.L CODE_FL_808E65                      ; $80A89C |
  ASL A                                     ; $80A8A0 |
  ASL A                                     ; $80A8A1 |
  ASL A                                     ; $80A8A2 |
  ASL A                                     ; $80A8A3 |
  ORA.B $04                                 ; $80A8A4 |
  STA.B $04                                 ; $80A8A6 |
  TYA                                       ; $80A8A8 |
  ORA.B $04                                 ; $80A8A9 |
  STA.B $04                                 ; $80A8AB |
  PLB                                       ; $80A8AD |
  RTL                                       ; $80A8AE |


CODE_FL_80A8AF:
  STA.B $02                                 ; $80A8AF |
  STY.B $04                                 ; $80A8B1 |
  LDY.W #$0010                              ; $80A8B3 |
  TDC                                       ; $80A8B6 |

CODE_80A8B7:
  ASL.B $02                                 ; $80A8B7 |
  ROL A                                     ; $80A8B9 |
  CMP.B $04                                 ; $80A8BA |
  BCC CODE_80A8C0                           ; $80A8BC |
  SBC.B $04                                 ; $80A8BE |

CODE_80A8C0:
  ROL.B $00                                 ; $80A8C0 |
  DEY                                       ; $80A8C2 |
  BNE CODE_80A8B7                           ; $80A8C3 |
  TAY                                       ; $80A8C5 |
  LDA.B $00                                 ; $80A8C6 |
  RTL                                       ; $80A8C8 |


CODE_JP_80A8C9:
  SEC                                       ; $80A8C9 |
  SBC.W #$9000                              ; $80A8CA |
  STA.B $04                                 ; $80A8CD |
  LDA.B $BA                                 ; $80A8CF |
  CMP.B $04                                 ; $80A8D1 |
  RTS                                       ; $80A8D3 |


CODE_JP_80A8D4:
  JSL.L CODE_FL_83D370                      ; $80A8D4 |
  RTS                                       ; $80A8D8 |


CODE_JP_80A8D9:
  JSL.L CODE_FL_83D342                      ; $80A8D9 |
  RTS                                       ; $80A8DD |


CODE_JP_80A8DE:
  JSL.L CODE_FL_83D32B                      ; $80A8DE |
  RTS                                       ; $80A8E2 |


CODE_JP_80A8E3:
  JSL.L CODE_FL_83D301                      ; $80A8E3 |
  RTS                                       ; $80A8E7 |


CODE_JP_80A8E8:
  JSL.L CODE_FL_83D1C9                      ; $80A8E8 |
  RTS                                       ; $80A8EC |


CODE_JP_80A8ED:
  JSL.L CODE_FL_868025                      ; $80A8ED |
  RTS                                       ; $80A8F1 |


CODE_JP_80A8F2:
  LDA.W #$000A                              ; $80A8F2 |

  JSL.L CODE_FL_83D25D                      ; $80A8F5 |
  RTS                                       ; $80A8F9 |


CODE_JP_80A8FA:
  JSL.L CODE_FL_83D2CA                      ; $80A8FA |
  RTS                                       ; $80A8FE |


CODE_JP_80A8FF:
  JSL.L CODE_FL_83D284                      ; $80A8FF |
  RTS                                       ; $80A903 |


CODE_JP_80A904:
  JSL.L CODE_FL_86807C                      ; $80A904 |
  RTS                                       ; $80A908 |


CODE_JP_80A909:
  JSL.L CODE_FL_8680A4                      ; $80A909 |
  RTS                                       ; $80A90D |


CODE_FL_80A90E:
  PHB                                       ; $80A90E |
  PHX                                       ; $80A90F |
  PHY                                       ; $80A910 |
  PEA.W $7E00                               ; $80A911 |
  PLB                                       ; $80A914 |
  PLB                                       ; $80A915 |
  PHA                                       ; $80A916 |
  LDA.W #$FFFF                              ; $80A917 |
  STA.W $7C1E                               ; $80A91A |
  PLA                                       ; $80A91D |
  JSL.L CODE_FL_80A929                      ; $80A91E |
  PLY                                       ; $80A922 |
  PLX                                       ; $80A923 |
  PLB                                       ; $80A924 |
  AND.W #$FFFF                              ; $80A925 |
  RTL                                       ; $80A928 |


CODE_FL_80A929:
  TAY                                       ; $80A929 |
  TSC                                       ; $80A92A |
  STA.L $7E7C32                             ; $80A92B |
  TYA                                       ; $80A92F |
  JSR.W CODE_FN_80A951                      ; $80A930 |
  TDC                                       ; $80A933 |
  RTL                                       ; $80A934 |


CODE_80A935:
  JSR.W CODE_FN_80A939                      ; $80A935 |
  RTL                                       ; $80A938 |


CODE_FN_80A939:
  JSL.L CODE_FL_809EBF                      ; $80A939 |
  LDX.W $7C16                               ; $80A93D |
  BPL CODE_80A948                           ; $80A940 |
  LDA.L $BD0000,X                           ; $80A942 |
  BRA CODE_80A94C                           ; $80A946 |


CODE_80A948:
  LDA.L $B68000,X                           ; $80A948 |

CODE_80A94C:
  INX                                       ; $80A94C |
  INX                                       ; $80A94D |
  STX.W $7C16                               ; $80A94E |

CODE_FN_80A951:
  CMP.W #$0400                              ; $80A951 |
  BCC CODE_80A9AE                           ; $80A954 |
  LDX.W #$0000                              ; $80A956 |
  CMP.W #$0500                              ; $80A959 |
  BCC CODE_80A9CA                           ; $80A95C |
  INX                                       ; $80A95E |
  INX                                       ; $80A95F |
  CMP.W #$0600                              ; $80A960 |
  BCC CODE_80A9CA                           ; $80A963 |
  INX                                       ; $80A965 |
  INX                                       ; $80A966 |
  CMP.W #$0700                              ; $80A967 |
  BCC CODE_80A9CA                           ; $80A96A |
  INX                                       ; $80A96C |
  INX                                       ; $80A96D |
  CMP.W #$0800                              ; $80A96E |
  BCC CODE_80A9CA                           ; $80A971 |
  CMP.W #$0900                              ; $80A973 |
  BCS CODE_80A97B                           ; $80A976 |
  JMP.W CODE_JP_809FF9                      ; $80A978 |


CODE_80A97B:
  CMP.W #$0A00                              ; $80A97B |
  BCS CODE_80A983                           ; $80A97E |
  JMP.W CODE_JP_809FF9                      ; $80A980 |


CODE_80A983:
  CMP.W #$0B00                              ; $80A983 |
  BCS CODE_80A98B                           ; $80A986 |
  JMP.W CODE_JP_809FF9                      ; $80A988 |


CODE_80A98B:
  CMP.W #$0C00                              ; $80A98B |
  BCS CODE_80A993                           ; $80A98E |
  JMP.W CODE_JP_80AB37                      ; $80A990 |


CODE_80A993:
  CMP.W #$1000                              ; $80A993 |
  BCS CODE_80A99B                           ; $80A996 |
  JMP.W CODE_JP_80A802                      ; $80A998 |


CODE_80A99B:
  CMP.W #$8000                              ; $80A99B |
  BCS CODE_80A9A3                           ; $80A99E |
  JMP.W CODE_JP_80AB42                      ; $80A9A0 |


CODE_80A9A3:
  CMP.W #$9000                              ; $80A9A3 |
  BCS CODE_80A9AB                           ; $80A9A6 |
  JMP.W CODE_JP_80AB8E                      ; $80A9A8 |


CODE_80A9AB:
  JMP.W CODE_JP_80AB9E                      ; $80A9AB |


CODE_80A9AE:
  TAY                                       ; $80A9AE |
  LSR A                                     ; $80A9AF |
  LSR A                                     ; $80A9B0 |
  LSR A                                     ; $80A9B1 |
  PHA                                       ; $80A9B2 |
  TYA                                       ; $80A9B3 |
  AND.W #$0007                              ; $80A9B4 |
  TAX                                       ; $80A9B7 |
  SEP #$20                                  ; $80A9B8 |
  LDA.L DATA8_80A6EF,X                      ; $80A9BA |
  PLX                                       ; $80A9BE |
  ORA.L $700210,X                           ; $80A9BF |
  STA.L $700210,X                           ; $80A9C3 |
  REP #$20                                  ; $80A9C7 |
  RTS                                       ; $80A9C9 |


CODE_80A9CA:
  CLC                                       ; $80A9CA |
  ADC.L DATA16_80A7A4,X                     ; $80A9CB |
  TAY                                       ; $80A9CF |
  LDA.W #$0001                              ; $80A9D0 |
  CPY.W #$0001                              ; $80A9D3 |
  BNE CODE_80A9DB                           ; $80A9D6 |
  JMP.W CODE_JP_80A8E8                      ; $80A9D8 |


CODE_80A9DB:
  LDA.W #$0005                              ; $80A9DB |
  CPY.W #$0002                              ; $80A9DE |
  BNE CODE_80A9E6                           ; $80A9E1 |
  JMP.W CODE_JP_80A8E8                      ; $80A9E3 |


CODE_80A9E6:
  LDA.W #$000A                              ; $80A9E6 |
  CPY.W #$0003                              ; $80A9E9 |
  BNE CODE_80A9F1                           ; $80A9EC |
  JMP.W CODE_JP_80A8E8                      ; $80A9EE |


CODE_80A9F1:
  CPY.W #$0004                              ; $80A9F1 |
  BNE CODE_80A9F9                           ; $80A9F4 |
  JMP.W CODE_JP_80A8ED                      ; $80A9F6 |


CODE_80A9F9:
  CPY.W #$0005                              ; $80A9F9 |
  BNE CODE_80AA01                           ; $80A9FC |
  JMP.W CODE_JP_80A8ED                      ; $80A9FE |


CODE_80AA01:
  LDA.W #$0002                              ; $80AA01 |
  CPY.W #$0006                              ; $80AA04 |
  BNE CODE_80AA0C                           ; $80AA07 |
  JMP.W CODE_FN_80AD07                      ; $80AA09 |


CODE_80AA0C:
  LDA.W #$0001                              ; $80AA0C |
  CPY.W #$0007                              ; $80AA0F |
  BNE CODE_80AA17                           ; $80AA12 |
  JMP.W CODE_JP_80A8F2                      ; $80AA14 |


CODE_80AA17:
  LDA.W #$0050                              ; $80AA17 |
  CPY.W #$0008                              ; $80AA1A |
  BNE CODE_80AA22                           ; $80AA1D |
  JMP.W CODE_JP_80A8FA                      ; $80AA1F |


CODE_80AA22:
  LDX.W #$0000                              ; $80AA22 |
  CPY.W #$0101                              ; $80AA25 |
  BNE CODE_80AA2D                           ; $80AA28 |
  JMP.W CODE_JP_80AB14                      ; $80AA2A |


CODE_80AA2D:
  LDX.W #$0001                              ; $80AA2D |
  CPY.W #$0102                              ; $80AA30 |
  BNE CODE_80AA38                           ; $80AA33 |
  JMP.W CODE_JP_80AB14                      ; $80AA35 |


CODE_80AA38:
  CPY.W #$0103                              ; $80AA38 |
  BNE CODE_80AA40                           ; $80AA3B |
  JMP.W CODE_JP_80A904                      ; $80AA3D |


CODE_80AA40:
  CPY.W #$0104                              ; $80AA40 |
  BNE CODE_80AA48                           ; $80AA43 |
  JMP.W CODE_JP_80A909                      ; $80AA45 |


CODE_80AA48:
  CPY.W #$0105                              ; $80AA48 |
  BNE CODE_80AA50                           ; $80AA4B |
  JMP.W CODE_JP_80A8FF                      ; $80AA4D |


CODE_80AA50:
  LDA.W #$0001                              ; $80AA50 |
  LDX.W #$00A0                              ; $80AA53 |
  CPY.W #$0201                              ; $80AA56 |
  BNE CODE_80AA5E                           ; $80AA59 |
  JMP.W CODE_JP_80AB05                      ; $80AA5B |


CODE_80AA5E:
  INC A                                     ; $80AA5E |
  CPY.W #$0202                              ; $80AA5F |
  BNE CODE_80AA67                           ; $80AA62 |
  JMP.W CODE_JP_80AB05                      ; $80AA64 |


CODE_80AA67:
  INC A                                     ; $80AA67 |
  CPY.W #$0203                              ; $80AA68 |
  BNE CODE_80AA70                           ; $80AA6B |
  JMP.W CODE_JP_80AB05                      ; $80AA6D |


CODE_80AA70:
  LDA.W #$0001                              ; $80AA70 |
  CPY.W #$0204                              ; $80AA73 |
  BNE CODE_80AA7B                           ; $80AA76 |
  JMP.W CODE_JP_80A8E3                      ; $80AA78 |


CODE_80AA7B:
  INC A                                     ; $80AA7B |
  CPY.W #$0205                              ; $80AA7C |
  BNE CODE_80AA84                           ; $80AA7F |
  JMP.W CODE_JP_80A8E3                      ; $80AA81 |


CODE_80AA84:
  INC A                                     ; $80AA84 |
  CPY.W #$0206                              ; $80AA85 |
  BNE CODE_80AA8D                           ; $80AA88 |
  JMP.W CODE_JP_80A8E3                      ; $80AA8A |


CODE_80AA8D:
  LDA.W #$0001                              ; $80AA8D |
  CPY.W #$0207                              ; $80AA90 |
  BNE CODE_80AA98                           ; $80AA93 |
  JMP.W CODE_JP_80A8D9                      ; $80AA95 |


CODE_80AA98:
  INC A                                     ; $80AA98 |
  CPY.W #$0208                              ; $80AA99 |
  BNE CODE_80AAA1                           ; $80AA9C |
  JMP.W CODE_JP_80A8D9                      ; $80AA9E |


CODE_80AAA1:
  INC A                                     ; $80AAA1 |
  CPY.W #$0209                              ; $80AAA2 |
  BNE CODE_80AAAA                           ; $80AAA5 |
  JMP.W CODE_JP_80A8D9                      ; $80AAA7 |


CODE_80AAAA:
  CPY.W #$020F                              ; $80AAAA |
  BNE CODE_80AAB2                           ; $80AAAD |
  JMP.W CODE_JP_80A8F2                      ; $80AAAF |


CODE_80AAB2:
  CPY.W #$0301                              ; $80AAB2 |
  BCS CODE_80AAE0                           ; $80AAB5 |
  LDX.W #$00AA                              ; $80AAB7 |
  SEC                                       ; $80AABA |
  TYA                                       ; $80AABB |
  SBC.W #$0209                              ; $80AABC |

CODE_80AABF:
  DEC A                                     ; $80AABF |
  BEQ CODE_JP_80AB02                        ; $80AAC0 |
  INX                                       ; $80AAC2 |
  INX                                       ; $80AAC3 |
  CPX.W #$00B5                              ; $80AAC4 |
  BCC CODE_80AABF                           ; $80AAC7 |
  LDA.W #$0050                              ; $80AAC9 |
  CPY.W #$0210                              ; $80AACC |
  BNE CODE_80AAD4                           ; $80AACF |
  JMP.W CODE_JP_80A8FA                      ; $80AAD1 |


CODE_80AAD4:
  LDA.L $7002E4                             ; $80AAD4 |
  CPY.W #$0211                              ; $80AAD8 |
  BNE CODE_80AAE0                           ; $80AADB |
  JMP.W CODE_JP_80A8FA                      ; $80AADD |


CODE_80AAE0:
  LDX.W #$00B6                              ; $80AAE0 |
  SEC                                       ; $80AAE3 |
  TYA                                       ; $80AAE4 |
  SBC.W #$0300                              ; $80AAE5 |

CODE_80AAE8:
  DEC A                                     ; $80AAE8 |
  BNE CODE_80AAEE                           ; $80AAE9 |
  JMP.W CODE_JP_80AB02                      ; $80AAEB |


CODE_80AAEE:
  INX                                       ; $80AAEE |
  INX                                       ; $80AAEF |
  CPX.W #$00DA                              ; $80AAF0 |
  BCC CODE_80AAE8                           ; $80AAF3 |
  JMP.W CODE_JP_809FEF                      ; $80AAF5 |

  CLC                                       ; $80AAF8 |
  ADC.L $700200,X                           ; $80AAF9 |
  STA.L $700200,X                           ; $80AAFD |
  RTS                                       ; $80AB01 |


CODE_JP_80AB02:
  LDA.W #$0001                              ; $80AB02 |

CODE_JP_80AB05:
  STA.L $700200,X                           ; $80AB05 |
  CPX.W #$00AA                              ; $80AB09 |
  BNE CODE_80AB12                           ; $80AB0C |
  JSL.L CODE_FL_83D23E                      ; $80AB0E |

CODE_80AB12:
  SEC                                       ; $80AB12 |
  RTS                                       ; $80AB13 |


CODE_JP_80AB14:
  STA.B $04                                 ; $80AB14 |
  PHX                                       ; $80AB16 |
  LDA.B $A0                                 ; $80AB17 |
  ASL A                                     ; $80AB19 |
  TAX                                       ; $80AB1A |
  PLA                                       ; $80AB1B |
  CLC                                       ; $80AB1C |
  ADC.L DATA16_80A7E0,X                     ; $80AB1D |
  TAX                                       ; $80AB21 |
  CLC                                       ; $80AB22 |
  LDA.L $700200,X                           ; $80AB23 |
  ADC.B $04                                 ; $80AB27 |
  STA.L $700200,X                           ; $80AB29 |
  RTS                                       ; $80AB2D |

  SEC                                       ; $80AB2E |
  SBC.W #$0C00                              ; $80AB2F |
  STA.L $700758                             ; $80AB32 |
  RTS                                       ; $80AB36 |


CODE_JP_80AB37:
  SEC                                       ; $80AB37 |
  SBC.W #$0B00                              ; $80AB38 |

CODE_FN_80AB3B:
  ASL A                                     ; $80AB3B |
  ASL A                                     ; $80AB3C |
  XBA                                       ; $80AB3D |
  STA.W $7C30                               ; $80AB3E |
  RTS                                       ; $80AB41 |


CODE_JP_80AB42:
  PLX                                       ; $80AB42 |
  SEC                                       ; $80AB43 |
  SBC.W #$1000                              ; $80AB44 |
  PHA                                       ; $80AB47 |
  XBA                                       ; $80AB48 |
  AND.W #$00FE                              ; $80AB49 |
  TAY                                       ; $80AB4C |
  PLA                                       ; $80AB4D |
  AND.W #$01FF                              ; $80AB4E |
  STA.W $7C00,Y                             ; $80AB51 |
  CPY.W #$0000                              ; $80AB54 |
  BEQ CODE_80AB7A                           ; $80AB57 |
  CPY.W #$0002                              ; $80AB59 |
  BEQ CODE_80AB6D                           ; $80AB5C |
  CPY.W #$000E                              ; $80AB5E |
  BNE CODE_80AB6C                           ; $80AB61 |
  STA.W $7C0E                               ; $80AB63 |
  LDA.W #$0001                              ; $80AB66 |
  STA.W $7C20                               ; $80AB69 |

CODE_80AB6C:
  RTL                                       ; $80AB6C |


CODE_80AB6D:
  LDA.W $7C02                               ; $80AB6D |
  STA.W $7C00                               ; $80AB70 |
  STZ.W $7C02                               ; $80AB73 |
  JML.L CODE_JL_80AF25                      ; $80AB76 |


CODE_80AB7A:
  LDA.W $7C00                               ; $80AB7A |
  STA.B $04                                 ; $80AB7D |
  STZ.W $7C00                               ; $80AB7F |
  JSR.W CODE_FN_809AC6                      ; $80AB82 |
  JSR.W CODE_FN_809AD5                      ; $80AB85 |
  LDA.B $04                                 ; $80AB88 |
  STA.W $7C00                               ; $80AB8A |
  RTL                                       ; $80AB8D |


CODE_JP_80AB8E:
  SEC                                       ; $80AB8E |
  SBC.W #$8000                              ; $80AB8F |
  JSL.L CODE_FL_80A877                      ; $80AB92 |
  SED                                       ; $80AB96 |
  CLC                                       ; $80AB97 |
  ADC.B $BE                                 ; $80AB98 |
  STA.B $BE                                 ; $80AB9A |
  CLD                                       ; $80AB9C |
  RTS                                       ; $80AB9D |


CODE_JP_80AB9E:
  SEC                                       ; $80AB9E |
  SBC.W #$9000                              ; $80AB9F |
  JSR.W CODE_FN_80AD07                      ; $80ABA2 |
  RTS                                       ; $80ABA5 |


CODE_FL_80ABA6:
  PHB                                       ; $80ABA6 |
  PHX                                       ; $80ABA7 |
  PHY                                       ; $80ABA8 |
  PEA.W $7E00                               ; $80ABA9 |
  PLB                                       ; $80ABAC |
  PLB                                       ; $80ABAD |
  PHA                                       ; $80ABAE |
  LDA.W #$FFFF                              ; $80ABAF |
  STA.W $7C1E                               ; $80ABB2 |
  PLA                                       ; $80ABB5 |
  JSL.L CODE_FL_80ABC1                      ; $80ABB6 |
  PLY                                       ; $80ABBA |
  PLX                                       ; $80ABBB |
  PLB                                       ; $80ABBC |
  AND.W #$FFFF                              ; $80ABBD |
  RTL                                       ; $80ABC0 |


CODE_FL_80ABC1:
  TAY                                       ; $80ABC1 |
  TSC                                       ; $80ABC2 |
  STA.L $7E7C32                             ; $80ABC3 |
  TYA                                       ; $80ABC7 |
  JSR.W CODE_FN_80ABE9                      ; $80ABC8 |
  TDC                                       ; $80ABCB |
  RTL                                       ; $80ABCC |


CODE_80ABCD:
  JSR.W CODE_FN_80ABD1                      ; $80ABCD |
  RTL                                       ; $80ABD0 |


CODE_FN_80ABD1:
  JSL.L CODE_FL_809EBF                      ; $80ABD1 |
  LDX.W $7C16                               ; $80ABD5 |
  BPL CODE_80ABE0                           ; $80ABD8 |
  LDA.L $BD0000,X                           ; $80ABDA |
  BRA CODE_80ABE4                           ; $80ABDE |


CODE_80ABE0:
  LDA.L $B68000,X                           ; $80ABE0 |

CODE_80ABE4:
  INX                                       ; $80ABE4 |
  INX                                       ; $80ABE5 |
  STX.W $7C16                               ; $80ABE6 |

CODE_FN_80ABE9:
  CMP.W #$0400                              ; $80ABE9 |
  BCC CODE_80AC3E                           ; $80ABEC |
  LDX.W #$0000                              ; $80ABEE |
  CMP.W #$0500                              ; $80ABF1 |
  BCC CODE_80AC5C                           ; $80ABF4 |
  INX                                       ; $80ABF6 |
  INX                                       ; $80ABF7 |

  CMP.W #$0600                              ; $80ABF8 |

  BCC CODE_80AC5C                           ; $80ABFB |
  INX                                       ; $80ABFD |
  INX                                       ; $80ABFE |
  CMP.W #$0700                              ; $80ABFF |
  BCC CODE_80AC5C                           ; $80AC02 |
  INX                                       ; $80AC04 |
  INX                                       ; $80AC05 |
  CMP.W #$0800                              ; $80AC06 |
  BCC CODE_80AC5C                           ; $80AC09 |
  CMP.W #$0900                              ; $80AC0B |
  BCS CODE_80AC13                           ; $80AC0E |
  JMP.W CODE_JP_809FFE                      ; $80AC10 |


CODE_80AC13:
  CMP.W #$0A00                              ; $80AC13 |
  BCS CODE_80AC1B                           ; $80AC16 |
  JMP.W CODE_JP_809FFE                      ; $80AC18 |


CODE_80AC1B:
  CMP.W #$0B00                              ; $80AC1B |
  BCS CODE_80AC23                           ; $80AC1E |
  JMP.W CODE_JP_809FFE                      ; $80AC20 |


CODE_80AC23:
  CMP.W #$1000                              ; $80AC23 |
  BCS CODE_80AC2B                           ; $80AC26 |
  JMP.W CODE_JP_809FFE                      ; $80AC28 |


CODE_80AC2B:
  CMP.W #$8000                              ; $80AC2B |
  BCS CODE_80AC33                           ; $80AC2E |
  JMP.W CODE_JP_809FFE                      ; $80AC30 |


CODE_80AC33:
  CMP.W #$9000                              ; $80AC33 |
  BCS CODE_80AC3B                           ; $80AC36 |
  JMP.W CODE_JP_80ACDC                      ; $80AC38 |


CODE_80AC3B:
  JMP.W CODE_JP_80ACFF                      ; $80AC3B |


CODE_80AC3E:
  TAY                                       ; $80AC3E |
  LSR A                                     ; $80AC3F |
  LSR A                                     ; $80AC40 |
  LSR A                                     ; $80AC41 |
  PHA                                       ; $80AC42 |
  TYA                                       ; $80AC43 |
  AND.W #$0007                              ; $80AC44 |
  TAX                                       ; $80AC47 |
  SEP #$20                                  ; $80AC48 |
  LDA.L DATA8_80A6EF,X                      ; $80AC4A |
  PLX                                       ; $80AC4E |
  EOR.B #$FF                                ; $80AC4F |
  AND.L $700210,X                           ; $80AC51 |
  STA.L $700210,X                           ; $80AC55 |

  REP #$20                                  ; $80AC59 |

  RTS                                       ; $80AC5B |


CODE_80AC5C:
  CLC                                       ; $80AC5C |
  ADC.L DATA16_80A7A4,X                     ; $80AC5D |
  TAY                                       ; $80AC61 |
  LDA.W #$0001                              ; $80AC62 |
  CPY.W #$0001                              ; $80AC65 |
  BNE CODE_80AC6D                           ; $80AC68 |
  JMP.W CODE_JP_80ACE0                      ; $80AC6A |


CODE_80AC6D:
  LDA.W #$0005                              ; $80AC6D |
  CPY.W #$0002                              ; $80AC70 |
  BNE CODE_80AC78                           ; $80AC73 |
  JMP.W CODE_JP_80ACE0                      ; $80AC75 |


CODE_80AC78:
  LDA.W #$000A                              ; $80AC78 |
  CPY.W #$0003                              ; $80AC7B |
  BNE CODE_80AC83                           ; $80AC7E |
  JMP.W CODE_JP_80ACE0                      ; $80AC80 |


CODE_80AC83:
  LDX.W #$00AA                              ; $80AC83 |
  SEC                                       ; $80AC86 |
  TYA                                       ; $80AC87 |
  SBC.W #$0209                              ; $80AC88 |

CODE_80AC8B:
  DEC A                                     ; $80AC8B |
  BEQ CODE_80ACBB                           ; $80AC8C |
  INX                                       ; $80AC8E |
  INX                                       ; $80AC8F |
  CPX.W #$00B6                              ; $80AC90 |
  BCC CODE_80AC8B                           ; $80AC93 |
  LDX.W #$00B6                              ; $80AC95 |
  SEC                                       ; $80AC98 |
  TYA                                       ; $80AC99 |
  SBC.W #$0300                              ; $80AC9A |

CODE_80AC9D:
  DEC A                                     ; $80AC9D |
  BEQ CODE_80ACBB                           ; $80AC9E |
  INX                                       ; $80ACA0 |
  INX                                       ; $80ACA1 |
  CPX.W #$00DA                              ; $80ACA2 |
  BCC CODE_80AC9D                           ; $80ACA5 |
  JMP.W CODE_JP_809FEF                      ; $80ACA7 |

  STA.B $04                                 ; $80ACAA |
  SEC                                       ; $80ACAC |
  LDA.L $700200,X                           ; $80ACAD |
  SBC.B $04                                 ; $80ACB1 |
  BPL CODE_80ACB6                           ; $80ACB3 |
  TDC                                       ; $80ACB5 |

CODE_80ACB6:
  STA.L $700200,X                           ; $80ACB6 |
  RTS                                       ; $80ACBA |


CODE_80ACBB:
  JSR.W CODE_FN_80A7D5                      ; $80ACBB |
  BCC CODE_80ACC5                           ; $80ACBE |
  TDC                                       ; $80ACC0 |
  STA.L $700200,X                           ; $80ACC1 |

CODE_80ACC5:
  RTS                                       ; $80ACC5 |

  JSR.W CODE_FN_80A7C0                      ; $80ACC6 |
  SBC.B $04                                 ; $80ACC9 |
  BPL CODE_80ACCE                           ; $80ACCB |
  TDC                                       ; $80ACCD |

CODE_80ACCE:
  STA.L $700200,X                           ; $80ACCE |
  RTS                                       ; $80ACD2 |

  JSR.W CODE_FN_80A7D5                      ; $80ACD3 |
  TDC                                       ; $80ACD6 |
  STA.L $700200,X                           ; $80ACD7 |
  RTS                                       ; $80ACDB |


CODE_JP_80ACDC:
  SEC                                       ; $80ACDC |
  SBC.W #$8000                              ; $80ACDD |

CODE_JP_80ACE0:
  JSL.L CODE_FL_80A877                      ; $80ACE0 |
  SEC                                       ; $80ACE4 |
  SED                                       ; $80ACE5 |
  LDA.B $BE                                 ; $80ACE6 |
  SBC.B $04                                 ; $80ACE8 |
  CLD                                       ; $80ACEA |
  BCS CODE_80ACEE                           ; $80ACEB |
  TDC                                       ; $80ACED |

CODE_80ACEE:
  STA.B $BE                                 ; $80ACEE |
  PHA                                       ; $80ACF0 |
  PHY                                       ; $80ACF1 |
  LDA.W #$0074                              ; $80ACF2 |
  LDY.W #$005A                              ; $80ACF5 |
  JSL.L CODE_FL_809E0F                      ; $80ACF8 |
  PLY                                       ; $80ACFC |
  PLA                                       ; $80ACFD |
  RTS                                       ; $80ACFE |


CODE_JP_80ACFF:
  SEC                                       ; $80ACFF |
  SBC.W #$9000                              ; $80AD00 |
  EOR.W #$FFFF                              ; $80AD03 |
  INC A                                     ; $80AD06 |

CODE_FN_80AD07:
  JSL.L CODE_FL_83D1E5                      ; $80AD07 |
  LDA.W #$0046                              ; $80AD0B |
  JSL.L CODE_FL_809E15                      ; $80AD0E |
  RTS                                       ; $80AD12 |


CODE_JL_80AD13:
  LDA.W $7C50                               ; $80AD13 |
  PHX                                       ; $80AD16 |
  ASL A                                     ; $80AD17 |
  TAX                                       ; $80AD18 |
  LDA.L PTR16_80AD23,X                      ; $80AD19 |
  PLX                                       ; $80AD1D |
  STA.B $00                                 ; $80AD1E |
  JMP.W ($0000)                             ; $80AD20 |

PTR16_80AD23:
  dw CODE_80AD3A                            ; $80AD23 |
  dw CODE_80AE44                            ; $80AD25 |
  dw CODE_80AE4C                            ; $80AD27 |
  dw CODE_80AF35                            ; $80AD29 |
  dw CODE_80B032                            ; $80AD2B |

CODE_JL_80AD2D:
  STZ.W $7C50                               ; $80AD2D |
  LDA.W #$0001                              ; $80AD30 |
  STA.W $7C4C                               ; $80AD33 |
  STZ.W $7C52                               ; $80AD36 |
  RTL                                       ; $80AD39 |


CODE_80AD3A:
  JSR.W CODE_FN_80AD41                      ; $80AD3A |
  STZ.W $7C4C                               ; $80AD3D |
  RTL                                       ; $80AD40 |


CODE_FN_80AD41:
  LDY.W $7C4C                               ; $80AD41 |
  DEY                                       ; $80AD44 |
  BEQ CODE_80AD48                           ; $80AD45 |
  RTS                                       ; $80AD47 |


CODE_80AD48:
  PLA                                       ; $80AD48 |
  LDA.W $7C60                               ; $80AD49 |
  BEQ CODE_FL_80AD56                        ; $80AD4C |
  JSL.L CODE_FL_80AD56                      ; $80AD4E |
  JSR.W CODE_FN_80AD41                      ; $80AD52 |
  RTL                                       ; $80AD55 |


CODE_FL_80AD56:
  LDA.W $7C52                               ; $80AD56 |
  PHX                                       ; $80AD59 |
  ASL A                                     ; $80AD5A |
  TAX                                       ; $80AD5B |
  LDA.L PTR16_80AD66,X                      ; $80AD5C |
  PLX                                       ; $80AD60 |
  STA.B $00                                 ; $80AD61 |
  JMP.W ($0000)                             ; $80AD63 |

PTR16_80AD66:
  dw CODE_80AD6C                            ; $80AD66 |
  dw CODE_80ADDB                            ; $80AD68 |
  dw CODE_80AE06                            ; $80AD6A |

CODE_80AD6C:
  STZ.W $7C5A                               ; $80AD6C |
  STZ.W $7C22                               ; $80AD6F |
  LDA.W $7C28                               ; $80AD72 |
  DEC A                                     ; $80AD75 |
  STA.W $7C24                               ; $80AD76 |
  LDA.W $7C4E                               ; $80AD79 |
  LSR A                                     ; $80AD7C |
  CMP.W #$0002                              ; $80AD7D |
  BCC CODE_80AD97                           ; $80AD80 |
  JSR.W CODE_FN_80ADC5                      ; $80AD82 |
  LDY.W #$13AD                              ; $80AD85 |
  JSR.W CODE_FN_80AD9E                      ; $80AD88 |
  LDA.W #$13AE                              ; $80AD8B |
  JSR.W CODE_FN_80ADB9                      ; $80AD8E |
  LDY.W #$53AD                              ; $80AD91 |
  JSR.W CODE_FN_80AD9E                      ; $80AD94 |

CODE_80AD97:
  INC.W $7C24                               ; $80AD97 |
  INC.W $7C52                               ; $80AD9A |
  RTL                                       ; $80AD9D |


CODE_FN_80AD9E:
  LDX.B $52                                 ; $80AD9E |
  LDA.W $7C4E                               ; $80ADA0 |
  LSR A                                     ; $80ADA3 |
  CMP.W #$0002                              ; $80ADA4 |
  BCS CODE_80ADAC                           ; $80ADA7 |
  LDY.W #$1310                              ; $80ADA9 |

CODE_80ADAC:
  TYA                                       ; $80ADAC |
  STA.L $7E0000,X                           ; $80ADAD |
  INX                                       ; $80ADB1 |
  INX                                       ; $80ADB2 |
  STX.B $52                                 ; $80ADB3 |
  LDY.W #$001E                              ; $80ADB5 |
  RTS                                       ; $80ADB8 |


CODE_FN_80ADB9:
  STA.L $7E0000,X                           ; $80ADB9 |
  INX                                       ; $80ADBD |
  INX                                       ; $80ADBE |
  DEY                                       ; $80ADBF |
  BNE CODE_FN_80ADB9                        ; $80ADC0 |
  STX.B $52                                 ; $80ADC2 |
  RTS                                       ; $80ADC4 |


CODE_FN_80ADC5:
  JSR.W CODE_FN_809D1B                      ; $80ADC5 |
  LDA.W #$0080                              ; $80ADC8 |
  STA.W $0000,X                             ; $80ADCB |
  LDA.W #$0040                              ; $80ADCE |
  STA.W $0009,X                             ; $80ADD1 |
  LDA.W $7C2A                               ; $80ADD4 |
  INC A                                     ; $80ADD7 |
  STA.B $04                                 ; $80ADD8 |
  RTS                                       ; $80ADDA |


CODE_80ADDB:
  JSR.W CODE_FN_80ADC5                      ; $80ADDB |
  JSR.W CODE_FN_80ADC5                      ; $80ADDE |
  LDY.W #$13AF                              ; $80ADE1 |
  JSR.W CODE_FN_80AD9E                      ; $80ADE4 |
  LDA.W #$1310                              ; $80ADE7 |
  JSR.W CODE_FN_80ADB9                      ; $80ADEA |
  LDY.W #$53AF                              ; $80ADED |
  JSR.W CODE_FN_80AD9E                      ; $80ADF0 |
  INC.W $7C24                               ; $80ADF3 |
  SEC                                       ; $80ADF6 |
  LDA.W $7C24                               ; $80ADF7 |
  SBC.W $7C28                               ; $80ADFA |
  CMP.W $7C2C                               ; $80ADFD |
  BMI CODE_80AE05                           ; $80AE00 |
  INC.W $7C52                               ; $80AE02 |

CODE_80AE05:
  RTL                                       ; $80AE05 |


CODE_80AE06:
  LDA.W $7C4E                               ; $80AE06 |
  LSR A                                     ; $80AE09 |
  BEQ CODE_80AE21                           ; $80AE0A |
  JSR.W CODE_FN_80ADC5                      ; $80AE0C |
  LDY.W #$93AD                              ; $80AE0F |
  JSR.W CODE_FN_80AD9E                      ; $80AE12 |
  LDA.W #$93AE                              ; $80AE15 |
  JSR.W CODE_FN_80ADB9                      ; $80AE18 |
  LDY.W #$D3AD                              ; $80AE1B |
  JSR.W CODE_FN_80AD9E                      ; $80AE1E |

CODE_80AE21:
  LDA.W $7C26                               ; $80AE21 |
  STA.W $7C22                               ; $80AE24 |
  LDA.W $7C28                               ; $80AE27 |
  STA.W $7C24                               ; $80AE2A |
  INC.W $7C4C                               ; $80AE2D |
  STZ.W $7C52                               ; $80AE30 |
  RTL                                       ; $80AE33 |


CODE_JL_80AE34:
  LDA.W #$0001                              ; $80AE34 |
  STA.W $7C50                               ; $80AE37 |
  LDA.W #$0002                              ; $80AE3A |
  STA.W $7C4C                               ; $80AE3D |
  STZ.W $7C52                               ; $80AE40 |
  RTL                                       ; $80AE43 |


CODE_80AE44:
  JSR.W CODE_FN_80AD41                      ; $80AE44 |
  LDY.W #$FFFC                              ; $80AE47 |
  BRA CODE_80AE4F                           ; $80AE4A |


CODE_80AE4C:
  LDY.W #$FFFE                              ; $80AE4C |

CODE_80AE4F:
  LDA.W $7C52                               ; $80AE4F |
  PHX                                       ; $80AE52 |
  ASL A                                     ; $80AE53 |
  TAX                                       ; $80AE54 |
  LDA.L PTR16_80AE5F,X                      ; $80AE55 |
  PLX                                       ; $80AE59 |
  STA.B $00                                 ; $80AE5A |
  JMP.W ($0000)                             ; $80AE5C |

PTR16_80AE5F:
  dw CODE_JP_80AE65                         ; $80AE5F |
  dw CODE_80AEBC                            ; $80AE61 |
  dw CODE_JP_80AF1E                         ; $80AE63 |

CODE_JP_80AE65:
  LDA.W $DA06                               ; $80AE65 |
  BNE CODE_80AEA0                           ; $80AE68 |
  LDA.W $7C4E                               ; $80AE6A |
  LSR A                                     ; $80AE6D |
  BNE CODE_80AE73                           ; $80AE6E |
  JMP.W CODE_JP_80AF1E                      ; $80AE70 |


CODE_80AE73:
  LDA.W #$0010                              ; $80AE73 |
  JSL.L CODE_FL_8089BD                      ; $80AE76 |
  LDA.W $7C54                               ; $80AE7A |
  LDY.W $7C58                               ; $80AE7D |
  BNE CODE_80AE87                           ; $80AE80 |
  CLC                                       ; $80AE82 |
  ADC.W $DA0A                               ; $80AE83 |
  LSR A                                     ; $80AE86 |

CODE_80AE87:
  CPY.W #$0002                              ; $80AE87 |
  BNE CODE_80AE90                           ; $80AE8A |
  LDA.W $7C56                               ; $80AE8C |
  DEC A                                     ; $80AE8F |

CODE_80AE90:
  STA.W $DA08                               ; $80AE90 |
  INC A                                     ; $80AE93 |
  STA.W $DA0A                               ; $80AE94 |
  JSR.W CODE_FN_80AEA4                      ; $80AE97 |
  LDA.W #$0001                              ; $80AE9A |
  STA.W $DA06                               ; $80AE9D |

CODE_80AEA0:
  INC.W $7C52                               ; $80AEA0 |
  RTL                                       ; $80AEA3 |


CODE_FN_80AEA4:
  LDA.W #$0003                              ; $80AEA4 |
  CMP.W $7C4E                               ; $80AEA7 |
  LDA.W $7C28                               ; $80AEAA |
  SBC.W #$0000                              ; $80AEAD |
  ASL A                                     ; $80AEB0 |
  ASL A                                     ; $80AEB1 |
  ASL A                                     ; $80AEB2 |
  SEC                                       ; $80AEB3 |
  SBC.W $DA08                               ; $80AEB4 |
  DEC A                                     ; $80AEB7 |
  STA.W $DA0C                               ; $80AEB8 |
  RTS                                       ; $80AEBB |


CODE_80AEBC:
  TYA                                       ; $80AEBC |
  STZ.B $04                                 ; $80AEBD |
  INC.B $04                                 ; $80AEBF |
  PHA                                       ; $80AEC1 |
  LDY.W $DA08                               ; $80AEC2 |
  CPY.W $7C54                               ; $80AEC5 |
  BPL CODE_80AECE                           ; $80AEC8 |

  EOR.W #$FFFF                              ; $80AECA |
  INC A                                     ; $80AECD |

CODE_80AECE:
  STA.B $06                                 ; $80AECE |
  CLC                                       ; $80AED0 |
  ADC.W $DA08                               ; $80AED1 |
  STA.W $DA08                               ; $80AED4 |
  SEC                                       ; $80AED7 |
  SBC.W $7C54                               ; $80AED8 |
  BEQ CODE_80AEE9                           ; $80AEDB |
  EOR.B $06                                 ; $80AEDD |
  BMI CODE_80AEE9                           ; $80AEDF |
  DEC.B $04                                 ; $80AEE1 |
  LDA.W $7C54                               ; $80AEE3 |
  STA.W $DA08                               ; $80AEE6 |

CODE_80AEE9:
  INC.B $04                                 ; $80AEE9 |
  PLA                                       ; $80AEEB |
  LDY.W $DA0A                               ; $80AEEC |
  CPY.W $7C56                               ; $80AEEF |
  BPL CODE_80AEF8                           ; $80AEF2 |
  EOR.W #$FFFF                              ; $80AEF4 |
  INC A                                     ; $80AEF7 |

CODE_80AEF8:
  STA.B $06                                 ; $80AEF8 |
  CLC                                       ; $80AEFA |
  ADC.W $DA0A                               ; $80AEFB |
  STA.W $DA0A                               ; $80AEFE |
  SEC                                       ; $80AF01 |
  SBC.W $7C56                               ; $80AF02 |
  BEQ CODE_80AF13                           ; $80AF05 |
  EOR.B $06                                 ; $80AF07 |
  BMI CODE_80AF13                           ; $80AF09 |
  DEC.B $04                                 ; $80AF0B |
  LDA.W $7C56                               ; $80AF0D |
  STA.W $DA0A                               ; $80AF10 |

CODE_80AF13:
  JSR.W CODE_FN_80AEA4                      ; $80AF13 |
  LDA.B $04                                 ; $80AF16 |
  BEQ CODE_80AEA0                           ; $80AF18 |
  RTL                                       ; $80AF1A |


CODE_JP_80AF1B:
  STZ.W $DA06                               ; $80AF1B |

CODE_JP_80AF1E:
  STZ.W $7C4C                               ; $80AF1E |
  STZ.W $7C52                               ; $80AF21 |
  RTL                                       ; $80AF24 |


CODE_JL_80AF25:
  LDA.W #$0003                              ; $80AF25 |
  STA.W $7C50                               ; $80AF28 |
  LDA.W #$0002                              ; $80AF2B |
  STA.W $7C4C                               ; $80AF2E |
  STZ.W $7C52                               ; $80AF31 |

CODE_80AF34:
  RTL                                       ; $80AF34 |


CODE_80AF35:
  JSL.L CODE_FL_80AF4A                      ; $80AF35 |
  LDA.W $7C5C                               ; $80AF39 |
  BEQ CODE_80AF34                           ; $80AF3C |
  JSL.L CODE_FL_80AF42                      ; $80AF3E |

CODE_FL_80AF42:
  LDA.W $7C50                               ; $80AF42 |
  CMP.W #$0003                              ; $80AF45 |
  BNE CODE_80AF34                           ; $80AF48 |

CODE_FL_80AF4A:
  LDY.W #$FFFC                              ; $80AF4A |
  LDA.W $7C52                               ; $80AF4D |
  PHX                                       ; $80AF50 |
  ASL A                                     ; $80AF51 |
  TAX                                       ; $80AF52 |
  LDA.L PTR16_80AF5D,X                      ; $80AF53 |
  PLX                                       ; $80AF57 |
  STA.B $00                                 ; $80AF58 |
  JMP.W ($0000)                             ; $80AF5A |

PTR16_80AF5D:
  dw CODE_80AF65                            ; $80AF5D |
  dw CODE_80AEBC                            ; $80AF5F |
  dw CODE_80AF94                            ; $80AF61 |
  dw CODE_80AFED                            ; $80AF63 |

CODE_80AF65:
  LDA.W $7C4E                               ; $80AF65 |
  LSR A                                     ; $80AF68 |
  BEQ CODE_80AF7B                           ; $80AF69 |
  LDA.W $DA06                               ; $80AF6B |
  BNE CODE_80AF7B                           ; $80AF6E |
  JSR.W CODE_FN_80AF82                      ; $80AF70 |
  BCS CODE_80AF78                           ; $80AF73 |
  JMP.W CODE_JP_80AE65                      ; $80AF75 |


CODE_80AF78:
  INC.W $7C52                               ; $80AF78 |

CODE_80AF7B:
  INC.W $7C52                               ; $80AF7B |
  INC.W $7C52                               ; $80AF7E |
  RTL                                       ; $80AF81 |


CODE_FN_80AF82:
  LDA.W $7C22                               ; $80AF82 |
  CMP.W $7C26                               ; $80AF85 |
  BNE CODE_80AF92                           ; $80AF88 |
  LDA.W $7C24                               ; $80AF8A |
  CMP.W $7C28                               ; $80AF8D |
  BEQ CODE_80AF93                           ; $80AF90 |

CODE_80AF92:
  CLC                                       ; $80AF92 |

CODE_80AF93:
  RTS                                       ; $80AF93 |


CODE_80AF94:
  LDA.W $7C0A                               ; $80AF94 |
  BNE CODE_80AFE9                           ; $80AF97 |
  JSR.W CODE_FN_80AF82                      ; $80AF99 |
  BCS CODE_80AFE9                           ; $80AF9C |
  LDA.W $7C26                               ; $80AF9E |
  CMP.W $7C22                               ; $80AFA1 |
  BNE CODE_80AFAE                           ; $80AFA4 |
  LDA.W $7C28                               ; $80AFA6 |
  CMP.W $7C24                               ; $80AFA9 |
  BEQ CODE_80AFE9                           ; $80AFAC |

CODE_80AFAE:
  CLC                                       ; $80AFAE |
  LDA.W $7C26                               ; $80AFAF |
  ADC.W $7C2A                               ; $80AFB2 |
  STA.W $7C22                               ; $80AFB5 |
  LDA.W $7C2E                               ; $80AFB8 |
  LSR A                                     ; $80AFBB |
  LDA.W $7C28                               ; $80AFBC |
  SBC.W #$0002                              ; $80AFBF |
  CLC                                       ; $80AFC2 |
  ADC.W $7C2C                               ; $80AFC3 |
  STA.W $7C24                               ; $80AFC6 |
  LDA.W $7C14                               ; $80AFC9 |
  BIT.W #$0002                              ; $80AFCC |
  BNE CODE_80AFDD                           ; $80AFCF |
  LDA.W $7C1C                               ; $80AFD1 |
  BEQ CODE_80AFDD                           ; $80AFD4 |
  LDA.W #$0009                              ; $80AFD6 |
  JSL.L put_char                            ; $80AFD9 |

CODE_80AFDD:
  LDA.W #$0001                              ; $80AFDD |
  STA.W $7C36                               ; $80AFE0 |
  LDA.W $7C12                               ; $80AFE3 |
  STA.W $7C0E                               ; $80AFE6 |

CODE_80AFE9:
  INC.W $7C52                               ; $80AFE9 |
  RTL                                       ; $80AFEC |


CODE_80AFED:
  LDA.W $DA06                               ; $80AFED |
  BNE CODE_80AFF5                           ; $80AFF0 |
  JMP.W CODE_JP_80AF1B                      ; $80AFF2 |


CODE_80AFF5:
  LDA.W $DA0A                               ; $80AFF5 |
  LDY.W $7C58                               ; $80AFF8 |
  CPY.W #$0002                              ; $80AFFB |
  BEQ CODE_80B007                           ; $80AFFE |
  CLC                                       ; $80B000 |
  ADC.W #$FFFC                              ; $80B001 |
  STA.W $DA0A                               ; $80B004 |

CODE_80B007:
  LDA.W $DA08                               ; $80B007 |
  CPY.W #$0001                              ; $80B00A |
  BEQ CODE_80B016                           ; $80B00D |
  CLC                                       ; $80B00F |
  ADC.W #$0004                              ; $80B010 |
  STA.W $DA08                               ; $80B013 |

CODE_80B016:
  CMP.W $DA0A                               ; $80B016 |
  BMI CODE_80B01E                           ; $80B019 |
  JMP.W CODE_JP_80AF1B                      ; $80B01B |


CODE_80B01E:
  JSR.W CODE_FN_80AEA4                      ; $80B01E |
  RTL                                       ; $80B021 |


CODE_JL_80B022:
  LDA.W #$0004                              ; $80B022 |
  STA.W $7C50                               ; $80B025 |
  LDA.W #$0001                              ; $80B028 |
  STA.W $7C4C                               ; $80B02B |
  STZ.W $7C52                               ; $80B02E |
  RTL                                       ; $80B031 |


CODE_80B032:
  LDY.W #$FFFC                              ; $80B032 |
  LDA.W $7C52                               ; $80B035 |
  PHX                                       ; $80B038 |
  ASL A                                     ; $80B039 |
  TAX                                       ; $80B03A |
  LDA.L PTR16_80B045,X                      ; $80B03B |
  PLX                                       ; $80B03F |
  STA.B $00                                 ; $80B040 |
  JMP.W ($0000)                             ; $80B042 |

PTR16_80B045:
  dw CODE_80AF65                            ; $80B045 |
  dw CODE_80AEBC                            ; $80B047 |
  dw CODE_80AF94                            ; $80B049 |
  dw CODE_JL_80AD2D                         ; $80B04B |

CODE_FL_80B04D:
  LDA.B $48                                 ; $80B04D |
  AND.W #$BFFF                              ; $80B04F |
  STA.B $48                                 ; $80B052 |
  RTL                                       ; $80B054 |

  STA.B $5C                                 ; $80B055 |
  LDA.B $48                                 ; $80B057 |
  AND.W #$BFFF                              ; $80B059 |
  STA.B $48                                 ; $80B05C |
  RTL                                       ; $80B05E |


CODE_FL_80B05F:
  LDA.B $48                                 ; $80B05F |
  ORA.W #$4000                              ; $80B061 |
  STA.B $48                                 ; $80B064 |
  RTL                                       ; $80B066 |


CODE_FL_80B067:
  LDA.B $48                                 ; $80B067 |
  ORA.W #$4000                              ; $80B069 |
  STA.B $48                                 ; $80B06C |
  LDA.W #$FFFF                              ; $80B06E |
  STA.B $5C                                 ; $80B071 |
  RTL                                       ; $80B073 |


CODE_FL_80B074:
  LDA.W $1FA6                               ; $80B074 |
  LSR A                                     ; $80B077 |
  LSR A                                     ; $80B078 |
  LSR A                                     ; $80B079 |
  LSR A                                     ; $80B07A |
  AND.W #$FFFE                              ; $80B07B |
  TAX                                       ; $80B07E |
  SEP #$20                                  ; $80B07F |
  LDA.L DATA16_80B096,X                     ; $80B081 |
  STA.B $6C                                 ; $80B085 |
  LDA.B #$FF                                ; $80B087 |
  STA.B $6D                                 ; $80B089 |
  LDA.L DATA16_80B096+1,X                   ; $80B08B |
  STA.B $6E                                 ; $80B08F |
  STZ.B $6F                                 ; $80B091 |
  REP #$20                                  ; $80B093 |
  RTL                                       ; $80B095 |


DATA16_80B096:
  dw $0FF8,$1FE8,$3FC8,$1FF0                ; $80B096 |
  dw $3FD0,$3FE0                            ; $80B09E |

CODE_FL_80B0A2:
  LDY.B $5C                                 ; $80B0A2 |
  BMI CODE_80B0B6                           ; $80B0A4 |
  JSL.L CODE_FL_80B074                      ; $80B0A6 |
  CPY.W #$0003                              ; $80B0AA |
  BEQ CODE_FL_80B0BC                        ; $80B0AD |
  JSL.L CODE_FL_80B0BC                      ; $80B0AF |
  STZ.W $1626                               ; $80B0B3 |

CODE_80B0B6:
  RTL                                       ; $80B0B6 |


DATA8_80B0B7:
  db $93,$93,$94,$94,$94                    ; $80B0B7 |

CODE_FL_80B0BC:
  PHB                                       ; $80B0BC |
  PEA.W $7E00                               ; $80B0BD |
  PLB                                       ; $80B0C0 |
  PLB                                       ; $80B0C1 |
  LDA.W #$0000                              ; $80B0C2 |
  TCD                                       ; $80B0C5 |
  TSC                                       ; $80B0C6 |
  STA.B $64                                 ; $80B0C7 |
  LDA.W #$03DF                              ; $80B0C9 |
  TCS                                       ; $80B0CC |
  LDA.W #$03E0                              ; $80B0CD |
  STA.B $08                                 ; $80B0D0 |
  SEP #$20                                  ; $80B0D2 |
  LDA.L DATA8_80B0B7                        ; $80B0D4 |
  STA.B $6A                                 ; $80B0D8 |
  LDX.W $0418                               ; $80B0DA |
  LDA.L DATA8_80B0B7,X                      ; $80B0DD |
  STA.B $04                                 ; $80B0E1 |
  LDX.W $04D8                               ; $80B0E3 |
  LDA.L DATA8_80B0B7,X                      ; $80B0E6 |
  STA.B $05                                 ; $80B0EA |
  LDA.B #$80                                ; $80B0EC |
  STA.B $0A                                 ; $80B0EE |
  REP #$20                                  ; $80B0F0 |
  LDA.B $5C                                 ; $80B0F2 |
  BEQ CODE_80B100                           ; $80B0F4 |
  DEC A                                     ; $80B0F6 |
  BEQ CODE_80B106                           ; $80B0F7 |
  DEC A                                     ; $80B0F9 |
  BEQ CODE_80B167                           ; $80B0FA |
  DEC A                                     ; $80B0FC |
  JMP.W CODE_JP_80B1CE                      ; $80B0FD |


CODE_80B100:
  LDA.W #$B1EA                              ; $80B100 |
  JMP.W CODE_JP_80B45E                      ; $80B103 |


CODE_80B106:
  LDA.B $C6                                 ; $80B106 |
  BNE CODE_80B130                           ; $80B108 |
  SEC                                       ; $80B10A |
  LDA.W $1B7A                               ; $80B10B |
  SBC.W #$0050                              ; $80B10E |
  TAX                                       ; $80B111 |
  LDA.W $0016,X                             ; $80B112 |
  STA.B $02                                 ; $80B115 |
  STZ.W $0016,X                             ; $80B117 |
  LDA.W #$B1D7                              ; $80B11A |
  LDX.W $1B78                               ; $80B11D |
  JMP.W CODE_JP_80B4C5                      ; $80B120 |

  SEC                                       ; $80B123 |
  LDA.W $1B7A                               ; $80B124 |
  SBC.W #$0050                              ; $80B127 |
  TAX                                       ; $80B12A |
  LDA.B $02                                 ; $80B12B |
  STA.W $0016,X                             ; $80B12D |

CODE_80B130:
  JSL.L CODE_FL_80BD07                      ; $80B130 |
  LDA.W #$B13A                              ; $80B134 |
  JMP.W CODE_JP_80B3A4                      ; $80B137 |

  LDA.B $C6                                 ; $80B13A |
  BNE CODE_80B157                           ; $80B13C |
  SEC                                       ; $80B13E |
  LDA.W $1B7A                               ; $80B13F |
  SBC.W #$0050                              ; $80B142 |
  TAX                                       ; $80B145 |
  LDA.W $0016,X                             ; $80B146 |
  STA.B $02                                 ; $80B149 |
  STZ.W $0016,X                             ; $80B14B |
  LDA.W #$B157                              ; $80B14E |
  LDX.W $1B78                               ; $80B151 |
  JMP.W CODE_JP_80B4E7                      ; $80B154 |


CODE_80B157:
  SEC                                       ; $80B157 |
  LDA.W $1B7A                               ; $80B158 |
  SBC.W #$0050                              ; $80B15B |
  TAX                                       ; $80B15E |
  LDA.B $02                                 ; $80B15F |
  STA.W $0016,X                             ; $80B161 |
  JMP.W CODE_JP_80B1EA                      ; $80B164 |


CODE_80B167:
  LDA.B $C6                                 ; $80B167 |
  BNE CODE_80B191                           ; $80B169 |
  SEC                                       ; $80B16B |
  LDA.W $1B7A                               ; $80B16C |
  SBC.W #$0050                              ; $80B16F |
  TAX                                       ; $80B172 |
  LDA.W $0016,X                             ; $80B173 |
  STA.B $02                                 ; $80B176 |
  STZ.W $0016,X                             ; $80B178 |
  LDX.W $1B78                               ; $80B17B |
  LDA.W #$B184                              ; $80B17E |
  JMP.W CODE_JP_80B47E                      ; $80B181 |

  SEC                                       ; $80B184 |
  LDA.W $1B7A                               ; $80B185 |
  SBC.W #$0050                              ; $80B188 |
  TAX                                       ; $80B18B |
  LDA.B $02                                 ; $80B18C |
  STA.W $0016,X                             ; $80B18E |

CODE_80B191:
  JSL.L CODE_FL_80BD51                      ; $80B191 |
  LDA.W #$B19B                              ; $80B195 |
  JMP.W CODE_JP_80B3CA                      ; $80B198 |

  LDA.W #$B1A1                              ; $80B19B |
  JMP.W CODE_JP_80B3F3                      ; $80B19E |

  LDA.B $C6                                 ; $80B1A1 |
  BNE CODE_80B1CB                           ; $80B1A3 |
  SEC                                       ; $80B1A5 |
  LDA.W $1B7A                               ; $80B1A6 |
  SBC.W #$0050                              ; $80B1A9 |
  TAX                                       ; $80B1AC |
  LDA.W $0016,X                             ; $80B1AD |
  STA.B $02                                 ; $80B1B0 |
  STZ.W $0016,X                             ; $80B1B2 |
  LDX.W $1B78                               ; $80B1B5 |
  LDA.W #$B1BE                              ; $80B1B8 |
  JMP.W CODE_JP_80B4A0                      ; $80B1BB |

  SEC                                       ; $80B1BE |
  LDA.W $1B7A                               ; $80B1BF |
  SBC.W #$0050                              ; $80B1C2 |
  TAX                                       ; $80B1C5 |
  LDA.B $02                                 ; $80B1C6 |
  STA.W $0016,X                             ; $80B1C8 |

CODE_80B1CB:
  JMP.W CODE_JP_80B1EA                      ; $80B1CB |


CODE_JP_80B1CE:
  LDA.W #$B1D7                              ; $80B1CE |
  LDX.W #$13C0                              ; $80B1D1 |
  JMP.W CODE_JP_80B4C5                      ; $80B1D4 |

  JSL.L CODE_FL_80BD34                      ; $80B1D7 |
  LDA.W #$B1E1                              ; $80B1DB |
  JMP.W CODE_JP_80B3A4                      ; $80B1DE |

  LDA.W #$B1EA                              ; $80B1E1 |
  LDX.W #$13C0                              ; $80B1E4 |
  JMP.W CODE_JP_80B4E7                      ; $80B1E7 |


CODE_JP_80B1EA:
  LDA.B $64                                 ; $80B1EA |
  TCS                                       ; $80B1EC |
  STZ.B $00                                 ; $80B1ED |
  SEP #$20                                  ; $80B1EF |
  LDA.B $0A                                 ; $80B1F1 |
  CMP.B #$80                                ; $80B1F3 |
  BEQ CODE_80B203                           ; $80B1F5 |
  LDX.W #$0004                              ; $80B1F7 |

CODE_80B1FA:
  DEX                                       ; $80B1FA |
  LSR A                                     ; $80B1FB |
  LSR A                                     ; $80B1FC |
  BCC CODE_80B1FA                           ; $80B1FD |
  STA.B ($08)                               ; $80B1FF |
  STX.B $00                                 ; $80B201 |

CODE_80B203:
  TDC                                       ; $80B203 |
  LDA.B $08                                 ; $80B204 |
  ASL A                                     ; $80B206 |
  ASL A                                     ; $80B207 |
  REP #$20                                  ; $80B208 |
  ORA.B $00                                 ; $80B20A |
  STA.B $00                                 ; $80B20C |
  ASL A                                     ; $80B20E |
  ASL A                                     ; $80B20F |
  SBC.B $00                                 ; $80B210 |
  ADC.W #$B0A1                              ; $80B212 |
  PHA                                       ; $80B215 |
  SEP #$20                                  ; $80B216 |
  LDA.B #$F0                                ; $80B218 |
  RTS                                       ; $80B21A |


CODE_JP_80B21B:
  REP #$20                                  ; $80B21B |
  LDA.B $64                                 ; $80B21D |
  TCS                                       ; $80B21F |
  PLB                                       ; $80B220 |
  RTL                                       ; $80B221 |

  STA.W $03DE                               ; $80B222 |
  STA.W $03DA                               ; $80B225 |
  STA.W $03D6                               ; $80B228 |
  STA.W $03D2                               ; $80B22B |
  STA.W $03CE                               ; $80B22E |
  STA.W $03CA                               ; $80B231 |
  STA.W $03C6                               ; $80B234 |
  STA.W $03C2                               ; $80B237 |
  STA.W $03BE                               ; $80B23A |
  STA.W $03BA                               ; $80B23D |
  STA.W $03B6                               ; $80B240 |
  STA.W $03B2                               ; $80B243 |
  STA.W $03AE                               ; $80B246 |
  STA.W $03AA                               ; $80B249 |
  STA.W $03A6                               ; $80B24C |
  STA.W $03A2                               ; $80B24F |
  STA.W $039E                               ; $80B252 |
  STA.W $039A                               ; $80B255 |
  STA.W $0396                               ; $80B258 |
  STA.W $0392                               ; $80B25B |
  STA.W $038E                               ; $80B25E |
  STA.W $038A                               ; $80B261 |
  STA.W $0386                               ; $80B264 |
  STA.W $0382                               ; $80B267 |
  STA.W $037E                               ; $80B26A |
  STA.W $037A                               ; $80B26D |
  STA.W $0376                               ; $80B270 |
  STA.W $0372                               ; $80B273 |
  STA.W $036E                               ; $80B276 |
  STA.W $036A                               ; $80B279 |
  STA.W $0366                               ; $80B27C |
  STA.W $0362                               ; $80B27F |
  STA.W $035E                               ; $80B282 |
  STA.W $035A                               ; $80B285 |
  STA.W $0356                               ; $80B288 |
  STA.W $0352                               ; $80B28B |
  STA.W $034E                               ; $80B28E |
  STA.W $034A                               ; $80B291 |
  STA.W $0346                               ; $80B294 |
  STA.W $0342                               ; $80B297 |
  STA.W $033E                               ; $80B29A |
  STA.W $033A                               ; $80B29D |
  STA.W $0336                               ; $80B2A0 |
  STA.W $0332                               ; $80B2A3 |
  STA.W $032E                               ; $80B2A6 |
  STA.W $032A                               ; $80B2A9 |
  STA.W $0326                               ; $80B2AC |
  STA.W $0322                               ; $80B2AF |
  STA.W $031E                               ; $80B2B2 |
  STA.W $031A                               ; $80B2B5 |
  STA.W $0316                               ; $80B2B8 |
  STA.W $0312                               ; $80B2BB |
  STA.W $030E                               ; $80B2BE |
  STA.W $030A                               ; $80B2C1 |
  STA.W $0306                               ; $80B2C4 |
  STA.W $0302                               ; $80B2C7 |
  STA.W $02FE                               ; $80B2CA |
  STA.W $02FA                               ; $80B2CD |
  STA.W $02F6                               ; $80B2D0 |
  STA.W $02F2                               ; $80B2D3 |
  STA.W $02EE                               ; $80B2D6 |
  STA.W $02EA                               ; $80B2D9 |
  STA.W $02E6                               ; $80B2DC |
  STA.W $02E2                               ; $80B2DF |
  STA.W $02DE                               ; $80B2E2 |
  STA.W $02DA                               ; $80B2E5 |
  STA.W $02D6                               ; $80B2E8 |
  STA.W $02D2                               ; $80B2EB |
  STA.W $02CE                               ; $80B2EE |
  STA.W $02CA                               ; $80B2F1 |
  STA.W $02C6                               ; $80B2F4 |
  STA.W $02C2                               ; $80B2F7 |
  STA.W $02BE                               ; $80B2FA |
  STA.W $02BA                               ; $80B2FD |
  STA.W $02B6                               ; $80B300 |
  STA.W $02B2                               ; $80B303 |
  STA.W $02AE                               ; $80B306 |
  STA.W $02AA                               ; $80B309 |
  STA.W $02A6                               ; $80B30C |
  STA.W $02A2                               ; $80B30F |
  STA.W $029E                               ; $80B312 |
  STA.W $029A                               ; $80B315 |
  STA.W $0296                               ; $80B318 |
  STA.W $0292                               ; $80B31B |
  STA.W $028E                               ; $80B31E |
  STA.W $028A                               ; $80B321 |
  STA.W $0286                               ; $80B324 |
  STA.W $0282                               ; $80B327 |
  STA.W $027E                               ; $80B32A |
  STA.W $027A                               ; $80B32D |
  STA.W $0276                               ; $80B330 |
  STA.W $0272                               ; $80B333 |
  STA.W $026E                               ; $80B336 |
  STA.W $026A                               ; $80B339 |
  STA.W $0266                               ; $80B33C |
  STA.W $0262                               ; $80B33F |
  STA.W $025E                               ; $80B342 |
  STA.W $025A                               ; $80B345 |
  STA.W $0256                               ; $80B348 |
  STA.W $0252                               ; $80B34B |
  STA.W $024E                               ; $80B34E |
  STA.W $024A                               ; $80B351 |
  STA.W $0246                               ; $80B354 |
  STA.W $0242                               ; $80B357 |
  STA.W $023E                               ; $80B35A |
  STA.W $023A                               ; $80B35D |
  STA.W $0236                               ; $80B360 |
  STA.W $0232                               ; $80B363 |
  STA.W $022E                               ; $80B366 |
  STA.W $022A                               ; $80B369 |
  STA.W $0226                               ; $80B36C |
  STA.W $0222                               ; $80B36F |
  STA.W $021E                               ; $80B372 |
  STA.W $021A                               ; $80B375 |
  STA.W $0216                               ; $80B378 |
  STA.W $0212                               ; $80B37B |
  STA.W $020E                               ; $80B37E |
  STA.W $020A                               ; $80B381 |
  STA.W $0206                               ; $80B384 |
  STA.W $0202                               ; $80B387 |
  STA.W $01FE                               ; $80B38A |
  STA.W $01FA                               ; $80B38D |
  STA.W $01F6                               ; $80B390 |
  STA.W $01F2                               ; $80B393 |
  STA.W $01EE                               ; $80B396 |
  STA.W $01EA                               ; $80B399 |
  STA.W $01E6                               ; $80B39C |
  STA.W $01E2                               ; $80B39F |
  PLB                                       ; $80B3A2 |
  RTL                                       ; $80B3A3 |


CODE_JP_80B3A4:
  STA.B $68                                 ; $80B3A4 |
  LDA.W #$B3BA                              ; $80B3A6 |
  STA.B $00                                 ; $80B3A9 |
  CLC                                       ; $80B3AB |
  LDY.W #$1E38                              ; $80B3AC |

CODE_80B3AF:
  STY.B $FE                                 ; $80B3AF |
  LDX.B $60,Y                               ; $80B3B1 |
  BEQ CODE_80B3C7                           ; $80B3B3 |
  LDY.B $00,X                               ; $80B3B5 |
  JMP.W CODE_JP_80B562                      ; $80B3B7 |

  REP #$20                                  ; $80B3BA |
  BCS CODE_80B3F0                           ; $80B3BC |
  LDY.B $FE                                 ; $80B3BE |
  INY                                       ; $80B3C0 |
  INY                                       ; $80B3C1 |
  CPY.W #$1E98                              ; $80B3C2 |
  BCC CODE_80B3AF                           ; $80B3C5 |

CODE_80B3C7:
  JMP.W ($0068)                             ; $80B3C7 |


CODE_JP_80B3CA:
  STA.B $68                                 ; $80B3CA |
  LDA.W #$B3E0                              ; $80B3CC |
  STA.B $00                                 ; $80B3CF |
  CLC                                       ; $80B3D1 |
  LDY.W #$1E38                              ; $80B3D2 |

CODE_80B3D5:
  STY.B $FE                                 ; $80B3D5 |
  LDX.B $60,Y                               ; $80B3D7 |
  BEQ CODE_80B3ED                           ; $80B3D9 |
  LDY.B $00,X                               ; $80B3DB |
  JMP.W CODE_JP_80B509                      ; $80B3DD |

  REP #$20                                  ; $80B3E0 |
  BCS CODE_80B3F0                           ; $80B3E2 |
  LDY.B $FE                                 ; $80B3E4 |
  INY                                       ; $80B3E6 |
  INY                                       ; $80B3E7 |
  CPY.W #$1E98                              ; $80B3E8 |
  BCC CODE_80B3D5                           ; $80B3EB |

CODE_80B3ED:
  JMP.W ($0068)                             ; $80B3ED |


CODE_80B3F0:
  JMP.W CODE_JP_80B21B                      ; $80B3F0 |


CODE_JP_80B3F3:
  STA.B $68                                 ; $80B3F3 |
  TDC                                       ; $80B3F5 |
  SEP #$20                                  ; $80B3F6 |
  PEA.W $9393                               ; $80B3F8 |
  PLB                                       ; $80B3FB |
  PLB                                       ; $80B3FC |
  LDY.W #$B416                              ; $80B3FD |
  STY.B $00                                 ; $80B400 |
  LDY.W #$1E38                              ; $80B402 |

CODE_80B405:
  STY.B $FE                                 ; $80B405 |
  LDX.B $60,Y                               ; $80B407 |
  BEQ CODE_80B422                           ; $80B409 |
  BIT.B $12,X                               ; $80B40B |
  BMI CODE_80B419                           ; $80B40D |
  LDA.B $14,X                               ; $80B40F |
  BEQ CODE_80B419                           ; $80B411 |
  JMP.W CODE_JP_80B525                      ; $80B413 |

  BCS CODE_80B45B                           ; $80B416 |
  TDC                                       ; $80B418 |

CODE_80B419:
  LDY.B $FE                                 ; $80B419 |
  INY                                       ; $80B41B |
  INY                                       ; $80B41C |
  CPY.W #$1E98                              ; $80B41D |
  BCC CODE_80B405                           ; $80B420 |

CODE_80B422:
  REP #$20                                  ; $80B422 |
  JMP.W ($0068)                             ; $80B424 |

  LDY.W #$B448                              ; $80B427 |
  STY.B $00                                 ; $80B42A |
  LDY.W #$1E38                              ; $80B42C |
  LDA.B $42                                 ; $80B42F |
  LSR A                                     ; $80B431 |
  BCC CODE_80B437                           ; $80B432 |
  INY                                       ; $80B434 |
  INY                                       ; $80B435 |
  CLC                                       ; $80B436 |

CODE_80B437:
  STY.B $FE                                 ; $80B437 |
  LDX.B $60,Y                               ; $80B439 |
  BEQ CODE_80B456                           ; $80B43B |
  BIT.B $12,X                               ; $80B43D |
  BMI CODE_80B44B                           ; $80B43F |
  LDA.B $14,X                               ; $80B441 |
  BEQ CODE_80B44B                           ; $80B443 |
  JMP.W CODE_JP_80B525                      ; $80B445 |

  BCS CODE_80B45B                           ; $80B448 |
  TDC                                       ; $80B44A |

CODE_80B44B:
  LDY.B $FE                                 ; $80B44B |
  INY                                       ; $80B44D |
  INY                                       ; $80B44E |
  INY                                       ; $80B44F |
  INY                                       ; $80B450 |
  CPY.W #$1E98                              ; $80B451 |
  BCC CODE_80B437                           ; $80B454 |

CODE_80B456:
  REP #$20                                  ; $80B456 |
  JMP.W ($0068)                             ; $80B458 |


CODE_80B45B:
  JMP.W CODE_JP_80B21B                      ; $80B45B |


CODE_JP_80B45E:
  STA.B $68                                 ; $80B45E |
  LDX.W #$0400                              ; $80B460 |
  LDA.W #$B471                              ; $80B463 |
  STA.B $00                                 ; $80B466 |

CODE_80B468:
  STX.B $FC                                 ; $80B468 |
  LDY.B $00,X                               ; $80B46A |
  BEQ CODE_80B475                           ; $80B46C |
  JMP.W CODE_JP_80B562                      ; $80B46E |

  REP #$20                                  ; $80B471 |
  BCS CODE_80B45B                           ; $80B473 |

CODE_80B475:
  LDY.B $FC                                 ; $80B475 |
  LDX.B $16,Y                               ; $80B477 |
  BNE CODE_80B468                           ; $80B479 |
  JMP.W ($0068)                             ; $80B47B |


CODE_JP_80B47E:
  STA.B $68                                 ; $80B47E |
  LDA.W #$B493                              ; $80B480 |
  STA.B $00                                 ; $80B483 |
  CLC                                       ; $80B485 |

CODE_80B486:
  STX.B $FC                                 ; $80B486 |
  BIT.B $14,X                               ; $80B488 |
  BMI CODE_80B497                           ; $80B48A |
  LDY.B $00,X                               ; $80B48C |
  BEQ CODE_80B497                           ; $80B48E |
  JMP.W CODE_JP_80B509                      ; $80B490 |

  REP #$20                                  ; $80B493 |
  BCS CODE_80B45B                           ; $80B495 |

CODE_80B497:
  LDY.B $FC                                 ; $80B497 |
  LDX.B $16,Y                               ; $80B499 |
  BNE CODE_80B486                           ; $80B49B |
  JMP.W ($0068)                             ; $80B49D |


CODE_JP_80B4A0:
  STA.B $68                                 ; $80B4A0 |
  LDA.W #$B4B5                              ; $80B4A2 |
  STA.B $00                                 ; $80B4A5 |
  CLC                                       ; $80B4A7 |

CODE_80B4A8:
  STX.B $FC                                 ; $80B4A8 |
  BIT.B $14,X                               ; $80B4AA |
  BPL CODE_80B4B9                           ; $80B4AC |
  LDY.B $00,X                               ; $80B4AE |
  BEQ CODE_80B4B9                           ; $80B4B0 |
  JMP.W CODE_JP_80B509                      ; $80B4B2 |

  REP #$20                                  ; $80B4B5 |
  BCS CODE_80B45B                           ; $80B4B7 |

CODE_80B4B9:
  LDY.B $FC                                 ; $80B4B9 |
  LDX.B $16,Y                               ; $80B4BB |
  BNE CODE_80B4A8                           ; $80B4BD |
  JMP.W ($0068)                             ; $80B4BF |


CODE_80B4C2:
  JMP.W CODE_JP_80B21B                      ; $80B4C2 |


CODE_JP_80B4C5:
  STA.B $68                                 ; $80B4C5 |
  LDA.W #$B4DA                              ; $80B4C7 |
  STA.B $00                                 ; $80B4CA |
  CLC                                       ; $80B4CC |

CODE_80B4CD:
  STX.B $FC                                 ; $80B4CD |
  BIT.B $14,X                               ; $80B4CF |
  BMI CODE_80B4DE                           ; $80B4D1 |
  LDY.B $00,X                               ; $80B4D3 |
  BEQ CODE_80B4DE                           ; $80B4D5 |
  JMP.W CODE_JP_80B562                      ; $80B4D7 |

  REP #$20                                  ; $80B4DA |
  BCS CODE_80B4C2                           ; $80B4DC |

CODE_80B4DE:
  LDY.B $FC                                 ; $80B4DE |
  LDX.B $16,Y                               ; $80B4E0 |
  BNE CODE_80B4CD                           ; $80B4E2 |

  JMP.W ($0068)                             ; $80B4E4 |


CODE_JP_80B4E7:
  STA.B $68                                 ; $80B4E7 |
  LDA.W #$B4FC                              ; $80B4E9 |
  STA.B $00                                 ; $80B4EC |
  CLC                                       ; $80B4EE |

CODE_80B4EF:
  STX.B $FC                                 ; $80B4EF |
  BIT.B $14,X                               ; $80B4F1 |
  BPL CODE_80B500                           ; $80B4F3 |
  LDY.B $00,X                               ; $80B4F5 |
  BEQ CODE_80B500                           ; $80B4F7 |
  JMP.W CODE_JP_80B562                      ; $80B4F9 |

  REP #$20                                  ; $80B4FC |
  BCS CODE_80B4C2                           ; $80B4FE |

CODE_80B500:
  LDY.B $FC                                 ; $80B500 |
  LDX.B $16,Y                               ; $80B502 |
  BNE CODE_80B4EF                           ; $80B504 |
  JMP.W ($0068)                             ; $80B506 |


CODE_JP_80B509:
  SEC                                       ; $80B509 |
  BMI CODE_80B516                           ; $80B50A |
  LDA.B $0D,X                               ; $80B50C |
  SBC.B $11,X                               ; $80B50E |
  BRA CODE_80B566                           ; $80B510 |


CODE_80B512:
  CLC                                       ; $80B512 |
  JMP.W ($0000)                             ; $80B513 |


CODE_80B516:
  LDA.B $0D,X                               ; $80B516 |
  SBC.B $11,X                               ; $80B518 |
  STA.B $15                                 ; $80B51A |
  SEP #$20                                  ; $80B51C |
  LDA.B $02,X                               ; $80B51E |
  BMI CODE_80B512                           ; $80B520 |
  JMP.W CODE_JP_80B9A4                      ; $80B522 |


CODE_JP_80B525:
  REP #$20                                  ; $80B525 |
  TAY                                       ; $80B527 |
  LDA.W $93DF6A,Y                           ; $80B528 |
  TAY                                       ; $80B52B |
  SEP #$20                                  ; $80B52C |
  SEC                                       ; $80B52E |
  LDA.B $0D,X                               ; $80B52F |
  SBC.B $15,X                               ; $80B531 |
  STA.B $15                                 ; $80B533 |
  LDA.B $0E,X                               ; $80B535 |
  SBC.B #$00                                ; $80B537 |
  STA.B $16                                 ; $80B539 |
  STZ.B $1A                                 ; $80B53B |
  STZ.B $0B                                 ; $80B53D |
  LDA.B #$C1                                ; $80B53F |
  STA.B $12                                 ; $80B541 |
  LDA.B $04,X                               ; $80B543 |
  JMP.W CODE_JP_80B9DD                      ; $80B545 |

  JMP.W ($0000)                             ; $80B548 |


CODE_80B54B:
  JMP.W CODE_JP_80B790                      ; $80B54B |


CODE_80B54E:
  JMP.W CODE_JP_80B690                      ; $80B54E |


CODE_80B551:
  LDA.B $0D,X                               ; $80B551 |
  STA.B $15                                 ; $80B553 |
  SEP #$20                                  ; $80B555 |
  LDA.B $02,X                               ; $80B557 |
  BMI CODE_80B55E                           ; $80B559 |
  JMP.W CODE_JP_80B9A4                      ; $80B55B |


CODE_80B55E:
  CLC                                       ; $80B55E |
  JMP.W ($0000)                             ; $80B55F |


CODE_JP_80B562:
  BMI CODE_80B551                           ; $80B562 |
  LDA.B $0D,X                               ; $80B564 |

CODE_80B566:
  STA.B $15                                 ; $80B566 |
  SEP #$20                                  ; $80B568 |
  LDA.B $02,X                               ; $80B56A |
  BMI CODE_80B55E                           ; $80B56C |
  PEA.W $7E00                               ; $80B56E |
  PLB                                       ; $80B571 |
  PLB                                       ; $80B572 |
  ASL A                                     ; $80B573 |
  BMI CODE_80B57C                           ; $80B574 |
  STA.B $1A                                 ; $80B576 |
  LDA.B #$CF                                ; $80B578 |
  BRA CODE_80B582                           ; $80B57A |


CODE_80B57C:
  AND.B #$0E                                ; $80B57C |
  STA.B $1A                                 ; $80B57E |
  LDA.B #$C1                                ; $80B580 |

CODE_80B582:
  STA.B $12                                 ; $80B582 |
  TDC                                       ; $80B584 |
  LDA.B $06,X                               ; $80B585 |
  BNE CODE_80B54B                           ; $80B587 |
  LDA.B $04,X                               ; $80B589 |
  ASL A                                     ; $80B58B |
  AND.B #$F0                                ; $80B58C |
  STA.B $17                                 ; $80B58E |
  ASL A                                     ; $80B590 |
  LDA.W $0001,Y                             ; $80B591 |
  STA.B $1B                                 ; $80B594 |
  REP #$20                                  ; $80B596 |
  LDA.B $15                                 ; $80B598 |
  BCS CODE_80B54E                           ; $80B59A |
  LDA.B $09,X                               ; $80B59C |
  BIT.B $16                                 ; $80B59E |
  BVS CODE_80B615                           ; $80B5A0 |
  STA.B $10                                 ; $80B5A2 |
  SEP #$20                                  ; $80B5A4 |
  CLC                                       ; $80B5A6 |
  TDC                                       ; $80B5A7 |
  LDA.W $0000,Y                             ; $80B5A8 |
  TAX                                       ; $80B5AB |
  BRA CODE_80B5B3                           ; $80B5AC |


CODE_80B5AE:
  INY                                       ; $80B5AE |
  INY                                       ; $80B5AF |
  LDX.W $0000,Y                             ; $80B5B0 |

CODE_80B5B3:
  REP #$20                                  ; $80B5B3 |
  LDA.B $15                                 ; $80B5B5 |
  ADC.W $2000,Y                             ; $80B5B7 |
  CMP.W #$00F0                              ; $80B5BA |
  BCS CODE_80B5FD                           ; $80B5BD |

CODE_80B5BF:
  STA.B $FA                                 ; $80B5BF |
  LDA.B $10                                 ; $80B5C1 |
  ADC.W $1000,Y                             ; $80B5C3 |
  CMP.W #$0100                              ; $80B5C6 |
  BCS CODE_80B60C                           ; $80B5C9 |
  SEP #$20                                  ; $80B5CB |

CODE_80B5CD:
  PHA                                       ; $80B5CD |
  LDA.B $FA                                 ; $80B5CE |
  PHA                                       ; $80B5D0 |
  LDA.W $3000,Y                             ; $80B5D1 |
  PHA                                       ; $80B5D4 |
  LDA.W $3001,Y                             ; $80B5D5 |
  AND.B $12                                 ; $80B5D8 |
  EOR.B $17                                 ; $80B5DA |
  ORA.B $1A                                 ; $80B5DC |
  PHA                                       ; $80B5DE |
  ROR.B $0A                                 ; $80B5DF |
  TXA                                       ; $80B5E1 |
  LSR A                                     ; $80B5E2 |
  ROR.B $0A                                 ; $80B5E3 |
  BCS CODE_80B5EE                           ; $80B5E5 |

CODE_80B5E7:
  DEC.B $1B                                 ; $80B5E7 |
  BNE CODE_80B5AE                           ; $80B5E9 |

CODE_80B5EB:
  JMP.W ($0000)                             ; $80B5EB |


CODE_80B5EE:
  LDA.B $0A                                 ; $80B5EE |
  STA.B ($08)                               ; $80B5F0 |
  INC.B $08                                 ; $80B5F2 |
  BEQ CODE_80B5EB                           ; $80B5F4 |
  LDA.B #$80                                ; $80B5F6 |
  STA.B $0A                                 ; $80B5F8 |
  CLC                                       ; $80B5FA |
  BRA CODE_80B5E7                           ; $80B5FB |


CODE_80B5FD:
  CMP.W #$FFF0                              ; $80B5FD |
  AND.W #$00FF                              ; $80B600 |
  BCC CODE_80B608                           ; $80B603 |
  CLC                                       ; $80B605 |
  BRA CODE_80B5BF                           ; $80B606 |


CODE_80B608:
  SEP #$20                                  ; $80B608 |
  BRA CODE_80B5E7                           ; $80B60A |


CODE_80B60C:
  CMP.W #$FFF0                              ; $80B60C |
  SEP #$20                                  ; $80B60F |
  BCS CODE_80B5CD                           ; $80B611 |
  BRA CODE_80B5E7                           ; $80B613 |


CODE_80B615:
  SEC                                       ; $80B615 |
  SBC.B $6E                                 ; $80B616 |
  STA.B $13                                 ; $80B618 |
  SEC                                       ; $80B61A |
  SBC.B $6C                                 ; $80B61B |
  STA.B $10                                 ; $80B61D |
  SEP #$20                                  ; $80B61F |
  CLC                                       ; $80B621 |
  TDC                                       ; $80B622 |
  LDA.W $0000,Y                             ; $80B623 |
  TAX                                       ; $80B626 |
  BRA CODE_80B62E                           ; $80B627 |


CODE_80B629:
  INY                                       ; $80B629 |
  INY                                       ; $80B62A |
  LDX.W $0000,Y                             ; $80B62B |

CODE_80B62E:
  REP #$20                                  ; $80B62E |
  LDA.B $15                                 ; $80B630 |
  ADC.W $2000,Y                             ; $80B632 |
  CMP.W #$00F0                              ; $80B635 |
  BCS CODE_80B678                           ; $80B638 |

CODE_80B63A:
  STA.B $FA                                 ; $80B63A |
  LDA.B $10,X                               ; $80B63C |
  SBC.W $1000,Y                             ; $80B63E |
  CMP.W #$0100                              ; $80B641 |
  BCS CODE_80B687                           ; $80B644 |
  SEP #$20                                  ; $80B646 |

CODE_80B648:
  PHA                                       ; $80B648 |
  LDA.B $FA                                 ; $80B649 |
  PHA                                       ; $80B64B |
  LDA.W $3000,Y                             ; $80B64C |
  PHA                                       ; $80B64F |
  LDA.W $3001,Y                             ; $80B650 |
  AND.B $12                                 ; $80B653 |
  EOR.B $17                                 ; $80B655 |
  ORA.B $1A                                 ; $80B657 |
  PHA                                       ; $80B659 |
  ROR.B $0A                                 ; $80B65A |
  TXA                                       ; $80B65C |
  LSR A                                     ; $80B65D |
  ROR.B $0A                                 ; $80B65E |
  BCS CODE_80B669                           ; $80B660 |

CODE_80B662:
  DEC.B $1B                                 ; $80B662 |
  BNE CODE_80B629                           ; $80B664 |

CODE_80B666:
  JMP.W ($0000)                             ; $80B666 |


CODE_80B669:
  LDA.B $0A                                 ; $80B669 |
  STA.B ($08)                               ; $80B66B |
  INC.B $08                                 ; $80B66D |
  BEQ CODE_80B666                           ; $80B66F |
  LDA.B #$80                                ; $80B671 |
  STA.B $0A                                 ; $80B673 |
  CLC                                       ; $80B675 |
  BRA CODE_80B662                           ; $80B676 |


CODE_80B678:
  CMP.W #$FFF0                              ; $80B678 |
  AND.W #$00FF                              ; $80B67B |
  BCC CODE_80B683                           ; $80B67E |
  CLC                                       ; $80B680 |
  BRA CODE_80B63A                           ; $80B681 |


CODE_80B683:
  SEP #$20                                  ; $80B683 |
  BRA CODE_80B662                           ; $80B685 |


CODE_80B687:
  CMP.W #$FFF0                              ; $80B687 |
  SEP #$20                                  ; $80B68A |
  BCS CODE_80B648                           ; $80B68C |
  BRA CODE_80B662                           ; $80B68E |


CODE_JP_80B690:
  SBC.B $6E                                 ; $80B690 |
  STA.B $18                                 ; $80B692 |
  SEC                                       ; $80B694 |
  SBC.B $6C                                 ; $80B695 |
  STA.B $15                                 ; $80B697 |
  LDA.B $09,X                               ; $80B699 |
  BIT.B $16                                 ; $80B69B |
  BVS CODE_80B712                           ; $80B69D |
  STA.B $10                                 ; $80B69F |
  SEP #$20                                  ; $80B6A1 |
  CLC                                       ; $80B6A3 |
  TDC                                       ; $80B6A4 |
  LDA.W $0000,Y                             ; $80B6A5 |
  TAX                                       ; $80B6A8 |
  BRA CODE_80B6B0                           ; $80B6A9 |


CODE_80B6AB:
  INY                                       ; $80B6AB |
  INY                                       ; $80B6AC |
  LDX.W $0000,Y                             ; $80B6AD |

CODE_80B6B0:
  REP #$20                                  ; $80B6B0 |
  LDA.B $15,X                               ; $80B6B2 |
  SBC.W $2000,Y                             ; $80B6B4 |
  CMP.W #$00F0                              ; $80B6B7 |
  BCS CODE_80B6FA                           ; $80B6BA |

CODE_80B6BC:
  STA.B $FA                                 ; $80B6BC |
  LDA.B $10                                 ; $80B6BE |
  ADC.W $1000,Y                             ; $80B6C0 |
  CMP.W #$0100                              ; $80B6C3 |
  BCS CODE_80B709                           ; $80B6C6 |
  SEP #$20                                  ; $80B6C8 |

CODE_80B6CA:
  PHA                                       ; $80B6CA |
  LDA.B $FA                                 ; $80B6CB |
  PHA                                       ; $80B6CD |
  LDA.W $3000,Y                             ; $80B6CE |
  PHA                                       ; $80B6D1 |
  LDA.W $3001,Y                             ; $80B6D2 |
  AND.B $12                                 ; $80B6D5 |
  EOR.B $17                                 ; $80B6D7 |
  ORA.B $1A                                 ; $80B6D9 |
  PHA                                       ; $80B6DB |
  ROR.B $0A                                 ; $80B6DC |
  TXA                                       ; $80B6DE |
  LSR A                                     ; $80B6DF |
  ROR.B $0A                                 ; $80B6E0 |
  BCS CODE_80B6EB                           ; $80B6E2 |

CODE_80B6E4:
  DEC.B $1B                                 ; $80B6E4 |
  BNE CODE_80B6AB                           ; $80B6E6 |

CODE_80B6E8:
  JMP.W ($0000)                             ; $80B6E8 |


CODE_80B6EB:
  LDA.B $0A                                 ; $80B6EB |
  STA.B ($08)                               ; $80B6ED |
  INC.B $08                                 ; $80B6EF |
  BEQ CODE_80B6E8                           ; $80B6F1 |
  LDA.B #$80                                ; $80B6F3 |
  STA.B $0A                                 ; $80B6F5 |
  CLC                                       ; $80B6F7 |
  BRA CODE_80B6E4                           ; $80B6F8 |


CODE_80B6FA:
  CMP.W #$FFF0                              ; $80B6FA |
  AND.W #$00FF                              ; $80B6FD |
  BCC CODE_80B705                           ; $80B700 |
  CLC                                       ; $80B702 |
  BRA CODE_80B6BC                           ; $80B703 |


CODE_80B705:
  SEP #$20                                  ; $80B705 |
  BRA CODE_80B6E4                           ; $80B707 |


CODE_80B709:
  CMP.W #$FFF0                              ; $80B709 |
  SEP #$20                                  ; $80B70C |
  BCS CODE_80B6CA                           ; $80B70E |
  BRA CODE_80B6E4                           ; $80B710 |


CODE_80B712:
  SEC                                       ; $80B712 |
  SBC.B $6E                                 ; $80B713 |
  STA.B $13                                 ; $80B715 |
  SEC                                       ; $80B717 |
  SBC.B $6C                                 ; $80B718 |
  STA.B $10                                 ; $80B71A |
  SEP #$20                                  ; $80B71C |
  CLC                                       ; $80B71E |
  TDC                                       ; $80B71F |
  LDA.W $0000,Y                             ; $80B720 |
  TAX                                       ; $80B723 |
  BRA CODE_80B72B                           ; $80B724 |


CODE_80B726:
  INY                                       ; $80B726 |
  INY                                       ; $80B727 |
  LDX.W $0000,Y                             ; $80B728 |

CODE_80B72B:
  REP #$20                                  ; $80B72B |
  LDA.B $15,X                               ; $80B72D |
  SBC.W $2000,Y                             ; $80B72F |
  CMP.W #$00F0                              ; $80B732 |
  BCS CODE_80B775                           ; $80B735 |

CODE_80B737:
  STA.B $FA                                 ; $80B737 |
  LDA.B $10,X                               ; $80B739 |
  SBC.W $1000,Y                             ; $80B73B |
  CMP.W #$0100                              ; $80B73E |
  BCS CODE_80B784                           ; $80B741 |
  SEP #$20                                  ; $80B743 |

CODE_80B745:
  PHA                                       ; $80B745 |
  LDA.B $FA                                 ; $80B746 |
  PHA                                       ; $80B748 |
  LDA.W $3000,Y                             ; $80B749 |
  PHA                                       ; $80B74C |
  LDA.W $3001,Y                             ; $80B74D |
  AND.B $12                                 ; $80B750 |
  EOR.B $17                                 ; $80B752 |
  ORA.B $1A                                 ; $80B754 |
  PHA                                       ; $80B756 |
  ROR.B $0A                                 ; $80B757 |
  TXA                                       ; $80B759 |
  LSR A                                     ; $80B75A |
  ROR.B $0A                                 ; $80B75B |
  BCS CODE_80B766                           ; $80B75D |

CODE_80B75F:
  DEC.B $1B                                 ; $80B75F |
  BNE CODE_80B726                           ; $80B761 |

CODE_80B763:
  JMP.W ($0000)                             ; $80B763 |


CODE_80B766:
  LDA.B $0A                                 ; $80B766 |
  STA.B ($08)                               ; $80B768 |
  INC.B $08                                 ; $80B76A |
  BEQ CODE_80B763                           ; $80B76C |
  LDA.B #$80                                ; $80B76E |
  STA.B $0A                                 ; $80B770 |
  CLC                                       ; $80B772 |
  BRA CODE_80B75F                           ; $80B773 |


CODE_80B775:
  CMP.W #$FFF0                              ; $80B775 |
  AND.W #$00FF                              ; $80B778 |
  BCC CODE_80B780                           ; $80B77B |
  CLC                                       ; $80B77D |
  BRA CODE_80B737                           ; $80B77E |


CODE_80B780:
  SEP #$20                                  ; $80B780 |
  BRA CODE_80B75F                           ; $80B782 |


CODE_80B784:
  CMP.W #$FFF0                              ; $80B784 |
  SEP #$20                                  ; $80B787 |
  BCS CODE_80B745                           ; $80B789 |
  BRA CODE_80B75F                           ; $80B78B |


CODE_80B78D:
  JMP.W CODE_JP_80B89D                      ; $80B78D |


CODE_JP_80B790:
  STA.B $0B                                 ; $80B790 |
  LDA.B $04,X                               ; $80B792 |
  ASL A                                     ; $80B794 |
  AND.B #$F0                                ; $80B795 |
  STA.B $17                                 ; $80B797 |
  ASL A                                     ; $80B799 |
  LDA.W $0001,Y                             ; $80B79A |
  STA.B $1B                                 ; $80B79D |
  REP #$20                                  ; $80B79F |
  LDA.B $15                                 ; $80B7A1 |
  BCS CODE_80B78D                           ; $80B7A3 |
  LDA.B $09,X                               ; $80B7A5 |
  BIT.B $16                                 ; $80B7A7 |
  BVS CODE_80B820                           ; $80B7A9 |
  STA.B $10                                 ; $80B7AB |
  SEP #$20                                  ; $80B7AD |
  CLC                                       ; $80B7AF |
  TDC                                       ; $80B7B0 |
  LDA.W $0000,Y                             ; $80B7B1 |
  TAX                                       ; $80B7B4 |
  BRA CODE_80B7BC                           ; $80B7B5 |


CODE_80B7B7:
  INY                                       ; $80B7B7 |
  INY                                       ; $80B7B8 |
  LDX.W $0000,Y                             ; $80B7B9 |

CODE_80B7BC:
  REP #$20                                  ; $80B7BC |
  LDA.B $15                                 ; $80B7BE |
  ADC.W $2000,Y                             ; $80B7C0 |
  CMP.W #$00F0                              ; $80B7C3 |
  BCS CODE_80B808                           ; $80B7C6 |

CODE_80B7C8:
  STA.B $FA                                 ; $80B7C8 |
  LDA.B $10                                 ; $80B7CA |
  ADC.W $1000,Y                             ; $80B7CC |
  CMP.W #$0100                              ; $80B7CF |
  BCS CODE_80B817                           ; $80B7D2 |
  SEP #$20                                  ; $80B7D4 |

CODE_80B7D6:
  PHA                                       ; $80B7D6 |
  ROR.B $0A                                 ; $80B7D7 |
  LDA.B $FA                                 ; $80B7D9 |
  PHA                                       ; $80B7DB |
  LDA.W $3000,Y                             ; $80B7DC |
  ADC.B $0B                                 ; $80B7DF |
  PHA                                       ; $80B7E1 |
  LDA.W $3001,Y                             ; $80B7E2 |
  AND.B $12                                 ; $80B7E5 |
  EOR.B $17                                 ; $80B7E7 |
  ORA.B $1A                                 ; $80B7E9 |
  PHA                                       ; $80B7EB |
  TXA                                       ; $80B7EC |
  LSR A                                     ; $80B7ED |
  ROR.B $0A                                 ; $80B7EE |
  BCS CODE_80B7F9                           ; $80B7F0 |

CODE_80B7F2:
  DEC.B $1B                                 ; $80B7F2 |
  BNE CODE_80B7B7                           ; $80B7F4 |

CODE_80B7F6:
  JMP.W ($0000)                             ; $80B7F6 |


CODE_80B7F9:
  LDA.B $0A                                 ; $80B7F9 |
  STA.B ($08)                               ; $80B7FB |
  INC.B $08                                 ; $80B7FD |
  BEQ CODE_80B7F6                           ; $80B7FF |
  LDA.B #$80                                ; $80B801 |
  STA.B $0A                                 ; $80B803 |
  CLC                                       ; $80B805 |
  BRA CODE_80B7F2                           ; $80B806 |


CODE_80B808:
  CMP.W #$FFF0                              ; $80B808 |
  AND.W #$00FF                              ; $80B80B |
  BCC CODE_80B813                           ; $80B80E |
  CLC                                       ; $80B810 |
  BRA CODE_80B7C8                           ; $80B811 |


CODE_80B813:
  SEP #$20                                  ; $80B813 |
  BRA CODE_80B7F2                           ; $80B815 |


CODE_80B817:
  CMP.W #$FFF0                              ; $80B817 |
  SEP #$20                                  ; $80B81A |
  BCS CODE_80B7D6                           ; $80B81C |
  BRA CODE_80B7F2                           ; $80B81E |


CODE_80B820:
  SEC                                       ; $80B820 |
  SBC.B $6E                                 ; $80B821 |
  STA.B $13                                 ; $80B823 |
  SEC                                       ; $80B825 |
  SBC.B $6C                                 ; $80B826 |
  STA.B $10                                 ; $80B828 |
  SEP #$20                                  ; $80B82A |
  CLC                                       ; $80B82C |
  TDC                                       ; $80B82D |
  LDA.W $0000,Y                             ; $80B82E |
  TAX                                       ; $80B831 |
  BRA CODE_80B839                           ; $80B832 |


CODE_80B834:
  INY                                       ; $80B834 |
  INY                                       ; $80B835 |
  LDX.W $0000,Y                             ; $80B836 |

CODE_80B839:
  REP #$20                                  ; $80B839 |
  LDA.B $15                                 ; $80B83B |
  ADC.W $2000,Y                             ; $80B83D |
  CMP.W #$00F0                              ; $80B840 |
  BCS CODE_80B885                           ; $80B843 |

CODE_80B845:
  STA.B $FA                                 ; $80B845 |
  LDA.B $10,X                               ; $80B847 |
  SBC.W $1000,Y                             ; $80B849 |
  CMP.W #$0100                              ; $80B84C |
  BCS CODE_80B894                           ; $80B84F |
  SEP #$20                                  ; $80B851 |

CODE_80B853:
  PHA                                       ; $80B853 |
  ROR.B $0A                                 ; $80B854 |
  LDA.B $FA                                 ; $80B856 |
  PHA                                       ; $80B858 |
  LDA.W $3000,Y                             ; $80B859 |
  ADC.B $0B                                 ; $80B85C |
  PHA                                       ; $80B85E |
  LDA.W $3001,Y                             ; $80B85F |
  AND.B $12                                 ; $80B862 |
  EOR.B $17                                 ; $80B864 |
  ORA.B $1A                                 ; $80B866 |
  PHA                                       ; $80B868 |
  TXA                                       ; $80B869 |
  LSR A                                     ; $80B86A |
  ROR.B $0A                                 ; $80B86B |
  BCS CODE_80B876                           ; $80B86D |

CODE_80B86F:
  DEC.B $1B                                 ; $80B86F |
  BNE CODE_80B834                           ; $80B871 |

CODE_80B873:
  JMP.W ($0000)                             ; $80B873 |


CODE_80B876:
  LDA.B $0A                                 ; $80B876 |
  STA.B ($08)                               ; $80B878 |
  INC.B $08                                 ; $80B87A |
  BEQ CODE_80B873                           ; $80B87C |
  LDA.B #$80                                ; $80B87E |
  STA.B $0A                                 ; $80B880 |
  CLC                                       ; $80B882 |
  BRA CODE_80B86F                           ; $80B883 |


CODE_80B885:
  CMP.W #$FFF0                              ; $80B885 |
  AND.W #$00FF                              ; $80B888 |
  BCC CODE_80B890                           ; $80B88B |
  CLC                                       ; $80B88D |
  BRA CODE_80B845                           ; $80B88E |


CODE_80B890:
  SEP #$20                                  ; $80B890 |
  BRA CODE_80B86F                           ; $80B892 |


CODE_80B894:
  CMP.W #$FFF0                              ; $80B894 |
  SEP #$20                                  ; $80B897 |
  BCS CODE_80B853                           ; $80B899 |
  BRA CODE_80B86F                           ; $80B89B |


CODE_JP_80B89D:
  SBC.B $6E                                 ; $80B89D |
  STA.B $18                                 ; $80B89F |
  SEC                                       ; $80B8A1 |
  SBC.B $6C                                 ; $80B8A2 |
  STA.B $15                                 ; $80B8A4 |
  LDA.B $09,X                               ; $80B8A6 |
  BIT.B $16                                 ; $80B8A8 |
  BVS CODE_80B921                           ; $80B8AA |
  STA.B $10                                 ; $80B8AC |
  SEP #$20                                  ; $80B8AE |
  CLC                                       ; $80B8B0 |
  TDC                                       ; $80B8B1 |
  LDA.W $0000,Y                             ; $80B8B2 |
  TAX                                       ; $80B8B5 |
  BRA CODE_80B8BD                           ; $80B8B6 |


CODE_80B8B8:
  INY                                       ; $80B8B8 |
  INY                                       ; $80B8B9 |
  LDX.W $0000,Y                             ; $80B8BA |

CODE_80B8BD:
  REP #$20                                  ; $80B8BD |
  LDA.B $15,X                               ; $80B8BF |
  SBC.W $2000,Y                             ; $80B8C1 |
  CMP.W #$00F0                              ; $80B8C4 |
  BCS CODE_80B909                           ; $80B8C7 |

CODE_80B8C9:
  STA.B $FA                                 ; $80B8C9 |
  LDA.B $10                                 ; $80B8CB |
  ADC.W $1000,Y                             ; $80B8CD |
  CMP.W #$0100                              ; $80B8D0 |
  BCS CODE_80B918                           ; $80B8D3 |
  SEP #$20                                  ; $80B8D5 |

CODE_80B8D7:
  PHA                                       ; $80B8D7 |
  ROR.B $0A                                 ; $80B8D8 |
  LDA.B $FA                                 ; $80B8DA |
  PHA                                       ; $80B8DC |
  LDA.W $3000,Y                             ; $80B8DD |
  ADC.B $0B                                 ; $80B8E0 |
  PHA                                       ; $80B8E2 |
  LDA.W $3001,Y                             ; $80B8E3 |
  AND.B $12                                 ; $80B8E6 |
  EOR.B $17                                 ; $80B8E8 |
  ORA.B $1A                                 ; $80B8EA |
  PHA                                       ; $80B8EC |
  TXA                                       ; $80B8ED |
  LSR A                                     ; $80B8EE |
  ROR.B $0A                                 ; $80B8EF |
  BCS CODE_80B8FA                           ; $80B8F1 |

CODE_80B8F3:
  DEC.B $1B                                 ; $80B8F3 |
  BNE CODE_80B8B8                           ; $80B8F5 |

CODE_80B8F7:
  JMP.W ($0000)                             ; $80B8F7 |


CODE_80B8FA:
  LDA.B $0A                                 ; $80B8FA |
  STA.B ($08)                               ; $80B8FC |
  INC.B $08                                 ; $80B8FE |
  BEQ CODE_80B8F7                           ; $80B900 |
  LDA.B #$80                                ; $80B902 |
  STA.B $0A                                 ; $80B904 |
  CLC                                       ; $80B906 |
  BRA CODE_80B8F3                           ; $80B907 |


CODE_80B909:
  CMP.W #$FFF0                              ; $80B909 |
  AND.W #$00FF                              ; $80B90C |
  BCC CODE_80B914                           ; $80B90F |
  CLC                                       ; $80B911 |
  BRA CODE_80B8C9                           ; $80B912 |


CODE_80B914:
  SEP #$20                                  ; $80B914 |
  BRA CODE_80B8F3                           ; $80B916 |


CODE_80B918:
  CMP.W #$FFF0                              ; $80B918 |
  SEP #$20                                  ; $80B91B |
  BCS CODE_80B8D7                           ; $80B91D |
  BRA CODE_80B8F3                           ; $80B91F |


CODE_80B921:
  SEC                                       ; $80B921 |
  SBC.B $6E                                 ; $80B922 |
  STA.B $13                                 ; $80B924 |
  SEC                                       ; $80B926 |
  SBC.B $6C                                 ; $80B927 |
  STA.B $10                                 ; $80B929 |
  SEP #$20                                  ; $80B92B |
  CLC                                       ; $80B92D |
  TDC                                       ; $80B92E |
  LDA.W $0000,Y                             ; $80B92F |
  TAX                                       ; $80B932 |
  BRA CODE_80B93A                           ; $80B933 |


CODE_80B935:
  INY                                       ; $80B935 |
  INY                                       ; $80B936 |
  LDX.W $0000,Y                             ; $80B937 |

CODE_80B93A:
  REP #$20                                  ; $80B93A |
  LDA.B $15,X                               ; $80B93C |
  SBC.W $2000,Y                             ; $80B93E |
  CMP.W #$00F0                              ; $80B941 |
  BCS CODE_80B986                           ; $80B944 |

CODE_80B946:
  STA.B $FA                                 ; $80B946 |
  LDA.B $10,X                               ; $80B948 |
  SBC.W $1000,Y                             ; $80B94A |
  CMP.W #$0100                              ; $80B94D |
  BCS CODE_80B995                           ; $80B950 |
  SEP #$20                                  ; $80B952 |

CODE_80B954:
  PHA                                       ; $80B954 |
  ROR.B $0A                                 ; $80B955 |
  LDA.B $FA                                 ; $80B957 |
  PHA                                       ; $80B959 |
  LDA.W $3000,Y                             ; $80B95A |
  ADC.B $0B                                 ; $80B95D |
  PHA                                       ; $80B95F |
  LDA.W $3001,Y                             ; $80B960 |
  AND.B $12                                 ; $80B963 |
  EOR.B $17                                 ; $80B965 |
  ORA.B $1A                                 ; $80B967 |
  PHA                                       ; $80B969 |
  TXA                                       ; $80B96A |
  LSR A                                     ; $80B96B |
  ROR.B $0A                                 ; $80B96C |
  BCS CODE_80B977                           ; $80B96E |

CODE_80B970:
  DEC.B $1B                                 ; $80B970 |
  BNE CODE_80B935                           ; $80B972 |

CODE_80B974:
  JMP.W ($0000)                             ; $80B974 |


CODE_80B977:
  LDA.B $0A                                 ; $80B977 |
  STA.B ($08)                               ; $80B979 |
  INC.B $08                                 ; $80B97B |
  BEQ CODE_80B974                           ; $80B97D |
  LDA.B #$80                                ; $80B97F |
  STA.B $0A                                 ; $80B981 |
  CLC                                       ; $80B983 |
  BRA CODE_80B970                           ; $80B984 |


CODE_80B986:
  CMP.W #$FFF0                              ; $80B986 |
  AND.W #$00FF                              ; $80B989 |
  BCC CODE_80B991                           ; $80B98C |
  CLC                                       ; $80B98E |
  BRA CODE_80B946                           ; $80B98F |


CODE_80B991:
  SEP #$20                                  ; $80B991 |
  BRA CODE_80B970                           ; $80B993 |


CODE_80B995:
  CMP.W #$FFF0                              ; $80B995 |
  SEP #$20                                  ; $80B998 |
  BCS CODE_80B954                           ; $80B99A |
  BRA CODE_80B970                           ; $80B99C |


CODE_80B99E:
  JMP.W CODE_JP_80BB1D                      ; $80B99E |


CODE_80B9A1:
  JMP.W CODE_JP_80BA83                      ; $80B9A1 |


CODE_JP_80B9A4:
  CPY.W #$D9F0                              ; $80B9A4 |
  BCS CODE_80B9C0                           ; $80B9A7 |
  CPX.W #$0B20                              ; $80B9A9 |
  BCS CODE_80B9C0                           ; $80B9AC |
  CPX.W #$0850                              ; $80B9AE |
  BCS CODE_80B9BC                           ; $80B9B1 |
  CPX.W #$04C0                              ; $80B9B3 |
  BEQ CODE_80B9BC                           ; $80B9B6 |
  PEI.B ($03)                               ; $80B9B8 |
  BRA CODE_80B9C3                           ; $80B9BA |


CODE_80B9BC:
  PEI.B ($04)                               ; $80B9BC |
  BRA CODE_80B9C3                           ; $80B9BE |


CODE_80B9C0:
  PEA.W $9393                               ; $80B9C0 |

CODE_80B9C3:
  PLB                                       ; $80B9C3 |
  PLB                                       ; $80B9C4 |
  ASL A                                     ; $80B9C5 |
  BMI CODE_80B9CE                           ; $80B9C6 |
  STA.B $1A                                 ; $80B9C8 |
  LDA.B #$CF                                ; $80B9CA |
  BRA CODE_80B9D4                           ; $80B9CC |


CODE_80B9CE:
  AND.B #$0E                                ; $80B9CE |
  STA.B $1A                                 ; $80B9D0 |
  LDA.B #$C1                                ; $80B9D2 |

CODE_80B9D4:
  STA.B $12                                 ; $80B9D4 |
  TDC                                       ; $80B9D6 |
  LDA.B $06,X                               ; $80B9D7 |
  STA.B $0B                                 ; $80B9D9 |
  LDA.B $04,X                               ; $80B9DB |

CODE_JP_80B9DD:
  ASL A                                     ; $80B9DD |
  AND.B #$F0                                ; $80B9DE |
  STA.B $17                                 ; $80B9E0 |
  ASL A                                     ; $80B9E2 |
  LDA.W $0000,Y                             ; $80B9E3 |
  STA.B $1B                                 ; $80B9E6 |
  REP #$20                                  ; $80B9E8 |
  LDA.B $15                                 ; $80B9EA |
  BCS CODE_80B99E                           ; $80B9EC |
  LDA.B $09,X                               ; $80B9EE |
  BIT.B $16                                 ; $80B9F0 |
  BVS CODE_80B9A1                           ; $80B9F2 |
  STA.B $10                                 ; $80B9F4 |
  SEP #$20                                  ; $80B9F6 |
  CLC                                       ; $80B9F8 |
  TDC                                       ; $80B9F9 |

CODE_80B9FA:
  LDA.W $0004,Y                             ; $80B9FA |
  AND.B #$10                                ; $80B9FD |
  BEQ CODE_80BA03                           ; $80B9FF |
  LDA.B #$03                                ; $80BA01 |

CODE_80BA03:
  TAX                                       ; $80BA03 |
  STZ.B $1D                                 ; $80BA04 |
  LDA.W $0002,Y                             ; $80BA06 |
  STA.B $1C                                 ; $80BA09 |
  BPL CODE_80BA0F                           ; $80BA0B |
  DEC.B $1D                                 ; $80BA0D |

CODE_80BA0F:
  STZ.B $1F                                 ; $80BA0F |
  LDA.W $0001,Y                             ; $80BA11 |
  STA.B $1E                                 ; $80BA14 |
  BPL CODE_80BA1A                           ; $80BA16 |
  DEC.B $1F                                 ; $80BA18 |

CODE_80BA1A:
  REP #$20                                  ; $80BA1A |
  LDA.B $15                                 ; $80BA1C |
  ADC.B $1E                                 ; $80BA1E |
  CMP.W #$00F0                              ; $80BA20 |
  BCS CODE_80BA68                           ; $80BA23 |

CODE_80BA25:
  STA.B $FA                                 ; $80BA25 |
  LDA.B $10                                 ; $80BA27 |
  ADC.B $1C                                 ; $80BA29 |
  CMP.W #$0100                              ; $80BA2B |
  BCS CODE_80BA77                           ; $80BA2E |
  SEP #$20                                  ; $80BA30 |

CODE_80BA32:
  PHA                                       ; $80BA32 |
  ROR.B $0A                                 ; $80BA33 |
  LDA.B $FA                                 ; $80BA35 |
  PHA                                       ; $80BA37 |
  LDA.W $0003,Y                             ; $80BA38 |
  ADC.B $0B                                 ; $80BA3B |
  PHA                                       ; $80BA3D |
  LDA.W $0004,Y                             ; $80BA3E |
  AND.B $12                                 ; $80BA41 |
  EOR.B $17                                 ; $80BA43 |
  ORA.B $1A                                 ; $80BA45 |
  PHA                                       ; $80BA47 |
  TXA                                       ; $80BA48 |
  LSR A                                     ; $80BA49 |
  ROR.B $0A                                 ; $80BA4A |
  BCS CODE_80BA59                           ; $80BA4C |

CODE_80BA4E:
  INY                                       ; $80BA4E |
  INY                                       ; $80BA4F |
  INY                                       ; $80BA50 |
  INY                                       ; $80BA51 |
  DEC.B $1B                                 ; $80BA52 |
  BNE CODE_80B9FA                           ; $80BA54 |

CODE_80BA56:
  JMP.W ($0000)                             ; $80BA56 |


CODE_80BA59:
  LDA.B $0A                                 ; $80BA59 |
  STA.B ($08)                               ; $80BA5B |
  INC.B $08                                 ; $80BA5D |
  BEQ CODE_80BA56                           ; $80BA5F |
  LDA.B #$80                                ; $80BA61 |
  STA.B $0A                                 ; $80BA63 |
  CLC                                       ; $80BA65 |
  BRA CODE_80BA4E                           ; $80BA66 |


CODE_80BA68:
  CMP.W #$FFF0                              ; $80BA68 |
  AND.W #$00FF                              ; $80BA6B |
  BCC CODE_80BA73                           ; $80BA6E |
  CLC                                       ; $80BA70 |
  BRA CODE_80BA25                           ; $80BA71 |


CODE_80BA73:
  SEP #$20                                  ; $80BA73 |
  BRA CODE_80BA4E                           ; $80BA75 |


CODE_80BA77:
  CMP.W #$FFF0                              ; $80BA77 |
  AND.W #$00FF                              ; $80BA7A |
  SEP #$20                                  ; $80BA7D |
  BCS CODE_80BA32                           ; $80BA7F |
  BRA CODE_80BA4E                           ; $80BA81 |


CODE_JP_80BA83:
  SEC                                       ; $80BA83 |
  SBC.B $6E                                 ; $80BA84 |
  STA.B $13                                 ; $80BA86 |
  SEC                                       ; $80BA88 |
  SBC.B $6C                                 ; $80BA89 |
  STA.B $10                                 ; $80BA8B |
  SEP #$20                                  ; $80BA8D |
  CLC                                       ; $80BA8F |
  TDC                                       ; $80BA90 |

CODE_80BA91:
  LDA.W $0004,Y                             ; $80BA91 |
  AND.B #$10                                ; $80BA94 |
  BEQ CODE_80BA9A                           ; $80BA96 |
  LDA.B #$03                                ; $80BA98 |

CODE_80BA9A:
  TAX                                       ; $80BA9A |
  STZ.B $1D                                 ; $80BA9B |
  LDA.W $0002,Y                             ; $80BA9D |
  STA.B $1C                                 ; $80BAA0 |
  BPL CODE_80BAA6                           ; $80BAA2 |
  DEC.B $1D                                 ; $80BAA4 |

CODE_80BAA6:
  STZ.B $1F                                 ; $80BAA6 |
  LDA.W $0001,Y                             ; $80BAA8 |
  STA.B $1E                                 ; $80BAAB |
  BPL CODE_80BAB1                           ; $80BAAD |
  DEC.B $1F                                 ; $80BAAF |

CODE_80BAB1:
  REP #$20                                  ; $80BAB1 |
  LDA.B $15                                 ; $80BAB3 |
  ADC.B $1E                                 ; $80BAB5 |
  CMP.W #$00F0                              ; $80BAB7 |
  BCS CODE_80BAFF                           ; $80BABA |

CODE_80BABC:
  STA.B $FA                                 ; $80BABC |
  LDA.B $10,X                               ; $80BABE |
  SBC.B $1C                                 ; $80BAC0 |
  CMP.W #$0100                              ; $80BAC2 |
  BCS CODE_80BB0E                           ; $80BAC5 |
  SEP #$20                                  ; $80BAC7 |

CODE_80BAC9:
  PHA                                       ; $80BAC9 |
  ROR.B $0A                                 ; $80BACA |
  LDA.B $FA                                 ; $80BACC |
  PHA                                       ; $80BACE |
  LDA.W $0003,Y                             ; $80BACF |
  ADC.B $0B                                 ; $80BAD2 |
  PHA                                       ; $80BAD4 |
  LDA.W $0004,Y                             ; $80BAD5 |
  AND.B $12                                 ; $80BAD8 |
  EOR.B $17                                 ; $80BADA |
  ORA.B $1A                                 ; $80BADC |
  PHA                                       ; $80BADE |
  TXA                                       ; $80BADF |
  LSR A                                     ; $80BAE0 |
  ROR.B $0A                                 ; $80BAE1 |
  BCS CODE_80BAF0                           ; $80BAE3 |

CODE_80BAE5:
  INY                                       ; $80BAE5 |
  INY                                       ; $80BAE6 |
  INY                                       ; $80BAE7 |
  INY                                       ; $80BAE8 |
  DEC.B $1B                                 ; $80BAE9 |
  BNE CODE_80BA91                           ; $80BAEB |

CODE_80BAED:
  JMP.W ($0000)                             ; $80BAED |


CODE_80BAF0:
  LDA.B $0A                                 ; $80BAF0 |
  STA.B ($08)                               ; $80BAF2 |
  INC.B $08                                 ; $80BAF4 |
  BEQ CODE_80BAED                           ; $80BAF6 |
  LDA.B #$80                                ; $80BAF8 |
  STA.B $0A                                 ; $80BAFA |
  CLC                                       ; $80BAFC |
  BRA CODE_80BAE5                           ; $80BAFD |


CODE_80BAFF:
  CMP.W #$FFF0                              ; $80BAFF |
  AND.W #$00FF                              ; $80BB02 |
  BCC CODE_80BB0A                           ; $80BB05 |
  CLC                                       ; $80BB07 |
  BRA CODE_80BABC                           ; $80BB08 |


CODE_80BB0A:
  SEP #$20                                  ; $80BB0A |
  BRA CODE_80BAE5                           ; $80BB0C |


CODE_80BB0E:
  CMP.W #$FFF0                              ; $80BB0E |
  AND.W #$00FF                              ; $80BB11 |
  SEP #$20                                  ; $80BB14 |
  BCS CODE_80BAC9                           ; $80BB16 |
  BRA CODE_80BAE5                           ; $80BB18 |


CODE_80BB1A:
  JMP.W CODE_JP_80BBBB                      ; $80BB1A |


CODE_JP_80BB1D:
  SBC.B $6E                                 ; $80BB1D |
  STA.B $18                                 ; $80BB1F |
  SEC                                       ; $80BB21 |
  SBC.B $6C                                 ; $80BB22 |
  STA.B $15                                 ; $80BB24 |
  LDA.B $09,X                               ; $80BB26 |
  BIT.B $16                                 ; $80BB28 |
  BVS CODE_80BB1A                           ; $80BB2A |
  STA.B $10                                 ; $80BB2C |
  SEP #$20                                  ; $80BB2E |
  CLC                                       ; $80BB30 |
  TDC                                       ; $80BB31 |

CODE_80BB32:
  LDA.W $0004,Y                             ; $80BB32 |
  AND.B #$10                                ; $80BB35 |
  BEQ CODE_80BB3B                           ; $80BB37 |
  LDA.B #$03                                ; $80BB39 |

CODE_80BB3B:
  TAX                                       ; $80BB3B |
  STZ.B $1D                                 ; $80BB3C |
  LDA.W $0002,Y                             ; $80BB3E |
  STA.B $1C                                 ; $80BB41 |
  BPL CODE_80BB47                           ; $80BB43 |
  DEC.B $1D                                 ; $80BB45 |

CODE_80BB47:
  STZ.B $1F                                 ; $80BB47 |
  LDA.W $0001,Y                             ; $80BB49 |
  STA.B $1E                                 ; $80BB4C |
  BPL CODE_80BB52                           ; $80BB4E |
  DEC.B $1F                                 ; $80BB50 |

CODE_80BB52:
  REP #$20                                  ; $80BB52 |
  LDA.B $15,X                               ; $80BB54 |
  SBC.B $1E                                 ; $80BB56 |
  CMP.W #$00F0                              ; $80BB58 |
  BCS CODE_80BBA0                           ; $80BB5B |

CODE_80BB5D:
  STA.B $FA                                 ; $80BB5D |
  LDA.B $10                                 ; $80BB5F |
  ADC.B $1C                                 ; $80BB61 |
  CMP.W #$0100                              ; $80BB63 |
  BCS CODE_80BBAF                           ; $80BB66 |
  SEP #$20                                  ; $80BB68 |

CODE_80BB6A:
  PHA                                       ; $80BB6A |
  ROR.B $0A                                 ; $80BB6B |
  LDA.B $FA                                 ; $80BB6D |
  PHA                                       ; $80BB6F |
  LDA.W $0003,Y                             ; $80BB70 |
  ADC.B $0B                                 ; $80BB73 |
  PHA                                       ; $80BB75 |
  LDA.W $0004,Y                             ; $80BB76 |
  AND.B $12                                 ; $80BB79 |
  EOR.B $17                                 ; $80BB7B |
  ORA.B $1A                                 ; $80BB7D |
  PHA                                       ; $80BB7F |
  TXA                                       ; $80BB80 |
  LSR A                                     ; $80BB81 |
  ROR.B $0A                                 ; $80BB82 |
  BCS CODE_80BB91                           ; $80BB84 |

CODE_80BB86:
  INY                                       ; $80BB86 |
  INY                                       ; $80BB87 |
  INY                                       ; $80BB88 |
  INY                                       ; $80BB89 |
  DEC.B $1B                                 ; $80BB8A |
  BNE CODE_80BB32                           ; $80BB8C |

CODE_80BB8E:
  JMP.W ($0000)                             ; $80BB8E |


CODE_80BB91:
  LDA.B $0A                                 ; $80BB91 |
  STA.B ($08)                               ; $80BB93 |
  INC.B $08                                 ; $80BB95 |
  BEQ CODE_80BB8E                           ; $80BB97 |
  LDA.B #$80                                ; $80BB99 |
  STA.B $0A                                 ; $80BB9B |
  CLC                                       ; $80BB9D |
  BRA CODE_80BB86                           ; $80BB9E |


CODE_80BBA0:
  CMP.W #$FFF0                              ; $80BBA0 |
  AND.W #$00FF                              ; $80BBA3 |
  BCC CODE_80BBAB                           ; $80BBA6 |
  CLC                                       ; $80BBA8 |
  BRA CODE_80BB5D                           ; $80BBA9 |


CODE_80BBAB:
  SEP #$20                                  ; $80BBAB |
  BRA CODE_80BB86                           ; $80BBAD |


CODE_80BBAF:
  CMP.B #$F0                                ; $80BBAF |
  SBC.L EMPTY_00FF29,X                      ; $80BBB1 |
  SEP #$20                                  ; $80BBB5 |
  BCS CODE_80BB6A                           ; $80BBB7 |
  BRA CODE_80BB86                           ; $80BBB9 |


CODE_JP_80BBBB:
  SEC                                       ; $80BBBB |
  SBC.B $6E                                 ; $80BBBC |
  STA.B $13                                 ; $80BBBE |
  SEC                                       ; $80BBC0 |
  SBC.B $6C                                 ; $80BBC1 |
  STA.B $10                                 ; $80BBC3 |
  SEP #$20                                  ; $80BBC5 |
  CLC                                       ; $80BBC7 |
  TDC                                       ; $80BBC8 |

CODE_80BBC9:
  LDA.W $0004,Y                             ; $80BBC9 |
  AND.B #$10                                ; $80BBCC |
  BEQ CODE_80BBD2                           ; $80BBCE |
  LDA.B #$03                                ; $80BBD0 |

CODE_80BBD2:
  TAX                                       ; $80BBD2 |
  STZ.B $1D                                 ; $80BBD3 |
  LDA.W $0002,Y                             ; $80BBD5 |
  STA.B $1C                                 ; $80BBD8 |
  BPL CODE_80BBDE                           ; $80BBDA |
  DEC.B $1D                                 ; $80BBDC |

CODE_80BBDE:
  STZ.B $1F                                 ; $80BBDE |
  LDA.W $0001,Y                             ; $80BBE0 |
  STA.B $1E                                 ; $80BBE3 |
  BPL CODE_80BBE9                           ; $80BBE5 |
  DEC.B $1F                                 ; $80BBE7 |

CODE_80BBE9:
  REP #$20                                  ; $80BBE9 |
  LDA.B $15,X                               ; $80BBEB |
  SBC.B $1E                                 ; $80BBED |
  CMP.W #$00F0                              ; $80BBEF |
  BCS CODE_80BC37                           ; $80BBF2 |

CODE_80BBF4:
  STA.B $FA                                 ; $80BBF4 |
  LDA.B $10,X                               ; $80BBF6 |
  SBC.B $1C                                 ; $80BBF8 |
  CMP.W #$0100                              ; $80BBFA |
  BCS CODE_80BC46                           ; $80BBFD |
  SEP #$20                                  ; $80BBFF |

CODE_80BC01:
  PHA                                       ; $80BC01 |
  ROR.B $0A                                 ; $80BC02 |
  LDA.B $FA                                 ; $80BC04 |
  PHA                                       ; $80BC06 |
  LDA.W $0003,Y                             ; $80BC07 |
  ADC.B $0B                                 ; $80BC0A |
  PHA                                       ; $80BC0C |
  LDA.W $0004,Y                             ; $80BC0D |
  AND.B $12                                 ; $80BC10 |
  EOR.B $17                                 ; $80BC12 |
  ORA.B $1A                                 ; $80BC14 |
  PHA                                       ; $80BC16 |
  TXA                                       ; $80BC17 |
  LSR A                                     ; $80BC18 |
  ROR.B $0A                                 ; $80BC19 |
  BCS CODE_80BC28                           ; $80BC1B |

CODE_80BC1D:
  INY                                       ; $80BC1D |
  INY                                       ; $80BC1E |
  INY                                       ; $80BC1F |
  INY                                       ; $80BC20 |
  DEC.B $1B                                 ; $80BC21 |
  BNE CODE_80BBC9                           ; $80BC23 |

CODE_80BC25:
  JMP.W ($0000)                             ; $80BC25 |


CODE_80BC28:
  LDA.B $0A                                 ; $80BC28 |
  STA.B ($08)                               ; $80BC2A |
  INC.B $08                                 ; $80BC2C |
  BEQ CODE_80BC25                           ; $80BC2E |
  LDA.B #$80                                ; $80BC30 |
  STA.B $0A                                 ; $80BC32 |
  CLC                                       ; $80BC34 |
  BRA CODE_80BC1D                           ; $80BC35 |


CODE_80BC37:
  CMP.B #$F0                                ; $80BC37 |
  SBC.L EMPTY_00FF29,X                      ; $80BC39 |
  BCC CODE_80BC42                           ; $80BC3D |
  CLC                                       ; $80BC3F |
  BRA CODE_80BBF4                           ; $80BC40 |


CODE_80BC42:
  SEP #$20                                  ; $80BC42 |
  BRA CODE_80BC1D                           ; $80BC44 |


CODE_80BC46:
  CMP.B #$F0                                ; $80BC46 |
  SBC.L EMPTY_00FF29,X                      ; $80BC48 |
  SEP #$20                                  ; $80BC4C |
  BCS CODE_80BC01                           ; $80BC4E |
  BRA CODE_80BC1D                           ; $80BC50 |


CODE_FL_80BC52:
  LDX.W #$FFFF                              ; $80BC52 |
  CMP.L $0060A2                             ; $80BC55 |
  STX.W $1D52                               ; $80BC59 |
  STY.W $1D50                               ; $80BC5C |
  LDA.L $7EC000                             ; $80BC5F |
  AND.W #$00FF                              ; $80BC63 |
  STA.W $1D42                               ; $80BC66 |
  STZ.W $1D44                               ; $80BC69 |
  STZ.W $1D4E                               ; $80BC6C |
  CLC                                       ; $80BC6F |
  ADC.W #$C003                              ; $80BC70 |
  STA.W $1D46                               ; $80BC73 |
  ADC.L $7EC001                             ; $80BC76 |
  STA.W $1D48                               ; $80BC7A |
  ADC.L $7EC001                             ; $80BC7D |
  STA.W $1D4A                               ; $80BC81 |
  ADC.L $7EC001                             ; $80BC84 |
  STA.W $1D4C                               ; $80BC88 |

CODE_FL_80BC8B:
  PHD                                       ; $80BC8B |
  PHB                                       ; $80BC8C |
  LDA.W #$1D00                              ; $80BC8D |
  TCD                                       ; $80BC90 |
  PEA.W $7E00                               ; $80BC91 |
  PLB                                       ; $80BC94 |
  PLB                                       ; $80BC95 |
  LDX.B $50                                 ; $80BC96 |
  STZ.B $54                                 ; $80BC98 |
  SEP #$20                                  ; $80BC9A |
  CLC                                       ; $80BC9C |

CODE_80BC9D:
  LDY.B $44                                 ; $80BC9D |
  LDA.W $C003,Y                             ; $80BC9F |
  INY                                       ; $80BCA2 |
  STY.B $44                                 ; $80BCA3 |
  STA.B $40                                 ; $80BCA5 |
  REP #$20                                  ; $80BCA7 |
  AND.W #$00FF                              ; $80BCA9 |
  ADC.B $54                                 ; $80BCAC |
  STA.B $54                                 ; $80BCAE |

  SEP #$20                                  ; $80BCB0 |
  LDY.B $4E                                 ; $80BCB2 |
  LDA.B $40                                 ; $80BCB4 |
  STA.W $0001,X                             ; $80BCB6 |

CODE_80BCB9:
  CMP.L $00019E                             ; $80BCB9 |
  LDA.B ($4C),Y                             ; $80BCBD |
  STA.W $3001,X                             ; $80BCBF |
  AND.B #$10                                ; $80BCC2 |
  BEQ CODE_80BCC8                           ; $80BCC4 |
  LDA.B #$03                                ; $80BCC6 |

CODE_80BCC8:
  STA.W $0000,X                             ; $80BCC8 |
  STZ.W $1001,X                             ; $80BCCB |
  LDA.B ($46),Y                             ; $80BCCE |
  BPL CODE_80BCD5                           ; $80BCD0 |
  DEC.W $1001,X                             ; $80BCD2 |

CODE_80BCD5:
  STA.W $1000,X                             ; $80BCD5 |
  STZ.W $2001,X                             ; $80BCD8 |
  LDA.B ($48),Y                             ; $80BCDB |
  BPL CODE_80BCE2                           ; $80BCDD |
  DEC.W $2001,X                             ; $80BCDF |

CODE_80BCE2:
  STA.W $2000,X                             ; $80BCE2 |
  LDA.B ($4A),Y                             ; $80BCE5 |
  STA.W $3000,X                             ; $80BCE7 |
  INY                                       ; $80BCEA |
  INX                                       ; $80BCEB |
  INX                                       ; $80BCEC |
  DEC.B $40                                 ; $80BCED |
  BNE CODE_80BCB9+1                         ; $80BCEF |
  STY.B $4E                                 ; $80BCF1 |
  DEC.B $42                                 ; $80BCF3 |
  BEQ CODE_80BCFF                           ; $80BCF5 |
  LDY.B $54                                 ; $80BCF7 |
  CPY.B $52                                 ; $80BCF9 |
  BCC CODE_80BC9D                           ; $80BCFB |
  BRA CODE_80BD00                           ; $80BCFD |


CODE_80BCFF:
  CLC                                       ; $80BCFF |

CODE_80BD00:
  STX.B $50                                 ; $80BD00 |
  REP #$20                                  ; $80BD02 |
  PLB                                       ; $80BD04 |
  PLD                                       ; $80BD05 |
  RTL                                       ; $80BD06 |


CODE_FL_80BD07:
  SEC                                       ; $80BD07 |
  LDA.W $1B76                               ; $80BD08 |
  SBC.W #$0050                              ; $80BD0B |
  TAX                                       ; $80BD0E |
  LDA.B $16,X                               ; $80BD0F |
  PHA                                       ; $80BD11 |
  PHX                                       ; $80BD12 |
  STZ.B $16,X                               ; $80BD13 |
  LDA.W $0B36                               ; $80BD15 |
  PHA                                       ; $80BD18 |
  LDA.W $1B70                               ; $80BD19 |
  CMP.W $1B74                               ; $80BD1C |
  BMI CODE_80BD24                           ; $80BD1F |
  LDA.W $1B74                               ; $80BD21 |

CODE_80BD24:
  STA.W $0B36                               ; $80BD24 |
  JSL.L CODE_FL_80BD34                      ; $80BD27 |
  PLA                                       ; $80BD2B |
  STA.W $0B36                               ; $80BD2C |
  PLX                                       ; $80BD2F |
  PLA                                       ; $80BD30 |
  STA.B $16,X                               ; $80BD31 |
  RTL                                       ; $80BD33 |


CODE_FL_80BD34:
  LDX.W #$1E38                              ; $80BD34 |
  LDY.W #$0400                              ; $80BD37 |
  CLC                                       ; $80BD3A |

CODE_80BD3B:
  LDA.W $0000,Y                             ; $80BD3B |
  BEQ CODE_80BD49                           ; $80BD3E |
  STY.B $60,X                               ; $80BD40 |
  LDA.W $0014,Y                             ; $80BD42 |
  STA.B $00,X                               ; $80BD45 |
  INX                                       ; $80BD47 |
  INX                                       ; $80BD48 |

CODE_80BD49:
  LDA.W $0016,Y                             ; $80BD49 |
  TAY                                       ; $80BD4C |
  BNE CODE_80BD3B                           ; $80BD4D |
  BRA CODE_80BDAE                           ; $80BD4F |


CODE_FL_80BD51:
  SEC                                       ; $80BD51 |
  LDA.W $1B76                               ; $80BD52 |
  SBC.W #$0050                              ; $80BD55 |
  TAX                                       ; $80BD58 |
  LDA.B $16,X                               ; $80BD59 |
  PHA                                       ; $80BD5B |
  PHX                                       ; $80BD5C |
  STZ.B $16,X                               ; $80BD5D |
  LDA.W $0B36                               ; $80BD5F |
  PHA                                       ; $80BD62 |
  LDA.W $1B70                               ; $80BD63 |
  CMP.W $1B74                               ; $80BD66 |
  BMI CODE_80BD6E                           ; $80BD69 |
  LDA.W $1B74                               ; $80BD6B |

CODE_80BD6E:
  STA.W $0B36                               ; $80BD6E |
  JSL.L CODE_FL_80BD7E                      ; $80BD71 |
  PLA                                       ; $80BD75 |
  STA.W $0B36                               ; $80BD76 |
  PLX                                       ; $80BD79 |
  PLA                                       ; $80BD7A |
  STA.B $16,X                               ; $80BD7B |
  RTL                                       ; $80BD7D |


CODE_FL_80BD7E:
  LDX.W #$1E38                              ; $80BD7E |
  LDY.W #$0400                              ; $80BD81 |
  CLC                                       ; $80BD84 |

CODE_80BD85:
  LDA.W $0000,Y                             ; $80BD85 |
  BEQ CODE_80BDA8                           ; $80BD88 |
  STY.B $60,X                               ; $80BD8A |
  LDA.W $0034,Y                             ; $80BD8C |
  LSR A                                     ; $80BD8F |
  BCC CODE_80BD9D                           ; $80BD90 |
  LDA.W $000D,Y                             ; $80BD92 |
  EOR.W #$FFFF                              ; $80BD95 |
  AND.W #$7FFF                              ; $80BD98 |
  BRA CODE_80BDA4                           ; $80BD9B |


CODE_80BD9D:
  LDA.W $000D,Y                             ; $80BD9D |
  EOR.W #$FFFF                              ; $80BDA0 |
  INC A                                     ; $80BDA3 |

CODE_80BDA4:
  STA.B $00,X                               ; $80BDA4 |
  INX                                       ; $80BDA6 |
  INX                                       ; $80BDA7 |

CODE_80BDA8:
  LDA.W $0016,Y                             ; $80BDA8 |
  TAY                                       ; $80BDAB |
  BNE CODE_80BD85                           ; $80BDAC |

CODE_80BDAE:
  TXA                                       ; $80BDAE |
  SEC                                       ; $80BDAF |
  SBC.W #$1E38                              ; $80BDB0 |
  LSR A                                     ; $80BDB3 |
  CPX.W #$1E98                              ; $80BDB4 |
  BEQ CODE_80BDC2                           ; $80BDB7 |

CODE_80BDB9:
  STZ.B $60,X                               ; $80BDB9 |
  INX                                       ; $80BDBB |
  INX                                       ; $80BDBC |
  CPX.W #$1E98                              ; $80BDBD |
  BNE CODE_80BDB9                           ; $80BDC0 |

CODE_80BDC2:
  STA.W $1EF8                               ; $80BDC2 |
  LSR A                                     ; $80BDC5 |
  BEQ CODE_80BDE0                           ; $80BDC6 |
  LDA.W #$1E38                              ; $80BDC8 |
  TCD                                       ; $80BDCB |
  LDA.B $C0                                 ; $80BDCC |
  CMP.W #$0009                              ; $80BDCE |
  BCS CODE_80BDE1                           ; $80BDD1 |
  CMP.W #$0005                              ; $80BDD3 |
  BCS CODE_80BE11                           ; $80BDD6 |
  CMP.W #$0003                              ; $80BDD8 |
  BCS CODE_80BE41                           ; $80BDDB |
  JMP.W CODE_JP_80BE70                      ; $80BDDD |


CODE_80BDE0:
  RTL                                       ; $80BDE0 |


CODE_80BDE1:
  SBC.W #$0008                              ; $80BDE1 |
  ASL A                                     ; $80BDE4 |
  STA.B $C2                                 ; $80BDE5 |
  LDA.W #$0000                              ; $80BDE7 |

CODE_80BDEA:
  STA.B $C4                                 ; $80BDEA |

CODE_80BDEC:
  TAX                                       ; $80BDEC |
  LDA.B $10,X                               ; $80BDED |
  CMP.B $00,X                               ; $80BDEF |
  BCS CODE_80BE07                           ; $80BDF1 |
  LDY.B $00,X                               ; $80BDF3 |
  STY.B $10,X                               ; $80BDF5 |
  STA.B $00,X                               ; $80BDF7 |
  LDA.B $60,X                               ; $80BDF9 |
  LDY.B $70,X                               ; $80BDFB |
  STY.B $60,X                               ; $80BDFD |
  STA.B $70,X                               ; $80BDFF |
  TXA                                       ; $80BE01 |
  SBC.W #$000F                              ; $80BE02 |
  BPL CODE_80BDEC                           ; $80BE05 |

CODE_80BE07:
  LDA.B $C4                                 ; $80BE07 |
  INC A                                     ; $80BE09 |
  INC A                                     ; $80BE0A |
  CMP.B $C2                                 ; $80BE0B |
  BCC CODE_80BDEA                           ; $80BE0D |
  LDA.B $C0                                 ; $80BE0F |

CODE_80BE11:
  SBC.W #$0004                              ; $80BE11 |
  ASL A                                     ; $80BE14 |
  STA.B $C2                                 ; $80BE15 |
  LDA.W #$0000                              ; $80BE17 |

CODE_80BE1A:
  STA.B $C4                                 ; $80BE1A |

CODE_80BE1C:
  TAX                                       ; $80BE1C |
  LDA.B $08,X                               ; $80BE1D |
  CMP.B $00,X                               ; $80BE1F |
  BCS CODE_80BE37                           ; $80BE21 |
  LDY.B $00,X                               ; $80BE23 |
  STY.B $08,X                               ; $80BE25 |
  STA.B $00,X                               ; $80BE27 |
  LDA.B $60,X                               ; $80BE29 |
  LDY.B $68,X                               ; $80BE2B |
  STY.B $60,X                               ; $80BE2D |
  STA.B $68,X                               ; $80BE2F |
  TXA                                       ; $80BE31 |
  SBC.W #$0007                              ; $80BE32 |
  BPL CODE_80BE1C                           ; $80BE35 |

CODE_80BE37:
  LDA.B $C4                                 ; $80BE37 |
  INC A                                     ; $80BE39 |
  INC A                                     ; $80BE3A |
  CMP.B $C2                                 ; $80BE3B |
  BCC CODE_80BE1A                           ; $80BE3D |
  LDA.B $C0                                 ; $80BE3F |

CODE_80BE41:
  DEC A                                     ; $80BE41 |
  DEC A                                     ; $80BE42 |
  ASL A                                     ; $80BE43 |
  STA.B $C2                                 ; $80BE44 |
  LDA.W #$0000                              ; $80BE46 |

CODE_80BE49:
  STA.B $C4                                 ; $80BE49 |

CODE_80BE4B:
  TAX                                       ; $80BE4B |
  LDA.B $04,X                               ; $80BE4C |
  CMP.B $00,X                               ; $80BE4E |
  BCS CODE_80BE66                           ; $80BE50 |
  LDY.B $00,X                               ; $80BE52 |
  STY.B $04,X                               ; $80BE54 |
  STA.B $00,X                               ; $80BE56 |
  LDA.B $60,X                               ; $80BE58 |
  LDY.B $64,X                               ; $80BE5A |
  STY.B $60,X                               ; $80BE5C |
  STA.B $64,X                               ; $80BE5E |
  TXA                                       ; $80BE60 |
  SBC.W #$0003                              ; $80BE61 |
  BPL CODE_80BE4B                           ; $80BE64 |

CODE_80BE66:
  LDA.B $C4                                 ; $80BE66 |
  INC A                                     ; $80BE68 |
  INC A                                     ; $80BE69 |
  CMP.B $C2                                 ; $80BE6A |
  BCC CODE_80BE49                           ; $80BE6C |
  LDA.B $C0                                 ; $80BE6E |

CODE_JP_80BE70:
  DEC A                                     ; $80BE70 |
  ASL A                                     ; $80BE71 |
  STA.B $C2                                 ; $80BE72 |
  LDA.W #$0000                              ; $80BE74 |

CODE_80BE77:
  STA.B $C4                                 ; $80BE77 |
  TAX                                       ; $80BE79 |

CODE_80BE7A:
  LDA.B $02,X                               ; $80BE7A |
  CMP.B $00,X                               ; $80BE7C |
  BCS CODE_80BE92                           ; $80BE7E |
  LDY.B $00,X                               ; $80BE80 |
  STY.B $02,X                               ; $80BE82 |
  STA.B $00,X                               ; $80BE84 |
  LDY.B $62,X                               ; $80BE86 |
  LDA.B $60,X                               ; $80BE88 |
  STY.B $60,X                               ; $80BE8A |
  STA.B $62,X                               ; $80BE8C |
  DEX                                       ; $80BE8E |
  DEX                                       ; $80BE8F |
  BPL CODE_80BE7A                           ; $80BE90 |

CODE_80BE92:
  LDA.B $C4                                 ; $80BE92 |
  INC A                                     ; $80BE94 |
  INC A                                     ; $80BE95 |
  CMP.B $C2                                 ; $80BE96 |
  BCC CODE_80BE77                           ; $80BE98 |
  LDA.W #$0000                              ; $80BE9A |
  TCD                                       ; $80BE9D |
  RTL                                       ; $80BE9E |


CODE_FL_80BE9F:
  JSL.L CODE_FL_808302                      ; $80BE9F |
  JSL.L CODE_FL_80883F                      ; $80BEA3 |
  JSL.L CODE_FL_80BEFB                      ; $80BEA7 |
  JML.L CODE_FL_808230                      ; $80BEAB |

  JSL.L CODE_FL_808302                      ; $80BEAF |
  JSL.L CODE_FL_80BEFB                      ; $80BEB3 |
  JML.L CODE_FL_808230                      ; $80BEB7 |

  JSL.L CODE_FL_808302                      ; $80BEBB |
  JSL.L CODE_FL_80BEFB                      ; $80BEBF |
  JML.L CODE_FL_808315                      ; $80BEC3 |


CODE_FL_80BEC7:
  JSL.L CODE_FL_808302                      ; $80BEC7 |
  JSL.L CODE_FL_80887C                      ; $80BECB |
  JSL.L CODE_FL_80BEFB                      ; $80BECF |
  JML.L CODE_FL_808230                      ; $80BED3 |


CODE_FL_80BED7:
  JSL.L CODE_FL_808302                      ; $80BED7 |
  JSL.L CODE_FL_80887C                      ; $80BEDB |
  JSL.L CODE_FL_80BEFB                      ; $80BEDF |
  JML.L CODE_FL_808315                      ; $80BEE3 |


CODE_FL_80BEE7:
  JSL.L CODE_FL_808302                      ; $80BEE7 |
  JSL.L CODE_FL_80883F                      ; $80BEEB |
  JSL.L CODE_FL_80BEFB                      ; $80BEEF |
  JSL.L CODE_FL_80BF2F                      ; $80BEF3 |
  JML.L CODE_FL_808230                      ; $80BEF7 |


CODE_FL_80BEFB:
  JSL.L CODE_FL_80BF08                      ; $80BEFB |
  JSL.L CODE_FL_80BF15                      ; $80BEFF |
  JSL.L CODE_FL_80BF22                      ; $80BF03 |
  RTL                                       ; $80BF07 |


CODE_FL_80BF08:
  REP #$10                                  ; $80BF08 |
  LDY.W #$0FFF                              ; $80BF0A |
  LDX.W #$0000                              ; $80BF0D |
  JSL.L CODE_FL_80BF4B                      ; $80BF10 |
  RTL                                       ; $80BF14 |


CODE_FL_80BF15:
  REP #$10                                  ; $80BF15 |
  LDY.W #$0FFF                              ; $80BF17 |
  LDX.W #$1000                              ; $80BF1A |
  JSL.L CODE_FL_80BF4B                      ; $80BF1D |
  RTL                                       ; $80BF21 |


CODE_FL_80BF22:
  REP #$10                                  ; $80BF22 |
  LDY.W #$03FF                              ; $80BF24 |
  LDX.W #$5000                              ; $80BF27 |
  JSL.L CODE_FL_80BF41                      ; $80BF2A |
  RTL                                       ; $80BF2E |


CODE_FL_80BF2F:
  REP #$10                                  ; $80BF2F |
  LDY.W #$07FF                              ; $80BF31 |
  LDX.W #$5000                              ; $80BF34 |
  JSL.L CODE_FL_80BF41                      ; $80BF37 |
  RTL                                       ; $80BF3B |

  LDA.W #$0200                              ; $80BF3C |
  BRA CODE_80BF4E                           ; $80BF3F |


CODE_FL_80BF41:
  LDA.W #$0300                              ; $80BF41 |
  BRA CODE_80BF4E                           ; $80BF44 |

  LDA.W #$0040                              ; $80BF46 |
  BRA CODE_80BF4E                           ; $80BF49 |


CODE_FL_80BF4B:
  LDA.W #$0000                              ; $80BF4B |

CODE_80BF4E:
  PHA                                       ; $80BF4E |
  SEP #$20                                  ; $80BF4F |
  LDA.B #$80                                ; $80BF51 |
  STA.W !reg_vmain                          ; $80BF53 |
  REP #$20                                  ; $80BF56 |
  STX.W !reg_vmaddl                         ; $80BF58 |
  PLA                                       ; $80BF5B |

.CODE_80BF5C
  STA.W !reg_vmdatal                        ; $80BF5C |
  DEY                                       ; $80BF5F |
  BPL .CODE_80BF5C                          ; $80BF60 |
  RTL                                       ; $80BF62 |

CODE_FL_80BF63_UNUSED:
  LDA.W #$0200                              ; $80BF63 |
  BRA .CODE_80BF6B                          ; $80BF66 |

  LDA.W #$0000                              ; $80BF68 |

.CODE_80BF6B
  PHX                                       ; $80BF6B |
  PHA                                       ; $80BF6C |
  JSL.L CODE_FL_809622                      ; $80BF6D |
  PLA                                       ; $80BF71 |
  PLX                                       ; $80BF72 |
  TXY                                       ; $80BF73 |

.CODE_80BF74
  JSL.L CODE_FL_809658                      ; $80BF74 |
  DEY                                       ; $80BF78 |
  BNE .CODE_80BF74                          ; $80BF79 |
  JML.L CODE_FL_809663                      ; $80BF7B |


CODE_FL_80BF7F:
  PHB                                       ; $80BF7F |
  PEA.W $8100                               ; $80BF80 |
  PLB                                       ; $80BF83 |
  PLB                                       ; $80BF84 |
  STA.B $04                                 ; $80BF85 |
  LDA.W #$0001                              ; $80BF87 |
  STA.B $02                                 ; $80BF8A |
  BRA CODE_80BFB4                           ; $80BF8C |

  PHB                                       ; $80BF8E |
  PEA.W $8100                               ; $80BF8F |
  PLB                                       ; $80BF92 |
  PLB                                       ; $80BF93 |
  STZ.B $02                                 ; $80BF94 |
  STA.B $04                                 ; $80BF96 |
  BRA CODE_80BFB4                           ; $80BF98 |


CODE_FL_80BF9A:
  PHB                                       ; $80BF9A |
  PEA.W $8100                               ; $80BF9B |
  PLB                                       ; $80BF9E |
  PLB                                       ; $80BF9F |
  LDA.W #$0001                              ; $80BFA0 |
  STA.B $02                                 ; $80BFA3 |
  BRA CODE_80BFAF                           ; $80BFA5 |

  PHB                                       ; $80BFA7 |
  PEA.W $8100                               ; $80BFA8 |
  PLB                                       ; $80BFAB |
  PLB                                       ; $80BFAC |
  STZ.B $02                                 ; $80BFAD |

CODE_80BFAF:
  LDA.W #$2000                              ; $80BFAF |
  STA.B $04                                 ; $80BFB2 |

CODE_80BFB4:
  STX.B $00                                 ; $80BFB4 |
  LDA.B $02                                 ; $80BFB6 |
  BEQ CODE_80BFDD                           ; $80BFB8 |

CODE_80BFBA:
  LDX.B $00                                 ; $80BFBA |
  LDY.W $0000,X                             ; $80BFBC |
  LDA.W $0002,X                             ; $80BFBF |
  AND.W #$00FF                              ; $80BFC2 |
  CMP.W #$00FC                              ; $80BFC5 |
  BNE CODE_80BFD0                           ; $80BFC8 |
  INX                                       ; $80BFCA |
  LDA.W #$0081                              ; $80BFCB |
  BRA CODE_80BFD3                           ; $80BFCE |


CODE_80BFD0:
  LDA.W #$0080                              ; $80BFD0 |

CODE_80BFD3:
  INX                                       ; $80BFD3 |
  INX                                       ; $80BFD4 |
  STX.B $00                                 ; $80BFD5 |
  JSL.L CODE_FL_809625                      ; $80BFD7 |
  STZ.B $02                                 ; $80BFDB |

CODE_80BFDD:
  LDX.B $00                                 ; $80BFDD |
  LDA.W $0000,X                             ; $80BFDF |
  INX                                       ; $80BFE2 |
  STX.B $00                                 ; $80BFE3 |
  AND.W #$00FF                              ; $80BFE5 |

  CMP.W #$00FF                              ; $80BFE8 |
  BEQ CODE_80C016                           ; $80BFEB |
  CMP.W #$00FE                              ; $80BFED |

  BEQ CODE_80C010                           ; $80BFF0 |
  CMP.W #$00FD                              ; $80BFF2 |
  BEQ CODE_80C006                           ; $80BFF5 |
  LDY.B $88                                 ; $80BFF7 |
  BEQ CODE_80BFFE                           ; $80BFF9 |
  LDA.W #$0000                              ; $80BFFB |

CODE_80BFFE:
  ORA.B $04                                 ; $80BFFE |
  JSL.L CODE_FL_809658                      ; $80C000 |
  BRA CODE_80BFDD                           ; $80C004 |


CODE_80C006:
  LDA.W $0000,X                             ; $80C006 |
  INX                                       ; $80C009 |
  STX.B $00                                 ; $80C00A |
  STA.B $05                                 ; $80C00C |
  BRA CODE_80BFDD                           ; $80C00E |


CODE_80C010:
  JSL.L CODE_FL_809663                      ; $80C010 |
  BRA CODE_80BFBA                           ; $80C014 |


CODE_80C016:
  STZ.B $88                                 ; $80C016 |
  JSL.L CODE_FL_809663                      ; $80C018 |
  PLB                                       ; $80C01C |
  RTL                                       ; $80C01D |


CODE_FL_80C01E:
  REP #$20                                  ; $80C01E |
  REP #$10                                  ; $80C020 |
  LDA.B $36                                 ; $80C022 |
  BIT.W #$3000                              ; $80C024 |
  BEQ CODE_80C02C                           ; $80C027 |
  INC.W $0072                               ; $80C029 |

CODE_80C02C:
  LDA.W $0070                               ; $80C02C |
  PHX                                       ; $80C02F |
  ASL A                                     ; $80C030 |
  TAX                                       ; $80C031 |
  LDA.L PTR16_80C03C,X                      ; $80C032 |
  PLX                                       ; $80C036 |
  STA.B $00                                 ; $80C037 |
  JMP.W ($0000)                             ; $80C039 |

PTR16_80C03C:
  dw CODE_80C052                            ; $80C03C |
  dw CODE_80C0AB                            ; $80C03E |
  dw CODE_80C0E1                            ; $80C040 |
  dw CODE_80C0F7                            ; $80C042 |
  dw CODE_80C1BA                            ; $80C044 |
  dw CODE_80C110                            ; $80C046 |
  dw CODE_80C131                            ; $80C048 |
  dw CODE_80C1BA                            ; $80C04A |
  dw CODE_80C18D                            ; $80C04C |
  dw CODE_80C1B3                            ; $80C04E |
  dw CODE_80C1C3                            ; $80C050 |

CODE_80C052:
  JSL.L CODE_FL_80832C                      ; $80C052 |
  JSL.L CODE_FL_808302                      ; $80C056 |
  JSL.L CODE_FL_84C579                      ; $80C05A |
  JSL.L CODE_FL_80BE9F                      ; $80C05E |
  REP #$30                                  ; $80C062 |
  PHB                                       ; $80C064 |
  LDA.W #$0000                              ; $80C065 |
  STA.L $000070                             ; $80C068 |
  LDA.W #$000F                              ; $80C06C |
  LDX.W #$0071                              ; $80C06F |
  TXY                                       ; $80C072 |
  INY                                       ; $80C073 |
  MVN $00,$00                               ; $80C074 |
  PLB                                       ; $80C077 |
  LDA.W #$0009                              ; $80C078 |
  STA.W $1FA4                               ; $80C07B |
  LDX.W #asset_logo_and_icons               ; $80C07E |
  JSL.L load_asset                          ; $80C081 |
  LDY.W #$A917                              ; $80C085 |
  JSL.L CODE_FL_80C27C                      ; $80C088 |
  LDA.W #$0400                              ; $80C08C |
  STA.W $1672                               ; $80C08F |
  LDA.W #$0100                              ; $80C092 |
  STA.W $1662                               ; $80C095 |
  STA.W $1682                               ; $80C098 |
  LDA.W #$0019                              ; $80C09B |
  STA.W $1FA4                               ; $80C09E |
  LDA.W #$0003                              ; $80C0A1 |
  STA.W $0076                               ; $80C0A4 |
  INC.W $0070                               ; $80C0A7 |
  RTL                                       ; $80C0AA |


CODE_80C0AB:
  LDA.B $42                                 ; $80C0AB |
  LSR A                                     ; $80C0AD |
  BCS CODE_80C0CE                           ; $80C0AE |
  LDX.W #$8E23                              ; $80C0B0 |
  JSL.L CODE_FL_80BF9A                      ; $80C0B3 |
  LDA.W $0074                               ; $80C0B7 |
  INC A                                     ; $80C0BA |
  AND.W #$0003                              ; $80C0BB |
  STA.W $0074                               ; $80C0BE |
  ASL A                                     ; $80C0C1 |
  ADC.W #$0006                              ; $80C0C2 |
  ORA.W #$2C00                              ; $80C0C5 |
  LDX.B $52                                 ; $80C0C8 |
  STA.L $7E0000-2,X                         ; $80C0CA |

CODE_80C0CE:
  LDA.W $1662                               ; $80C0CE |
  SEC                                       ; $80C0D1 |
  SBC.W #$0008                              ; $80C0D2 |
  STA.W $1662                               ; $80C0D5 |
  BNE CODE_80C0E0                           ; $80C0D8 |
  STZ.W $1682                               ; $80C0DA |
  INC.W $0070                               ; $80C0DD |

CODE_80C0E0:
  RTL                                       ; $80C0E0 |


CODE_80C0E1:
  LDA.B $42                                 ; $80C0E1 |
  AND.W #$0003                              ; $80C0E3 |
  BNE CODE_80C0F6                           ; $80C0E6 |
  LDX.W #$2C64                              ; $80C0E8 |
  JSR.W CODE_FN_80C1CC                      ; $80C0EB |
  DEC.W $0076                               ; $80C0EE |
  BNE CODE_80C0F6                           ; $80C0F1 |
  INC.W $0070                               ; $80C0F3 |

CODE_80C0F6:
  RTL                                       ; $80C0F6 |


CODE_80C0F7:
  LDA.W $1672                               ; $80C0F7 |
  SEC                                       ; $80C0FA |
  SBC.W #$0002                              ; $80C0FB |
  STA.W $1672                               ; $80C0FE |
  AND.W #$0100                              ; $80C101 |
  BNE CODE_80C130                           ; $80C104 |

CODE_80C106:
  LDA.W #$0001                              ; $80C106 |
  STA.W $007A                               ; $80C109 |
  INC.W $0070                               ; $80C10C |
  RTL                                       ; $80C10F |


CODE_80C110:
  LDA.W #$000A                              ; $80C110 |
  STA.W $0074                               ; $80C113 |
  STA.W $0076                               ; $80C116 |
  STA.W $0078                               ; $80C119 |
  LDY.W #$8112                              ; $80C11C |
  LDA.W #$0002                              ; $80C11F |
  JSL.L CODE_FL_80C2C9                      ; $80C122 |
  LDA.W #$0000                              ; $80C126 |
  JSL.L CODE_FL_84C6D5                      ; $80C129 |
  INC.W $0070                               ; $80C12D |

CODE_80C130:
  RTL                                       ; $80C130 |


CODE_80C131:
  LDA.W $0074                               ; $80C131 |
  BEQ CODE_80C14E                           ; $80C134 |
  CMP.W #$000A                              ; $80C136 |
  BNE CODE_80C145                           ; $80C139 |
  LDY.W #$8132                              ; $80C13B |
  LDA.W #$0004                              ; $80C13E |
  JSL.L CODE_FL_80C2C9                      ; $80C141 |

CODE_80C145:
  DEC.W $0074                               ; $80C145 |
  LDX.W #$2C2C                              ; $80C148 |
  JSR.W CODE_FN_80C1CC                      ; $80C14B |

CODE_80C14E:
  LDA.W $0076                               ; $80C14E |
  BMI CODE_80C163                           ; $80C151 |
  LDX.W #$2C4C                              ; $80C153 |
  JSR.W CODE_FN_80C1CC                      ; $80C156 |
  DEC.W $0076                               ; $80C159 |
  LDA.W #$0003                              ; $80C15C |
  STA.W $007A                               ; $80C15F |
  RTL                                       ; $80C162 |


CODE_80C163:
  LDA.W $007A                               ; $80C163 |
  BEQ CODE_80C177                           ; $80C166 |
  DEC.W $007A                               ; $80C168 |
  BNE CODE_80C18C                           ; $80C16B |
  LDY.W #$80F0                              ; $80C16D |
  LDA.W #$0000                              ; $80C170 |
  JML.L CODE_FL_80C2C9                      ; $80C173 |


CODE_80C177:
  LDA.W $0078                               ; $80C177 |
  BMI CODE_80C106                           ; $80C17A |
  LDA.B $42                                 ; $80C17C |
  AND.W #$0001                              ; $80C17E |
  BNE CODE_80C18C                           ; $80C181 |
  DEC.W $0078                               ; $80C183 |
  LDX.W #$2C0A                              ; $80C186 |
  JSR.W CODE_FN_80C1CC                      ; $80C189 |

CODE_80C18C:
  RTL                                       ; $80C18C |


CODE_80C18D:
  LDX.W #$2C00                              ; $80C18D |
  LDA.L $7E0000,X                           ; $80C190 |
  CLC                                       ; $80C194 |
  ADC.W #$0421                              ; $80C195 |
  STA.L $7E0000,X                           ; $80C198 |
  STA.L $7E0002,X                           ; $80C19C |
  CMP.W #$7FFF                              ; $80C1A0 |
  BNE CODE_80C1AE                           ; $80C1A3 |
  LDA.W #$0100                              ; $80C1A5 |
  STA.W $007A                               ; $80C1A8 |
  INC.W $0070                               ; $80C1AB |

CODE_80C1AE:
  JSL.L CODE_FL_80C2DC                      ; $80C1AE |
  RTL                                       ; $80C1B2 |


CODE_80C1B3:
  LDA.B $36                                 ; $80C1B3 |
  AND.W #$3000                              ; $80C1B5 |
  BNE CODE_80C1BF                           ; $80C1B8 |

CODE_80C1BA:
  DEC.W $007A                               ; $80C1BA |
  BNE CODE_80C1C2                           ; $80C1BD |

CODE_80C1BF:
  INC.W $0070                               ; $80C1BF |

CODE_80C1C2:
  RTL                                       ; $80C1C2 |


CODE_80C1C3:
  DEC.W $1FA0                               ; $80C1C3 |
  BNE CODE_80C1CB                           ; $80C1C6 |
  INC.W $0072                               ; $80C1C8 |

CODE_80C1CB:
  RTL                                       ; $80C1CB |


CODE_FN_80C1CC:
  LDA.L $7E0000,X                           ; $80C1CC |
  PHA                                       ; $80C1D0 |
  INX                                       ; $80C1D1 |
  INX                                       ; $80C1D2 |

CODE_80C1D3:
  LDA.L $7E0000,X                           ; $80C1D3 |
  STA.L $7E0000-2,X                         ; $80C1D7 |
  INX                                       ; $80C1DB |
  INX                                       ; $80C1DC |
  TXA                                       ; $80C1DD |
  AND.W #$001F                              ; $80C1DE |
  BNE CODE_80C1D3                           ; $80C1E1 |
  PLA                                       ; $80C1E3 |
  STA.L $7E0000-2,X                         ; $80C1E4 |
  JSL.L CODE_FL_80C2DC                      ; $80C1E8 |
  RTS                                       ; $80C1EC |


CODE_FL_80C1ED:
  PHX                                       ; $80C1ED |
  LDX.W #$1F30                              ; $80C1EE |
  JSL.L CODE_FL_80C302                      ; $80C1F1 |
  LDX.W #$1F40                              ; $80C1F5 |
  JSL.L CODE_FL_80C302                      ; $80C1F8 |
  LDX.W #$1F50                              ; $80C1FC |
  JSL.L CODE_FL_80C302                      ; $80C1FF |
  LDX.W #$1F60                              ; $80C203 |
  JSL.L CODE_FL_80C302                      ; $80C206 |
  LDX.W #$1F70                              ; $80C20A |
  JSL.L CODE_FL_80C302                      ; $80C20D |
  PLX                                       ; $80C211 |
  RTL                                       ; $80C212 |


CODE_FL_80C213:
  LDX.W #$1F30                              ; $80C213 |

CODE_FL_80C216:
  JSL.L CODE_FL_80C302                      ; $80C216 |
  LDA.W #$0008                              ; $80C21A |
  LDY.W #$000F                              ; $80C21D |
  BRA CODE_80C22F                           ; $80C220 |


CODE_FL_80C222:
  LDX.W #$1F30                              ; $80C222 |

CODE_FL_80C225:
  JSL.L CODE_FL_80C302                      ; $80C225 |

CODE_80C229:
  LDA.W #$0009                              ; $80C229 |
  LDY.W #$0000                              ; $80C22C |

CODE_80C22F:
  STY.B $04,X                               ; $80C22F |
  STA.B $00,X                               ; $80C231 |

  LDY.W #$0001                              ; $80C233 |
  STY.B $06,X                               ; $80C236 |
  RTL                                       ; $80C238 |


CODE_FL_80C239:
  LDX.W #$1F30                              ; $80C239 |
  JSL.L CODE_FL_80C302                      ; $80C23C |
  LDA.W #$0002                              ; $80C240 |
  STA.B $08,X                               ; $80C243 |
  BRA CODE_80C229                           ; $80C245 |

  LDA.W $1F40                               ; $80C247 |
  BRA CODE_80C259                           ; $80C24A |

  LDA.W $1F40                               ; $80C24C |
  BRA CODE_80C259                           ; $80C24F |

  LDA.W $1F40                               ; $80C251 |
  BRA CODE_80C259                           ; $80C254 |


CODE_FL_80C256:
  LDA.W $1F30                               ; $80C256 |

CODE_80C259:
  BEQ CODE_80C25E                           ; $80C259 |
  PHP                                       ; $80C25B |
  PLA                                       ; $80C25C |
  PLA                                       ; $80C25D |

CODE_80C25E:
  RTL                                       ; $80C25E |

  LDX.W #$1F30                              ; $80C25F |
  JSL.L CODE_FL_80C305                      ; $80C262 |
  BRA CODE_80C283                           ; $80C266 |


CODE_FL_80C268:
  LDX.W #$1F70                              ; $80C268 |
  BRA CODE_FL_80C27F                        ; $80C26B |


CODE_FL_80C26D:
  LDX.W #$1F60                              ; $80C26D |
  BRA CODE_FL_80C27F                        ; $80C270 |


CODE_FL_80C272:
  LDX.W #$1F50                              ; $80C272 |
  BRA CODE_FL_80C27F                        ; $80C275 |


CODE_FL_80C277:
  LDX.W #$1F40                              ; $80C277 |
  BRA CODE_FL_80C27F                        ; $80C27A |


CODE_FL_80C27C:
  LDX.W #$1F30                              ; $80C27C |

CODE_FL_80C27F:
  JSL.L CODE_FL_80C302                      ; $80C27F |

CODE_80C283:
  TYA                                       ; $80C283 |
  PHP                                       ; $80C284 |
  ORA.W #$8000                              ; $80C285 |
  TAY                                       ; $80C288 |

  LDA.W #$0002                              ; $80C289 |
  PLP                                       ; $80C28C |
  BMI CODE_80C292                           ; $80C28D |

  ORA.W #$8000                              ; $80C28F |

CODE_80C292:
  CPY.W #$B9B1                              ; $80C292 |
  BCC CODE_80C2B0                           ; $80C295 |
  INC A                                     ; $80C297 |
  CPY.W #$BA1F                              ; $80C298 |
  BCC CODE_80C2B0                           ; $80C29B |
  INC A                                     ; $80C29D |
  CPY.W #$BA9A                              ; $80C29E |
  BCC CODE_80C2B0                           ; $80C2A1 |
  INC A                                     ; $80C2A3 |
  CPY.W #$BA9A                              ; $80C2A4 |
  BCC CODE_80C2B0                           ; $80C2A7 |
  INC A                                     ; $80C2A9 |
  CPY.W #$BA9A                              ; $80C2AA |
  BCC CODE_80C2B0                           ; $80C2AD |

  INC A                                     ; $80C2AF |

CODE_80C2B0:
  STA.B $00,X                               ; $80C2B0 |
  STY.B $02,X                               ; $80C2B2 |
  RTL                                       ; $80C2B4 |


CODE_FL_80C2B5:
  LDX.W #$1F70                              ; $80C2B5 |
  BRA CODE_FL_80C2CC                        ; $80C2B8 |


CODE_FL_80C2BA:
  LDX.W #$1F60                              ; $80C2BA |
  BRA CODE_FL_80C2CC                        ; $80C2BD |


CODE_FL_80C2BF:
  LDX.W #$1F50                              ; $80C2BF |
  BRA CODE_FL_80C2CC                        ; $80C2C2 |


CODE_FL_80C2C4:
  LDX.W #$1F40                              ; $80C2C4 |
  BRA CODE_FL_80C2CC                        ; $80C2C7 |


CODE_FL_80C2C9:
  LDX.W #$1F30                              ; $80C2C9 |

CODE_FL_80C2CC:
  PHA                                       ; $80C2CC |

  JSL.L CODE_FL_80C302                      ; $80C2CD |
  PLA                                       ; $80C2D1 |

  STA.B $04,X                               ; $80C2D2 |
  STY.B $02,X                               ; $80C2D4 |
  LDA.W #$0001                              ; $80C2D6 |
  STA.B $00,X                               ; $80C2D9 |
  RTL                                       ; $80C2DB |


CODE_FL_80C2DC:
  LDA.B $48                                 ; $80C2DC |
  ORA.W #$8000                              ; $80C2DE |
  STA.B $48                                 ; $80C2E1 |
  RTL                                       ; $80C2E3 |


CODE_FL_80C2E4:
  PHB                                       ; $80C2E4 |
  LDA.W #$01FF                              ; $80C2E5 |
  LDX.W #$2C00                              ; $80C2E8 |
  LDY.W #$2E00                              ; $80C2EB |
  MVN $7E,$7E                               ; $80C2EE |
  PLB                                       ; $80C2F1 |
  RTL                                       ; $80C2F2 |


CODE_FL_80C2F3:
  PHB                                       ; $80C2F3 |
  LDA.W #$01FF                              ; $80C2F4 |
  LDX.W #$2E00                              ; $80C2F7 |
  LDY.W #$2C00                              ; $80C2FA |
  MVN $7E,$7E                               ; $80C2FD |
  PLB                                       ; $80C300 |
  RTL                                       ; $80C301 |


CODE_FL_80C302:
  LDA.W #$0000                              ; $80C302 |

CODE_FL_80C305:
  STA.B $04,X                               ; $80C305 |
  STZ.B $00,X                               ; $80C307 |
  STZ.B $02,X                               ; $80C309 |
  STZ.B $06,X                               ; $80C30B |
  STZ.B $08,X                               ; $80C30D |
  STZ.B $0A,X                               ; $80C30F |
  STZ.B $0C,X                               ; $80C311 |
  STZ.B $0E,X                               ; $80C313 |
  RTL                                       ; $80C315 |


CODE_FL_80C316:
  PHB                                       ; $80C316 |
  PEA.W $8484                               ; $80C317 |
  PLB                                       ; $80C31A |
  PLB                                       ; $80C31B |
  REP #$30                                  ; $80C31C |
  LDX.W #$1F30                              ; $80C31E |

CODE_80C321:
  STX.B $FC                                 ; $80C321 |
  LDA.B $00,X                               ; $80C323 |
  BEQ CODE_80C33A                           ; $80C325 |
  TAY                                       ; $80C327 |
  BPL CODE_80C32E                           ; $80C328 |
  LDA.B $78                                 ; $80C32A |
  BNE CODE_80C33A                           ; $80C32C |

CODE_80C32E:
  JSL.L CODE_FL_80C2DC                      ; $80C32E |
  TYA                                       ; $80C332 |
  AND.W #$7FFF                              ; $80C333 |
  JSL.L CODE_FL_80C348                      ; $80C336 |

CODE_80C33A:
  LDA.B $FC                                 ; $80C33A |
  CLC                                       ; $80C33C |
  ADC.W #$0010                              ; $80C33D |
  TAX                                       ; $80C340 |
  CPX.W #$1F80                              ; $80C341 |
  BCC CODE_80C321                           ; $80C344 |
  PLB                                       ; $80C346 |
  RTL                                       ; $80C347 |


CODE_FL_80C348:
  DEC A                                     ; $80C348 |
  PHX                                       ; $80C349 |
  ASL A                                     ; $80C34A |
  TAX                                       ; $80C34B |
  LDA.L PTR16_80C356,X                      ; $80C34C |
  PLX                                       ; $80C350 |
  STA.B $00                                 ; $80C351 |
  JMP.W ($0000)                             ; $80C353 |

PTR16_80C356:
  dw CODE_80C368                            ; $80C356 |
  dw CODE_80C37A                            ; $80C358 |
  dw CODE_80C3C3                            ; $80C35A |
  dw CODE_80C428                            ; $80C35C |
  dw CODE_80C50B                            ; $80C35E |
  dw CODE_80C5A0                            ; $80C360 |
  dw CODE_80C66C                            ; $80C362 |
  dw CODE_80C6B2                            ; $80C364 |
  dw CODE_80C6C4                            ; $80C366 |

CODE_80C368:
  LDY.B $02,X                               ; $80C368 |
  LDA.B $04,X                               ; $80C36A |
  JSL.L CODE_FL_80C374                      ; $80C36C |
  JML.L CODE_FL_80C302                      ; $80C370 |


CODE_FL_80C374:
  PHB                                       ; $80C374 |
  PHX                                       ; $80C375 |
  PHY                                       ; $80C376 |
  JMP.W CODE_JP_80C6E9                      ; $80C377 |


CODE_80C37A:
  LDA.B $08,X                               ; $80C37A |
  BEQ CODE_80C381                           ; $80C37C |
  DEC.B $08,X                               ; $80C37E |
  RTL                                       ; $80C380 |


CODE_80C381:
  LDA.B $02,X                               ; $80C381 |
  STA.B $00                                 ; $80C383 |
  LDA.B ($00)                               ; $80C385 |
  AND.W #$00FF                              ; $80C387 |
  STA.B $08,X                               ; $80C38A |

CODE_80C38C:
  LDY.B $06,X                               ; $80C38C |
  INY                                       ; $80C38E |
  INY                                       ; $80C38F |
  STY.B $06,X                               ; $80C390 |
  LDA.B ($00),Y                             ; $80C392 |
  BEQ CODE_80C3B0                           ; $80C394 |
  BPL CODE_80C3A7                           ; $80C396 |
  CLC                                       ; $80C398 |
  TYA                                       ; $80C399 |
  ADC.B $00                                 ; $80C39A |
  JSL.L CODE_FL_80C6DF                      ; $80C39C |
  LDY.B $06,X                               ; $80C3A0 |
  INY                                       ; $80C3A2 |
  STY.B $06,X                               ; $80C3A3 |
  BRA CODE_80C37A                           ; $80C3A5 |


CODE_80C3A7:
  ORA.W #$8000                              ; $80C3A7 |
  JSL.L CODE_FL_80C6DF                      ; $80C3AA |
  BRA CODE_80C37A                           ; $80C3AE |


CODE_80C3B0:
  INC.B $04,X                               ; $80C3B0 |
  STZ.B $06,X                               ; $80C3B2 |
  LDA.B ($00)                               ; $80C3B4 |
  BMI CODE_80C38C                           ; $80C3B6 |
  XBA                                       ; $80C3B8 |
  AND.W #$007F                              ; $80C3B9 |
  CMP.B $04,X                               ; $80C3BC |
  BCS CODE_80C38C                           ; $80C3BE |
  JMP.W CODE_FL_80C302                      ; $80C3C0 |


CODE_80C3C3:
  LDA.B $08,X                               ; $80C3C3 |
  BEQ CODE_80C3CA                           ; $80C3C5 |
  DEC.B $08,X                               ; $80C3C7 |
  RTL                                       ; $80C3C9 |


CODE_80C3CA:
  INC.B $04,X                               ; $80C3CA |
  LDA.B $04,X                               ; $80C3CC |
  CMP.W #$0020                              ; $80C3CE |
  BCC CODE_80C3D6                           ; $80C3D1 |
  JMP.W CODE_FL_80C302                      ; $80C3D3 |


CODE_80C3D6:
  LDY.B $02,X                               ; $80C3D6 |
  LDA.W $0000,Y                             ; $80C3D8 |
  BIT.W #$0080                              ; $80C3DB |
  BEQ CODE_80C3E3                           ; $80C3DE |
  JSR.W CODE_FN_80C405                      ; $80C3E0 |

CODE_80C3E3:
  LDA.W $0000,Y                             ; $80C3E3 |
  AND.W #$007F                              ; $80C3E6 |
  STA.B $08,X                               ; $80C3E9 |
  LDA.W $0003,Y                             ; $80C3EB |
  STA.B $00                                 ; $80C3EE |
  LDX.W $0001,Y                             ; $80C3F0 |

CODE_80C3F3:
  LDA.L $7E0000,X                           ; $80C3F3 |
  JSR.W CODE_FN_80C410                      ; $80C3F7 |
  STA.L $7E0000,X                           ; $80C3FA |
  INX                                       ; $80C3FE |
  INX                                       ; $80C3FF |
  CPX.B $00                                 ; $80C400 |
  BCC CODE_80C3F3                           ; $80C402 |
  RTL                                       ; $80C404 |


CODE_FN_80C405:
  LDA.W $1FE0                               ; $80C405 |
  JSR.W CODE_FN_80C410                      ; $80C408 |
  JSL.L CODE_FL_808D48                      ; $80C40B |
  RTS                                       ; $80C40F |


CODE_FN_80C410:
  SEC                                       ; $80C410 |
  BIT.W #$001F                              ; $80C411 |
  BEQ CODE_80C417                           ; $80C414 |
  DEC A                                     ; $80C416 |

CODE_80C417:
  BIT.W #$03E0                              ; $80C417 |
  BEQ CODE_80C41F                           ; $80C41A |
  SBC.W #$0020                              ; $80C41C |

CODE_80C41F:
  BIT.W #$7C00                              ; $80C41F |
  BEQ CODE_80C427                           ; $80C422 |
  SBC.W #$0400                              ; $80C424 |

CODE_80C427:
  RTS                                       ; $80C427 |


CODE_80C428:
  LDA.B $08,X                               ; $80C428 |
  BEQ CODE_80C434                           ; $80C42A |
  DEC.B $08,X                               ; $80C42C |
  RTL                                       ; $80C42E |


CODE_80C42F:
  LDX.B $FC                                 ; $80C42F |
  STA.B $08,X                               ; $80C431 |
  RTL                                       ; $80C433 |


CODE_80C434:
  INC.B $04,X                               ; $80C434 |
  SEC                                       ; $80C436 |
  LDA.W #$001F                              ; $80C437 |
  SBC.B $04,X                               ; $80C43A |
  BPL CODE_80C441                           ; $80C43C |
  JMP.W CODE_FL_80C302                      ; $80C43E |


CODE_80C441:
  JSR.W CODE_FN_80C4C0                      ; $80C441 |
  LDY.B $02,X                               ; $80C444 |
  STX.B $FC                                 ; $80C446 |

CODE_JL_80C448:
  LDA.W $0000,Y                             ; $80C448 |

  BPL CODE_80C458                           ; $80C44B |

  CMP.W #$FFFF                              ; $80C44D |
  BNE CODE_80C462                           ; $80C450 |
  LDA.W $0002,Y                             ; $80C452 |
  TAY                                       ; $80C455 |
  BRA CODE_JL_80C448                        ; $80C456 |


CODE_80C458:
  CMP.W #$0100                              ; $80C458 |
  BCC CODE_80C42F                           ; $80C45B |
  ORA.W #$8000                              ; $80C45D |
  BRA CODE_80C464                           ; $80C460 |


CODE_80C462:
  TYA                                       ; $80C462 |
  INY                                       ; $80C463 |

CODE_80C464:
  TAX                                       ; $80C464 |
  STY.B $FE                                 ; $80C465 |

  LDY.W $0000,X                             ; $80C467 |
  BPL CODE_80C4D1                           ; $80C46A |
  LDA.W $0002,X                             ; $80C46C |
  AND.W #$00FF                              ; $80C46F |
  TAX                                       ; $80C472 |
  LDA.W DATA16_84A8F5,X                     ; $80C473 |
  TAX                                       ; $80C476 |
  PHB                                       ; $80C477 |
  SEP #$20                                  ; $80C478 |
  PHA                                       ; $80C47A |
  TYA                                       ; $80C47B |
  LSR A                                     ; $80C47C |
  LDA.B #$95                                ; $80C47D |
  BCC CODE_80C483                           ; $80C47F |
  LDA.B #$95                                ; $80C481 |

CODE_80C483:
  PHA                                       ; $80C483 |
  PLB                                       ; $80C484 |
  PLA                                       ; $80C485 |
  REP #$20                                  ; $80C486 |
  LDA.W $0000,Y                             ; $80C488 |
  STA.B $02                                 ; $80C48B |

CODE_80C48D:
  TXA                                       ; $80C48D |
  AND.W #$01FF                              ; $80C48E |
  BEQ CODE_80C49A                           ; $80C491 |
  AND.W #$001F                              ; $80C493 |
  BNE CODE_80C49A                           ; $80C496 |
  INX                                       ; $80C498 |
  INX                                       ; $80C499 |

CODE_80C49A:
  LDA.W $0002,Y                             ; $80C49A |
  BPL CODE_80C4A6                           ; $80C49D |

  JSR.W CODE_FN_80C731                      ; $80C49F |
  BPL CODE_80C48D                           ; $80C4A2 |
  BMI CODE_80C4B7                           ; $80C4A4 |

CODE_80C4A6:
  JSR.W CODE_FN_80C4DB                      ; $80C4A6 |
  STA.L $7E0000,X                           ; $80C4A9 |
  INX                                       ; $80C4AD |
  INX                                       ; $80C4AE |
  INY                                       ; $80C4AF |
  INY                                       ; $80C4B0 |

  DEC.B $02                                 ; $80C4B1 |

  DEC.B $02                                 ; $80C4B3 |

  BPL CODE_80C48D                           ; $80C4B5 |

CODE_80C4B7:
  PLB                                       ; $80C4B7 |

CODE_80C4B8:
  LDY.B $FE                                 ; $80C4B8 |
  INY                                       ; $80C4BA |

  INY                                       ; $80C4BB |
  JML.L CODE_JL_80C448                      ; $80C4BC |


CODE_FN_80C4C0:
  STA.B $08                                 ; $80C4C0 |
  ASL A                                     ; $80C4C2 |
  ASL A                                     ; $80C4C3 |
  ASL A                                     ; $80C4C4 |
  ASL A                                     ; $80C4C5 |
  ASL A                                     ; $80C4C6 |
  STA.B $0A                                 ; $80C4C7 |
  ASL A                                     ; $80C4C9 |
  ASL A                                     ; $80C4CA |
  ASL A                                     ; $80C4CB |
  ASL A                                     ; $80C4CC |
  ASL A                                     ; $80C4CD |
  STA.B $0C                                 ; $80C4CE |
  RTS                                       ; $80C4D0 |


CODE_80C4D1:
  TYA                                       ; $80C4D1 |
  JSR.W CODE_FN_80C4DB                      ; $80C4D2 |
  JSL.L CODE_FL_808D48                      ; $80C4D5 |
  BRA CODE_80C4B8                           ; $80C4D9 |


CODE_FN_80C4DB:
  STA.B $04                                 ; $80C4DB |
  AND.W #$001F                              ; $80C4DD |
  SEC                                       ; $80C4E0 |
  SBC.B $08                                 ; $80C4E1 |
  BPL CODE_80C4E8                           ; $80C4E3 |
  LDA.W #$0000                              ; $80C4E5 |

CODE_80C4E8:
  STA.B $00                                 ; $80C4E8 |
  LDA.B $04                                 ; $80C4EA |
  AND.W #$03E0                              ; $80C4EC |
  SEC                                       ; $80C4EF |
  SBC.B $0A                                 ; $80C4F0 |
  BPL CODE_80C4F7                           ; $80C4F2 |
  LDA.W #$0000                              ; $80C4F4 |

CODE_80C4F7:
  ORA.B $00                                 ; $80C4F7 |
  STA.B $00                                 ; $80C4F9 |
  LDA.B $04                                 ; $80C4FB |
  AND.W #$7C00                              ; $80C4FD |
  SEC                                       ; $80C500 |
  SBC.B $0C                                 ; $80C501 |
  BPL CODE_80C508                           ; $80C503 |
  LDA.W #$0000                              ; $80C505 |

CODE_80C508:
  ORA.B $00                                 ; $80C508 |
  RTS                                       ; $80C50A |


CODE_80C50B:
  LDA.B $08,X                               ; $80C50B |
  BEQ CODE_80C512                           ; $80C50D |
  DEC.B $08,X                               ; $80C50F |
  RTL                                       ; $80C511 |


CODE_80C512:
  INC.B $04,X                               ; $80C512 |
  LDA.B $04,X                               ; $80C514 |
  CMP.W #$0020                              ; $80C516 |
  BCC CODE_80C51E                           ; $80C519 |
  JMP.W CODE_FL_80C302                      ; $80C51B |


CODE_80C51E:
  LDA.W #$0001                              ; $80C51E |
  STA.B $08                                 ; $80C521 |
  LDA.W #$0020                              ; $80C523 |
  STA.B $0A                                 ; $80C526 |
  LDA.W #$0400                              ; $80C528 |
  STA.B $0C                                 ; $80C52B |
  LDY.B $02,X                               ; $80C52D |
  LDA.W $0000,Y                             ; $80C52F |
  BIT.W #$0080                              ; $80C532 |
  BEQ CODE_80C53A                           ; $80C535 |
  JSR.W CODE_FN_80C55C                      ; $80C537 |

CODE_80C53A:
  LDA.W $0000,Y                             ; $80C53A |
  AND.W #$007F                              ; $80C53D |
  STA.B $08,X                               ; $80C540 |
  LDA.W $0003,Y                             ; $80C542 |
  STA.B $00                                 ; $80C545 |
  LDX.W $0001,Y                             ; $80C547 |

CODE_80C54A:
  LDA.L $7E0000,X                           ; $80C54A |
  JSR.W CODE_FN_80C567                      ; $80C54E |
  STA.L $7E0000,X                           ; $80C551 |
  INX                                       ; $80C555 |
  INX                                       ; $80C556 |

  CPX.B $00                                 ; $80C557 |
  BCC CODE_80C54A                           ; $80C559 |
  RTL                                       ; $80C55B |


CODE_FN_80C55C:
  LDA.W $1FE0                               ; $80C55C |

  JSR.W CODE_FN_80C567                      ; $80C55F |
  JSL.L CODE_FL_808D48                      ; $80C562 |
  RTS                                       ; $80C566 |


CODE_FN_80C567:
  STA.B $04                                 ; $80C567 |
  CLC                                       ; $80C569 |
  AND.W #$001F                              ; $80C56A |
  ADC.B $08                                 ; $80C56D |

  BIT.W #$FFE0                              ; $80C56F |
  BEQ CODE_80C577                           ; $80C572 |
  LDA.W #$001F                              ; $80C574 |

CODE_80C577:
  STA.B $0E                                 ; $80C577 |
  LDA.B $04                                 ; $80C579 |
  CLC                                       ; $80C57B |
  AND.W #$03E0                              ; $80C57C |
  ADC.B $0A                                 ; $80C57F |
  BIT.W #$FC00                              ; $80C581 |
  BEQ CODE_80C589                           ; $80C584 |
  LDA.W #$03E0                              ; $80C586 |

CODE_80C589:
  ORA.B $0E                                 ; $80C589 |
  STA.B $0E                                 ; $80C58B |
  LDA.B $04                                 ; $80C58D |
  CLC                                       ; $80C58F |
  AND.W #$7C00                              ; $80C590 |
  ADC.B $0C                                 ; $80C593 |
  BIT.W #$8000                              ; $80C595 |
  BEQ CODE_80C59D                           ; $80C598 |
  LDA.W #$7C00                              ; $80C59A |

CODE_80C59D:
  ORA.B $0E                                 ; $80C59D |

  RTS                                       ; $80C59F |


CODE_80C5A0:
  LDA.B $08,X                               ; $80C5A0 |
  BEQ CODE_80C5AC                           ; $80C5A2 |
  DEC.B $08,X                               ; $80C5A4 |
  RTL                                       ; $80C5A6 |


CODE_80C5A7:
  LDX.B $FC                                 ; $80C5A7 |
  STA.B $08,X                               ; $80C5A9 |
  RTL                                       ; $80C5AB |


CODE_80C5AC:
  INC.B $04,X                               ; $80C5AC |
  SEC                                       ; $80C5AE |
  LDA.W #$0020                              ; $80C5AF |
  SBC.B $04,X                               ; $80C5B2 |
  BPL CODE_80C5B9                           ; $80C5B4 |
  JMP.W CODE_FL_80C302                      ; $80C5B6 |


CODE_80C5B9:
  JSR.W CODE_FN_80C4C0                      ; $80C5B9 |
  LDY.B $02,X                               ; $80C5BC |
  STX.B $FC                                 ; $80C5BE |

CODE_JL_80C5C0:
  LDA.W $0000,Y                             ; $80C5C0 |
  BPL CODE_80C5D0                           ; $80C5C3 |
  CMP.W #$FFFF                              ; $80C5C5 |
  BNE CODE_80C5DA                           ; $80C5C8 |
  LDA.W $0002,Y                             ; $80C5CA |
  TAY                                       ; $80C5CD |
  BRA CODE_JL_80C5C0                        ; $80C5CE |


CODE_80C5D0:
  CMP.W #$0100                              ; $80C5D0 |
  BCC CODE_80C5A7                           ; $80C5D3 |
  ORA.W #$8000                              ; $80C5D5 |
  BRA CODE_80C5DC                           ; $80C5D8 |


CODE_80C5DA:
  TYA                                       ; $80C5DA |
  INY                                       ; $80C5DB |

CODE_80C5DC:
  TAX                                       ; $80C5DC |
  STY.B $FE                                 ; $80C5DD |

  LDY.W $0000,X                             ; $80C5DF |
  BPL CODE_80C638                           ; $80C5E2 |
  LDA.W $0002,X                             ; $80C5E4 |

  AND.W #$00FF                              ; $80C5E7 |
  TAX                                       ; $80C5EA |
  LDA.W DATA16_84A8F5,X                     ; $80C5EB |
  TAX                                       ; $80C5EE |

  PHB                                       ; $80C5EF |
  SEP #$20                                  ; $80C5F0 |

  PHA                                       ; $80C5F2 |
  TYA                                       ; $80C5F3 |
  LSR A                                     ; $80C5F4 |
  LDA.B #$95                                ; $80C5F5 |
  BCC CODE_80C5FB                           ; $80C5F7 |
  LDA.B #$95                                ; $80C5F9 |

CODE_80C5FB:
  PHA                                       ; $80C5FB |
  PLB                                       ; $80C5FC |
  PLA                                       ; $80C5FD |
  REP #$20                                  ; $80C5FE |
  LDA.W $0000,Y                             ; $80C600 |
  STA.B $02                                 ; $80C603 |

CODE_80C605:
  TXA                                       ; $80C605 |
  AND.W #$01FF                              ; $80C606 |
  BEQ CODE_80C612                           ; $80C609 |
  AND.W #$001F                              ; $80C60B |
  BNE CODE_80C612                           ; $80C60E |
  INX                                       ; $80C610 |
  INX                                       ; $80C611 |

CODE_80C612:
  LDA.W $0002,Y                             ; $80C612 |
  BPL CODE_80C61E                           ; $80C615 |
  JSR.W CODE_FN_80C731                      ; $80C617 |
  BPL CODE_80C605                           ; $80C61A |
  BMI CODE_80C62F                           ; $80C61C |

CODE_80C61E:
  JSR.W CODE_FN_80C642                      ; $80C61E |
  STA.L $7E0000,X                           ; $80C621 |
  INX                                       ; $80C625 |
  INX                                       ; $80C626 |
  INY                                       ; $80C627 |
  INY                                       ; $80C628 |
  DEC.B $02                                 ; $80C629 |
  DEC.B $02                                 ; $80C62B |
  BPL CODE_80C605                           ; $80C62D |

CODE_80C62F:
  PLB                                       ; $80C62F |

CODE_80C630:
  LDY.B $FE                                 ; $80C630 |
  INY                                       ; $80C632 |
  INY                                       ; $80C633 |
  JML.L CODE_JL_80C5C0                      ; $80C634 |


CODE_80C638:
  TYA                                       ; $80C638 |
  JSR.W CODE_FN_80C642                      ; $80C639 |
  JSL.L CODE_FL_808D48                      ; $80C63C |
  BRA CODE_80C630                           ; $80C640 |


CODE_FN_80C642:
  STA.B $04                                 ; $80C642 |
  AND.W #$001F                              ; $80C644 |
  CMP.B $08                                 ; $80C647 |
  BCS CODE_80C64D                           ; $80C649 |
  LDA.B $08                                 ; $80C64B |

CODE_80C64D:
  STA.B $0E                                 ; $80C64D |
  LDA.B $04                                 ; $80C64F |
  AND.W #$03E0                              ; $80C651 |
  CMP.B $0A                                 ; $80C654 |
  BCS CODE_80C65A                           ; $80C656 |
  LDA.B $0A                                 ; $80C658 |

CODE_80C65A:
  ORA.B $0E                                 ; $80C65A |
  STA.B $0E                                 ; $80C65C |
  LDA.B $04                                 ; $80C65E |
  AND.W #$7C00                              ; $80C660 |
  CMP.B $0C                                 ; $80C663 |
  BCS CODE_80C669                           ; $80C665 |
  LDA.B $0C                                 ; $80C667 |

CODE_80C669:
  ORA.B $0E                                 ; $80C669 |
  RTS                                       ; $80C66B |


CODE_80C66C:
  LDA.B $08,X                               ; $80C66C |
  BEQ CODE_80C673                           ; $80C66E |
  DEC.B $08,X                               ; $80C670 |
  RTL                                       ; $80C672 |


CODE_80C673:
  INC.B $04,X                               ; $80C673 |
  SEC                                       ; $80C675 |
  LDA.W #$001F                              ; $80C676 |
  SBC.B $04,X                               ; $80C679 |
  BPL CODE_80C680                           ; $80C67B |
  JMP.W CODE_FL_80C302                      ; $80C67D |


CODE_80C680:
  JSR.W CODE_FN_80C4C0                      ; $80C680 |
  LDY.B $02,X                               ; $80C683 |
  LDA.W $0000,Y                             ; $80C685 |
  AND.W #$00FF                              ; $80C688 |
  STA.B $08,X                               ; $80C68B |
  LDA.W $0003,Y                             ; $80C68D |
  STA.B $02                                 ; $80C690 |
  LDX.W $0001,Y                             ; $80C692 |
  LDA.W $0005,Y                             ; $80C695 |
  TAY                                       ; $80C698 |
  PHB                                       ; $80C699 |
  PEA.W $7E00                               ; $80C69A |
  PLB                                       ; $80C69D |
  PLB                                       ; $80C69E |

CODE_80C69F:
  LDA.W $0000,X                             ; $80C69F |
  JSR.W CODE_FN_80C4DB                      ; $80C6A2 |
  STA.W $0000,Y                             ; $80C6A5 |
  INX                                       ; $80C6A8 |
  INX                                       ; $80C6A9 |
  INY                                       ; $80C6AA |
  INY                                       ; $80C6AB |
  CPX.B $02                                 ; $80C6AC |
  BCC CODE_80C69F                           ; $80C6AE |
  PLB                                       ; $80C6B0 |
  RTL                                       ; $80C6B1 |


CODE_80C6B2:
  LDA.B $08,X                               ; $80C6B2 |
  BEQ CODE_80C6B9                           ; $80C6B4 |
  DEC.B $08,X                               ; $80C6B6 |
  RTL                                       ; $80C6B8 |


CODE_80C6B9:
  DEC.B $04,X                               ; $80C6B9 |
  BPL CODE_80C6C0                           ; $80C6BB |
  JMP.W CODE_FL_80C302                      ; $80C6BD |


CODE_80C6C0:
  LDA.B $04,X                               ; $80C6C0 |
  BRA CODE_80C6D7                           ; $80C6C2 |


CODE_80C6C4:
  LDA.B $08,X                               ; $80C6C4 |
  BEQ CODE_80C6CB                           ; $80C6C6 |
  DEC.B $08,X                               ; $80C6C8 |
  RTL                                       ; $80C6CA |


CODE_80C6CB:
  INC.B $04,X                               ; $80C6CB |
  LDA.B $04,X                               ; $80C6CD |
  CMP.W #$0010                              ; $80C6CF |
  BCC CODE_80C6D7                           ; $80C6D2 |
  JMP.W CODE_FL_80C302                      ; $80C6D4 |


CODE_80C6D7:
  STA.W $1FA0                               ; $80C6D7 |
  LDA.B $06,X                               ; $80C6DA |
  STA.B $08,X                               ; $80C6DC |
  RTL                                       ; $80C6DE |


CODE_FL_80C6DF:
  PHB                                       ; $80C6DF |
  PHX                                       ; $80C6E0 |
  PHY                                       ; $80C6E1 |
  TAX                                       ; $80C6E2 |
  LDY.W $0000,X                             ; $80C6E3 |
  LDA.W $0002,X                             ; $80C6E6 |

CODE_JP_80C6E9:
  AND.W #$00FF                              ; $80C6E9 |
  TAX                                       ; $80C6EC |
  LDA.W DATA16_84A8F5,X                     ; $80C6ED |
  TAX                                       ; $80C6F0 |
  SEP #$20                                  ; $80C6F1 |
  PHA                                       ; $80C6F3 |
  TYA                                       ; $80C6F4 |
  LSR A                                     ; $80C6F5 |
  LDA.B #$95                                ; $80C6F6 |
  BCC CODE_80C6FC                           ; $80C6F8 |
  LDA.B #$95                                ; $80C6FA |

CODE_80C6FC:
  PHA                                       ; $80C6FC |
  PLB                                       ; $80C6FD |
  PLA                                       ; $80C6FE |
  REP #$20                                  ; $80C6FF |
  LDA.W $0000,Y                             ; $80C701 |
  STA.B $02                                 ; $80C704 |

CODE_80C706:
  TXA                                       ; $80C706 |
  AND.W #$01FF                              ; $80C707 |
  BEQ CODE_80C713                           ; $80C70A |
  AND.W #$001F                              ; $80C70C |
  BNE CODE_80C713                           ; $80C70F |
  INX                                       ; $80C711 |
  INX                                       ; $80C712 |

CODE_80C713:
  LDA.W $0002,Y                             ; $80C713 |
  BPL CODE_80C71F                           ; $80C716 |
  JSR.W CODE_FN_80C731                      ; $80C718 |
  BPL CODE_80C706                           ; $80C71B |
  BMI CODE_80C72D                           ; $80C71D |

CODE_80C71F:
  STA.L $7E0000,X                           ; $80C71F |
  INX                                       ; $80C723 |
  INX                                       ; $80C724 |
  INY                                       ; $80C725 |
  INY                                       ; $80C726 |
  DEC.B $02                                 ; $80C727 |
  DEC.B $02                                 ; $80C729 |
  BPL CODE_80C706                           ; $80C72B |

CODE_80C72D:
  PLY                                       ; $80C72D |

  PLX                                       ; $80C72E |
  PLB                                       ; $80C72F |
  RTL                                       ; $80C730 |


CODE_FN_80C731:
  AND.W #$00FF                              ; $80C731 |
  STA.B $04                                 ; $80C734 |
  LDA.W #$0000                              ; $80C736 |

CODE_80C739:
  STA.L $7E0000,X                           ; $80C739 |
  INX                                       ; $80C73D |
  INX                                       ; $80C73E |
  DEC.B $02                                 ; $80C73F |
  DEC.B $02                                 ; $80C741 |
  DEC.B $04                                 ; $80C743 |
  BNE CODE_80C739                           ; $80C745 |
  INY                                       ; $80C747 |
  INY                                       ; $80C748 |
  LDA.B $02                                 ; $80C749 |
  RTS                                       ; $80C74B |


CODE_FL_80C74C:
  PHX                                       ; $80C74C |
  ASL A                                     ; $80C74D |

  ASL A                                     ; $80C74E |
  ASL A                                     ; $80C74F |
  ASL A                                     ; $80C750 |
  ASL A                                     ; $80C751 |
  TAX                                       ; $80C752 |
  LDA.W #$0000                              ; $80C753 |

  STA.L $7E2C00,X                           ; $80C756 |
  STA.L $7E2C02,X                           ; $80C75A |
  STA.L $7E2C04,X                           ; $80C75E |
  STA.L $7E2C06,X                           ; $80C762 |
  STA.L $7E2C08,X                           ; $80C766 |
  STA.L $7E2C0A,X                           ; $80C76A |
  STA.L $7E2C0C,X                           ; $80C76E |
  STA.L $7E2C0E,X                           ; $80C772 |
  STA.L $7E2C10,X                           ; $80C776 |
  STA.L $7E2C12,X                           ; $80C77A |
  STA.L $7E2C14,X                           ; $80C77E |
  STA.L $7E2C16,X                           ; $80C782 |
  STA.L $7E2C18,X                           ; $80C786 |
  STA.L $7E2C1A,X                           ; $80C78A |
  STA.L $7E2C1C,X                           ; $80C78E |

  STA.L $7E2C1E,X                           ; $80C792 |
  PLX                                       ; $80C796 |
  LDA.B $48                                 ; $80C797 |
  ORA.W #$8000                              ; $80C799 |
  STA.B $48                                 ; $80C79C |
  RTL                                       ; $80C79E |


CODE_FL_80C79F:
  JSL.L CODE_FL_80C964                      ; $80C79F |
  JMP.W CODE_FL_80C7A7                      ; $80C7A3 |

  RTL                                       ; $80C7A6 |


CODE_FL_80C7A7:
  JSL.L CODE_FL_96FF15                      ; $80C7A7 |

  INC.B $84                                 ; $80C7AB |
  LDA.B !r_room_id                          ; $80C7AD |
  STA.B $B2                                 ; $80C7AF |
  LDA.B !r_room_mode                        ; $80C7B1 |
  ASL A                                     ; $80C7B3 |
  TAX                                       ; $80C7B4 |

  JMP.W (PTR16_80C7B8,X)                    ; $80C7B5 |

PTR16_80C7B8:
  dw CODE_80C840                            ; $80C7B8 |
  dw CODE_80C845                            ; $80C7BA |
  dw CODE_80C84A                            ; $80C7BC |
  dw CODE_80C85E                            ; $80C7BE |
  dw CODE_80C863                            ; $80C7C0 |
  dw CODE_80C7C6                            ; $80C7C2 |
  dw CODE_80C7E1                            ; $80C7C4 |

CODE_80C7C6:
  STZ.W $00A4                               ; $80C7C6 |
  JSL.L CODE_FL_8DC508                      ; $80C7C9 |
  LDA.B $3E                                 ; $80C7CD |
  BEQ CODE_80C7E0                           ; $80C7CF |
  LDA.B !r_room_id                          ; $80C7D1 |
  CMP.W #$FFFF                              ; $80C7D3 |
  BEQ CODE_80C7DC                           ; $80C7D6 |
  JML.L CODE_JL_848356                      ; $80C7D8 |


CODE_80C7DC:
  JML.L CODE_JL_848348                      ; $80C7DC |


CODE_80C7E0:
  RTL                                       ; $80C7E0 |


CODE_80C7E1:
  LDA.B $7E                                 ; $80C7E1 |
  PHX                                       ; $80C7E3 |
  ASL A                                     ; $80C7E4 |
  TAX                                       ; $80C7E5 |
  LDA.L PTR16_80C7F0,X                      ; $80C7E6 |
  PLX                                       ; $80C7EA |
  STA.B $00                                 ; $80C7EB |
  JMP.W ($0000)                             ; $80C7ED |

PTR16_80C7F0:
  dw CODE_80C7FE                            ; $80C7F0 |
  dw CODE_80C808                            ; $80C7F2 |
  dw CODE_80C813                            ; $80C7F4 |
  dw CODE_80C81D                            ; $80C7F6 |
  dw CODE_80C828                            ; $80C7F8 |
  dw CODE_80C832                            ; $80C7FA |
  dw CODE_80C83F                            ; $80C7FC |

CODE_80C7FE:
  STZ.W $00A4                               ; $80C7FE |
  JSL.L CODE_FL_84CFF0                      ; $80C801 |
  INC.B $7E                                 ; $80C805 |
  RTL                                       ; $80C807 |


CODE_80C808:
  JSL.L CODE_FL_84D619                      ; $80C808 |
  BCC CODE_80C812                           ; $80C80C |
  JML.L CODE_JL_848362                      ; $80C80E |


CODE_80C812:
  RTL                                       ; $80C812 |


CODE_80C813:
  STZ.W $00A4                               ; $80C813 |
  JSL.L CODE_FL_84CFF0                      ; $80C816 |
  INC.B $7E                                 ; $80C81A |
  RTL                                       ; $80C81C |


CODE_80C81D:
  JSL.L CODE_FL_84DB6D                      ; $80C81D |
  BCC CODE_80C827                           ; $80C821 |
  JML.L CODE_JL_8483A5                      ; $80C823 |


CODE_80C827:
  RTL                                       ; $80C827 |


CODE_80C828:
  STZ.W $00A4                               ; $80C828 |

  JSL.L CODE_FL_84CFF0                      ; $80C82B |
  INC.B $7E                                 ; $80C82F |
  RTL                                       ; $80C831 |


CODE_80C832:
  JSL.L CODE_FL_84D7E9                      ; $80C832 |
  BCC CODE_80C83E                           ; $80C836 |
  JSL.L CODE_FL_80FB51                      ; $80C838 |
  INC.B $7E                                 ; $80C83C |

CODE_80C83E:
  RTL                                       ; $80C83E |


CODE_80C83F:
  RTL                                       ; $80C83F |


CODE_80C840:
  JSL.L CODE_FL_80D074                      ; $80C840 |
  RTL                                       ; $80C844 |


CODE_80C845:
  JSL.L CODE_FL_80CCA7                      ; $80C845 |

  RTL                                       ; $80C849 |


CODE_80C84A:
  PHB                                       ; $80C84A |

  PEA.W $8A00                               ; $80C84B |
  PLB                                       ; $80C84E |
  PLB                                       ; $80C84F |
  JSL.L CODE_FL_8AB69A                      ; $80C850 |
  JSL.L CODE_FL_82BE73                      ; $80C854 |
  JSL.L CODE_FL_848655                      ; $80C858 |
  PLB                                       ; $80C85C |
  RTL                                       ; $80C85D |


CODE_80C85E:
  JSL.L CODE_FL_80D30A                      ; $80C85E |
  RTL                                       ; $80C862 |


CODE_80C863:
  PHB                                       ; $80C863 |
  PEA.W $8A00                               ; $80C864 |
  PLB                                       ; $80C867 |
  PLB                                       ; $80C868 |
  JSL.L CODE_FL_828000                      ; $80C869 |
  JSL.L CODE_FL_848655                      ; $80C86D |
  PLB                                       ; $80C871 |
  RTL                                       ; $80C872 |


CODE_FL_80C873:
  LDA.B $7E                                 ; $80C873 |
  INC A                                     ; $80C875 |

CODE_FL_80C876:
  STA.B $7E                                 ; $80C876 |
  LDA.W #$0001                              ; $80C878 |

  STA.B $76                                 ; $80C87B |

  STZ.B $80                                 ; $80C87D |
  STZ.B $82                                 ; $80C87F |
  STZ.B $84                                 ; $80C881 |
  RTL                                       ; $80C883 |

  RTL                                       ; $80C884 |


CODE_FL_80C885:
  LDA.W !r_demo_flag                        ; $80C885 |
  ORA.W $00E4                               ; $80C888 |
  ORA.W $0076                               ; $80C88B |
  ORA.W $0046                               ; $80C88E |
  ORA.L $7E7C16                             ; $80C891 |
  RTL                                       ; $80C895 |


CODE_JL_80C896:
  REP #$20                                  ; $80C896 |
  REP #$10                                  ; $80C898 |
  JSL.L CODE_FL_808613                      ; $80C89A |
  LDA.W #$0000                              ; $80C89E |
  STA.B $5A                                 ; $80C8A1 |
  STZ.B $7E                                 ; $80C8A3 |
  STZ.B $80                                 ; $80C8A5 |
  STZ.B $86                                 ; $80C8A7 |

  STZ.B $42                                 ; $80C8A9 |

  STZ.W $1C38                               ; $80C8AB |
  STZ.W $1FA0                               ; $80C8AE |
  STZ.W $1936                               ; $80C8B1 |
  REP #$30                                  ; $80C8B4 |
  PHB                                       ; $80C8B6 |
  LDA.W #$0000                              ; $80C8B7 |
  STA.L $700200                             ; $80C8BA |
  LDA.W #$06F3                              ; $80C8BE |
  LDX.W #$0201                              ; $80C8C1 |
  TXY                                       ; $80C8C4 |
  INY                                       ; $80C8C5 |
  MVN $70,$70                               ; $80C8C6 |
  PLB                                       ; $80C8C9 |
  LDA.W #$0003                              ; $80C8CA |
  STA.B $B8                                 ; $80C8CD |
  LDA.W #$000A                              ; $80C8CF |
  STA.B $BA                                 ; $80C8D2 |
  LDA.W #$000A                              ; $80C8D4 |
  STA.B $BC                                 ; $80C8D7 |
  LDA.W #$0100                              ; $80C8D9 |
  STA.B $BE                                 ; $80C8DC |
  LDA.W #$0001                              ; $80C8DE |
  STA.W $199A                               ; $80C8E1 |
  LDA.B $4E                                 ; $80C8E4 |
  ASL A                                     ; $80C8E6 |
  ASL A                                     ; $80C8E7 |
  ASL A                                     ; $80C8E8 |
  TAY                                       ; $80C8E9 |
  LDA.W DATA8_818E36,Y                      ; $80C8EA |
  STA.B !r_room_id                          ; $80C8ED |
  STA.B $DA                                 ; $80C8EF |

  LDA.W DATA8_818E36+2,Y                    ; $80C8F1 |
  AND.W #$00FF                              ; $80C8F4 |
  STA.B !r_room_mode                        ; $80C8F7 |
  LDA.W #$0080                              ; $80C8F9 |
  STA.W $195A                               ; $80C8FC |
  LDA.W DATA8_818E36+3,Y                    ; $80C8FF |
  AND.W #$00FF                              ; $80C902 |
  STA.W $195C                               ; $80C905 |
  LDA.W DATA8_818E36+4,Y                    ; $80C908 |
  STA.W $1756                               ; $80C90B |
  LDA.W DATA8_818E36+6,Y                    ; $80C90E |
  STA.W $1758                               ; $80C911 |
  LDA.W #$0001                              ; $80C914 |

  STA.L $7002F8                             ; $80C917 |
  STA.L $70030C                             ; $80C91B |
  LDY.B $4E                                 ; $80C91F |
  LDA.W DATA8_818E68,Y                      ; $80C921 |
  AND.W #$00FF                              ; $80C924 |
  STA.L $700320                             ; $80C927 |
  STA.L $700334                             ; $80C92B |
  LDA.W #$0000                              ; $80C92F |
  STA.L $7002FA                             ; $80C932 |
  STA.L $70030E                             ; $80C936 |
  LDA.W #$0001                              ; $80C93A |

  STA.L $7002FC                             ; $80C93D |
  STA.L $700310                             ; $80C941 |
  LDA.W #$0001                              ; $80C945 |
  STA.L $7002FE                             ; $80C948 |
  STA.L $700312                             ; $80C94C |
  JSL.L CODE_FL_838004                      ; $80C950 |
  LDA.W #$0000                              ; $80C954 |
  STA.W $195E                               ; $80C957 |
  STZ.B $70                                 ; $80C95A |
  STZ.B $72                                 ; $80C95C |
  LDA.W #$0001                              ; $80C95E |
  STA.B !r_demo_flag                        ; $80C961 |

  RTL                                       ; $80C963 |


CODE_FL_80C964:
  REP #$20                                  ; $80C964 |
  REP #$10                                  ; $80C966 |
  LDA.B $42                                 ; $80C968 |
  AND.W #$003F                              ; $80C96A |
  TAX                                       ; $80C96D |
  LDA.W DATA8_818E6D,X                      ; $80C96E |
  STA.B $86                                 ; $80C971 |
  LDA.B !r_room_mode                        ; $80C973 |
  ASL A                                     ; $80C975 |
  TAY                                       ; $80C976 |
  LDA.B $7E                                 ; $80C977 |
  CMP.W #$000C                              ; $80C979 |
  BEQ CODE_80C983                           ; $80C97C |

  CMP.W DATA8_818E5E,Y                      ; $80C97E |
  BNE CODE_80C9EB                           ; $80C981 |

CODE_80C983:
  LDA.B $36                                 ; $80C983 |
  BIT.W #$1000                              ; $80C985 |
  BEQ CODE_80C990                           ; $80C988 |
  LDA.W #$0001                              ; $80C98A |
  STA.W $1936                               ; $80C98D |

CODE_80C990:
  LDA.W $19C8                               ; $80C990 |
  BEQ CODE_80C996                           ; $80C993 |
  RTL                                       ; $80C995 |


CODE_80C996:
  LDX.W #$0000                              ; $80C996 |

  JSL.L CODE_FL_80C99E                      ; $80C999 |
  RTL                                       ; $80C99D |


CODE_FL_80C99E:
  LDA.W $1936                               ; $80C99E |
  BNE CODE_80C9F0                           ; $80C9A1 |
  LDA.B $4E                                 ; $80C9A3 |
  ASL A                                     ; $80C9A5 |
  CLC                                       ; $80C9A6 |
  ADC.B $4E                                 ; $80C9A7 |
  TAY                                       ; $80C9A9 |
  LDA.W PTR24_818E27,Y                      ; $80C9AA |
  STA.B $00                                 ; $80C9AD |
  LDA.W PTR24_818E27+2,Y                    ; $80C9AF |
  AND.W #$00FF                              ; $80C9B2 |
  STA.B $02                                 ; $80C9B5 |
  LDY.B $70,X                               ; $80C9B7 |
  BEQ CODE_80C9BF                           ; $80C9B9 |
  DEC.B $72,X                               ; $80C9BB |
  BPL CODE_80C9EC                           ; $80C9BD |

CODE_80C9BF:
  LDA.B [$00],Y                             ; $80C9BF |
  AND.W #$00FF                              ; $80C9C1 |
  CMP.W #$00FF                              ; $80C9C4 |
  BEQ CODE_80C9F0                           ; $80C9C7 |
  CPY.W #$0000                              ; $80C9C9 |
  BNE CODE_80C9D2                           ; $80C9CC |
  DEC A                                     ; $80C9CE |
  DEC A                                     ; $80C9CF |
  BRA CODE_80C9D8                           ; $80C9D0 |


CODE_80C9D2:
  CMP.W #$00FE                              ; $80C9D2 |
  BNE CODE_80C9D8                           ; $80C9D5 |
  DEC A                                     ; $80C9D7 |

CODE_80C9D8:
  STA.B $72,X                               ; $80C9D8 |
  INC.B $70,X                               ; $80C9DA |
  INC.B $70,X                               ; $80C9DC |

CODE_80C9DE:
  LDA.B [$00],Y                             ; $80C9DE |
  AND.W #$FF00                              ; $80C9E0 |
  STA.B $28,X                               ; $80C9E3 |
  STZ.B $30,X                               ; $80C9E5 |
  JSL.L CODE_FL_80CA1A                      ; $80C9E7 |

CODE_80C9EB:
  RTL                                       ; $80C9EB |


CODE_80C9EC:
  DEY                                       ; $80C9EC |
  DEY                                       ; $80C9ED |
  BRA CODE_80C9DE                           ; $80C9EE |


CODE_80C9F0:
  LDA.W $1FA0                               ; $80C9F0 |
  BEQ CODE_80CA05                           ; $80C9F3 |
  CMP.W #$000F                              ; $80C9F5 |
  BNE CODE_80CA01                           ; $80C9F8 |
  LDA.W #$00EB                              ; $80C9FA |
  JSL.L push_sound_queue                    ; $80C9FD |

CODE_80CA01:
  DEC.W $1FA0                               ; $80CA01 |
  RTL                                       ; $80CA04 |


CODE_80CA05:
  LDA.W #$0001                              ; $80CA05 |
  CMP.B $3E                                 ; $80CA08 |
  BEQ CODE_80CA19                           ; $80CA0A |
  STA.B $3E                                 ; $80CA0C |
  LDA.B $4E                                 ; $80CA0E |
  INC A                                     ; $80CA10 |
  CMP.W #$0005                              ; $80CA11 |
  BNE CODE_80CA17                           ; $80CA14 |
  TDC                                       ; $80CA16 |

CODE_80CA17:
  STA.B $4E                                 ; $80CA17 |

CODE_80CA19:
  RTL                                       ; $80CA19 |


CODE_FL_80CA1A:
  LDA.B $28,X                               ; $80CA1A |
  AND.W #$FF3F                              ; $80CA1C |
  STA.B $08                                 ; $80CA1F |
  SEP #$20                                  ; $80CA21 |
  LDA.B $29,X                               ; $80CA23 |
  STA.B $07                                 ; $80CA25 |
  ASL A                                     ; $80CA27 |
  ORA.B $28,X                               ; $80CA28 |
  STA.B $28,X                               ; $80CA2A |
  REP #$20                                  ; $80CA2C |
  LDA.B $28,X                               ; $80CA2E |
  AND.W #$EF20                              ; $80CA30 |
  STA.B $28,X                               ; $80CA33 |
  SEP #$20                                  ; $80CA35 |
  LDA.W $19CB,X                             ; $80CA37 |
  CMP.B $07                                 ; $80CA3A |
  BEQ CODE_80CA56                           ; $80CA3C |
  STA.B $07                                 ; $80CA3E |
  ASL A                                     ; $80CA40 |
  STA.B $06                                 ; $80CA41 |
  REP #$20                                  ; $80CA43 |
  LDA.B $06                                 ; $80CA45 |
  AND.W #$EFC0                              ; $80CA47 |
  STA.B $06                                 ; $80CA4A |
  LDA.B $28,X                               ; $80CA4C |
  EOR.B $06                                 ; $80CA4E |
  AND.B $28,X                               ; $80CA50 |
  BEQ CODE_80CA56                           ; $80CA52 |
  STA.B $30,X                               ; $80CA54 |

CODE_80CA56:
  REP #$20                                  ; $80CA56 |
  LDA.B $08                                 ; $80CA58 |
  STA.W $19CA,X                             ; $80CA5A |
  RTL                                       ; $80CA5D |


CODE_FL_80CA5E:
  PHB                                       ; $80CA5E |
  PEA.W $8100                               ; $80CA5F |
  PLB                                       ; $80CA62 |
  PLB                                       ; $80CA63 |
  JSL.L CODE_FL_80CA8C                      ; $80CA64 |
  TAY                                       ; $80CA68 |
  LDA.W DATA8_81EEFA,Y                      ; $80CA69 |
  PLB                                       ; $80CA6C |
  BIT.W #$0020                              ; $80CA6D |
  RTL                                       ; $80CA70 |

  PHB                                       ; $80CA71 |
  PEA.W $0000                               ; $80CA72 |
  PLB                                       ; $80CA75 |
  PLB                                       ; $80CA76 |
  JSL.L CODE_FL_80CA8C                      ; $80CA77 |
  PLB                                       ; $80CA7B |
  RTL                                       ; $80CA7C |


CODE_FL_80CA7D:
  LDA.B $3A,X                               ; $80CA7D |
  AND.W #$0004                              ; $80CA7F |
  BEQ CODE_80CA8B                           ; $80CA82 |
  LDA.B $E8                                 ; $80CA84 |
  BEQ CODE_FL_80CAA4                        ; $80CA86 |
  JMP.W CODE_JP_80CB6A                      ; $80CA88 |


CODE_80CA8B:
  RTL                                       ; $80CA8B |


CODE_FL_80CA8C:
  LDA.B $E8                                 ; $80CA8C |
  BEQ CODE_FL_80CAA4                        ; $80CA8E |
  JMP.W CODE_JP_80CB6A                      ; $80CA90 |

  RTL                                       ; $80CA93 |


CODE_FL_80CA94:
  BRA CODE_FL_80CAA4                        ; $80CA94 |


CODE_80CA96:
  LDA.W #$0000                              ; $80CA96 |
  RTL                                       ; $80CA99 |

  LDA.B $0D,X                               ; $80CA9A |
  STA.B $0A                                 ; $80CA9C |
  LDA.B $09,X                               ; $80CA9E |
  STA.B $08                                 ; $80CAA0 |
  BRA CODE_FL_80CADB                        ; $80CAA2 |


CODE_FL_80CAA4:
  REP #$20                                  ; $80CAA4 |
  LDA.B $E8                                 ; $80CAA6 |
  BEQ CODE_80CAAD                           ; $80CAA8 |
  JMP.W CODE_JP_80CB98                      ; $80CAAA |


CODE_80CAAD:
  LDA.W $1662                               ; $80CAAD |
  AND.W #$000F                              ; $80CAB0 |
  CLC                                       ; $80CAB3 |
  ADC.B $08                                 ; $80CAB4 |
  BMI CODE_80CABF                           ; $80CAB6 |
  CMP.W #$0140                              ; $80CAB8 |
  BCS CODE_80CA96                           ; $80CABB |
  BRA CODE_80CAC4                           ; $80CABD |


CODE_80CABF:
  CMP.W #$FFC0                              ; $80CABF |
  BCC CODE_80CA96                           ; $80CAC2 |

CODE_80CAC4:
  LDA.W $1672                               ; $80CAC4 |
  AND.W #$000F                              ; $80CAC7 |
  CLC                                       ; $80CACA |
  ADC.B $0A                                 ; $80CACB |
  BMI CODE_80CAD6                           ; $80CACD |
  CMP.W #$0140                              ; $80CACF |
  BCS CODE_80CA96                           ; $80CAD2 |
  BRA CODE_80CAE2                           ; $80CAD4 |


CODE_80CAD6:
  CMP.W #$FFC0                              ; $80CAD6 |
  BCC CODE_80CA96                           ; $80CAD9 |

CODE_FL_80CADB:
  LDA.B $E8                                 ; $80CADB |
  BEQ CODE_80CAE2                           ; $80CADD |
  JMP.W CODE_JP_80CB98                      ; $80CADF |


CODE_80CAE2:
  STX.B $05                                 ; $80CAE2 |
  LDA.W $1672                               ; $80CAE4 |
  CLC                                       ; $80CAE7 |
  ADC.B $0A                                 ; $80CAE8 |
  STA.B $02                                 ; $80CAEA |
  LDA.W $1662                               ; $80CAEC |
  CLC                                       ; $80CAEF |
  ADC.B $08                                 ; $80CAF0 |
  STA.B $00                                 ; $80CAF2 |
  AND.W #$00F0                              ; $80CAF4 |
  SEP #$20                                  ; $80CAF7 |
  LSR A                                     ; $80CAF9 |
  LSR A                                     ; $80CAFA |
  LSR A                                     ; $80CAFB |
  STA.B $00                                 ; $80CAFC |
  LDA.B $01                                 ; $80CAFE |
  AND.B #$01                                ; $80CB00 |
  ASL A                                     ; $80CB02 |
  ASL A                                     ; $80CB03 |
  STA.B $01                                 ; $80CB04 |
  LDA.B $03                                 ; $80CB06 |
  AND.B #$01                                ; $80CB08 |
  ASL A                                     ; $80CB0A |
  ASL A                                     ; $80CB0B |
  ASL A                                     ; $80CB0C |
  ORA.B $01                                 ; $80CB0D |
  STA.B $01                                 ; $80CB0F |
  LDA.B $02                                 ; $80CB11 |
  AND.B #$F0                                ; $80CB13 |
  REP #$20                                  ; $80CB15 |
  ASL A                                     ; $80CB17 |
  ASL A                                     ; $80CB18 |
  ADC.B $00                                 ; $80CB19 |
  TAX                                       ; $80CB1B |
  LDA.L $7F8000,X                           ; $80CB1C |
  LDX.B $05                                 ; $80CB20 |
  AND.W #$00FF                              ; $80CB22 |
  RTL                                       ; $80CB25 |

  STX.B $05                                 ; $80CB26 |
  LDA.W $1672                               ; $80CB28 |
  CLC                                       ; $80CB2B |
  ADC.B $0A                                 ; $80CB2C |
  STA.B $02                                 ; $80CB2E |
  LDA.W $1662                               ; $80CB30 |
  CLC                                       ; $80CB33 |
  ADC.B $08                                 ; $80CB34 |
  STA.B $00                                 ; $80CB36 |
  AND.W #$00F8                              ; $80CB38 |
  SEP #$20                                  ; $80CB3B |
  LSR A                                     ; $80CB3D |
  LSR A                                     ; $80CB3E |
  LSR A                                     ; $80CB3F |
  STA.B $00                                 ; $80CB40 |
  LDA.B $01                                 ; $80CB42 |
  AND.B #$01                                ; $80CB44 |
  ASL A                                     ; $80CB46 |
  ASL A                                     ; $80CB47 |
  STA.B $01                                 ; $80CB48 |
  LDA.B $03                                 ; $80CB4A |
  AND.B #$01                                ; $80CB4C |
  ASL A                                     ; $80CB4E |
  ASL A                                     ; $80CB4F |
  ASL A                                     ; $80CB50 |
  ORA.B $01                                 ; $80CB51 |
  STA.B $01                                 ; $80CB53 |
  LDA.B $02                                 ; $80CB55 |
  AND.B #$F8                                ; $80CB57 |
  REP #$20                                  ; $80CB59 |

  ASL A                                     ; $80CB5B |
  ASL A                                     ; $80CB5C |

  ADC.B $00                                 ; $80CB5D |

  TAX                                       ; $80CB5F |
  LDA.L $7F7000,X                           ; $80CB60 |
  LDX.B $05                                 ; $80CB64 |
  AND.W #$00FF                              ; $80CB66 |
  RTL                                       ; $80CB69 |


CODE_JP_80CB6A:
  REP #$20                                  ; $80CB6A |
  STX.B $05                                 ; $80CB6C |
  LDA.W $1672                               ; $80CB6E |
  SEC                                       ; $80CB71 |
  SBC.W #$0100                              ; $80CB72 |
  CLC                                       ; $80CB75 |
  ADC.B $0A                                 ; $80CB76 |
  BMI CODE_80CB94                           ; $80CB78 |
  CMP.B $B0                                 ; $80CB7A |
  BCS CODE_80CB94                           ; $80CB7C |
  STA.B $02                                 ; $80CB7E |
  LDA.W $1662                               ; $80CB80 |
  SEC                                       ; $80CB83 |
  SBC.W #$0100                              ; $80CB84 |

  CLC                                       ; $80CB87 |
  ADC.B $08                                 ; $80CB88 |
  BMI CODE_80CB94                           ; $80CB8A |
  CMP.B $AE                                 ; $80CB8C |
  BCS CODE_80CB94                           ; $80CB8E |
  STA.B $00                                 ; $80CB90 |
  BRA CODE_80CBB2                           ; $80CB92 |


CODE_80CB94:
  LDA.W #$0000                              ; $80CB94 |
  RTL                                       ; $80CB97 |


CODE_JP_80CB98:
  STX.B $05                                 ; $80CB98 |
  LDA.W $1672                               ; $80CB9A |
  SEC                                       ; $80CB9D |
  SBC.W #$0100                              ; $80CB9E |
  CLC                                       ; $80CBA1 |
  ADC.B $0A                                 ; $80CBA2 |
  STA.B $02                                 ; $80CBA4 |
  LDA.W $1662                               ; $80CBA6 |
  SEC                                       ; $80CBA9 |
  SBC.W #$0100                              ; $80CBAA |
  CLC                                       ; $80CBAD |
  ADC.B $08                                 ; $80CBAE |
  STA.B $00                                 ; $80CBB0 |

CODE_80CBB2:
  LDA.B $03                                 ; $80CBB2 |
  AND.W #$00FF                              ; $80CBB4 |
  STA.W !reg_wrmpya                         ; $80CBB7 |
  LDA.W $00F3                               ; $80CBBA |
  STA.W !reg_wrmpyb                         ; $80CBBD |
  LSR.B $00                                 ; $80CBC0 |
  LSR.B $00                                 ; $80CBC2 |
  LSR.B $00                                 ; $80CBC4 |
  LSR.B $00                                 ; $80CBC6 |
  SEP #$20                                  ; $80CBC8 |
  LDA.B $01                                 ; $80CBCA |
  CLC                                       ; $80CBCC |

  ADC.W !reg_rdmpyl                         ; $80CBCD |
  STA.B $01                                 ; $80CBD0 |
  REP #$20                                  ; $80CBD2 |
  LDA.B $02                                 ; $80CBD4 |
  AND.W #$00FF                              ; $80CBD6 |
  LSR A                                     ; $80CBD9 |
  LSR A                                     ; $80CBDA |
  LSR A                                     ; $80CBDB |
  LSR A                                     ; $80CBDC |
  STA.W !reg_wrmpya                         ; $80CBDD |
  LDA.W $00F0                               ; $80CBE0 |
  STA.W !reg_wrmpyb                         ; $80CBE3 |
  LDA.B $00                                 ; $80CBE6 |
  NOP                                       ; $80CBE8 |
  NOP                                       ; $80CBE9 |
  CLC                                       ; $80CBEA |
  ADC.W !reg_rdmpyl                         ; $80CBEB |
  TAX                                       ; $80CBEE |
  LDA.L $7F7006,X                           ; $80CBEF |
  AND.W #$00FF                              ; $80CBF3 |
  LDX.B $05                                 ; $80CBF6 |
  RTL                                       ; $80CBF8 |

  LDA.W #$0000                              ; $80CBF9 |
  LDX.B $05                                 ; $80CBFC |
  RTL                                       ; $80CBFE |


CODE_80CBFF:
  LDA.W #$0000                              ; $80CBFF |
  RTL                                       ; $80CC02 |


CODE_FL_80CC03:
  STX.B $05                                 ; $80CC03 |
  LDA.W $16E5                               ; $80CC05 |
  AND.W #$FF00                              ; $80CC08 |
  STA.B $00                                 ; $80CC0B |
  LDA.W $16E7                               ; $80CC0D |
  AND.W #$FF00                              ; $80CC10 |
  STA.B $02                                 ; $80CC13 |
  LDA.W $1672                               ; $80CC15 |
  CLC                                       ; $80CC18 |
  ADC.B $0A                                 ; $80CC19 |
  BMI CODE_80CBFF                           ; $80CC1B |
  CMP.B $02                                 ; $80CC1D |
  BCS CODE_80CBFF                           ; $80CC1F |
  STA.B $02                                 ; $80CC21 |
  LDA.W $1662                               ; $80CC23 |
  CLC                                       ; $80CC26 |
  ADC.B $08                                 ; $80CC27 |
  BMI CODE_80CBFF                           ; $80CC29 |
  CMP.B $00                                 ; $80CC2B |
  BCS CODE_80CBFF                           ; $80CC2D |
  STA.B $00                                 ; $80CC2F |
  LDA.B $03                                 ; $80CC31 |
  AND.W #$00FF                              ; $80CC33 |
  STA.W !reg_wrmpya                         ; $80CC36 |
  LDA.W $00F3                               ; $80CC39 |
  STA.W !reg_wrmpyb                         ; $80CC3C |
  LSR.B $00                                 ; $80CC3F |
  LSR.B $00                                 ; $80CC41 |
  LSR.B $00                                 ; $80CC43 |
  LSR.B $00                                 ; $80CC45 |
  SEP #$20                                  ; $80CC47 |
  LDA.B $01                                 ; $80CC49 |
  CLC                                       ; $80CC4B |
  ADC.W !reg_rdmpyl                         ; $80CC4C |
  STA.B $01                                 ; $80CC4F |
  REP #$20                                  ; $80CC51 |
  LDA.B $02                                 ; $80CC53 |
  AND.W #$00FF                              ; $80CC55 |
  LSR A                                     ; $80CC58 |
  LSR A                                     ; $80CC59 |
  LSR A                                     ; $80CC5A |
  LSR A                                     ; $80CC5B |
  STA.W !reg_wrmpya                         ; $80CC5C |
  LDA.W $00F0                               ; $80CC5F |
  STA.W !reg_wrmpyb                         ; $80CC62 |
  LDA.B $00                                 ; $80CC65 |
  NOP                                       ; $80CC67 |
  NOP                                       ; $80CC68 |
  CLC                                       ; $80CC69 |
  ADC.W !reg_rdmpyl                         ; $80CC6A |
  TAX                                       ; $80CC6D |
  LDA.L $7F7006,X                           ; $80CC6E |
  LDX.B $05                                 ; $80CC72 |
  RTL                                       ; $80CC74 |


CODE_FL_80CC75:
  CPX.W #$0002                              ; $80CC75 |
  BEQ CODE_80CC83                           ; $80CC78 |
  LDA.B $E4                                 ; $80CC7A |
  BEQ CODE_80CC8C                           ; $80CC7C |
  LDY.W #$0400                              ; $80CC7E |
  BRA CODE_80CC99                           ; $80CC81 |


CODE_80CC83:
  LDA.B $E4                                 ; $80CC83 |

  BEQ CODE_80CC8C                           ; $80CC85 |
  LDY.W #$04C0                              ; $80CC87 |
  BRA CODE_80CC99                           ; $80CC8A |


CODE_80CC8C:
  LDA.B $28,X                               ; $80CC8C |
  STA.B $96                                 ; $80CC8E |
  LDA.B $30,X                               ; $80CC90 |
  STA.B $98                                 ; $80CC92 |
  ORA.B $9C,X                               ; $80CC94 |
  STA.B $9A                                 ; $80CC96 |
  RTL                                       ; $80CC98 |


CODE_80CC99:
  LDA.W $0098,Y                             ; $80CC99 |
  STA.B $96                                 ; $80CC9C |
  LDA.W $009A,Y                             ; $80CC9E |
  STA.B $98                                 ; $80CCA1 |
  STA.B $9A                                 ; $80CCA3 |
  RTL                                       ; $80CCA5 |

  RTL                                       ; $80CCA6 |


CODE_FL_80CCA7:
  LDA.B $7E                                 ; $80CCA7 |
  ASL A                                     ; $80CCA9 |
  TAX                                       ; $80CCAA |
  LDA.W PTR16_818EAE,X                      ; $80CCAB |
  PHA                                       ; $80CCAE |
  RTS                                       ; $80CCAF |

CODE_FL_80CCB0:
  LDA.W $1F30                               ; $80CCB0 |
  BNE CODE_80CCF4                           ; $80CCB3 |
  JSL.L CODE_FL_808302                      ; $80CCB5 |
  LDA.W #$1090                              ; $80CCB9 |
  STA.W $1968                               ; $80CCBC |

  JSL.L CODE_FL_808BC2                      ; $80CCBF |

  JSL.L CODE_FL_80C1ED                      ; $80CCC3 |
  JSL.L CODE_FL_808D45                      ; $80CCC7 |
  JSL.L CODE_FL_80977D                      ; $80CCCB |
  STZ.W $196A                               ; $80CCCF |
  STZ.W $0400                               ; $80CCD2 |
  STZ.W $04C0                               ; $80CCD5 |
  LDY.W #$B6B6                              ; $80CCD8 |
  JSL.L CODE_FL_80C27C                      ; $80CCDB |
  JSL.L CODE_FL_80D55E                      ; $80CCDF |

  LDA.W #$0001                              ; $80CCE3 |
  STA.B $5C                                 ; $80CCE6 |
  JSL.L CODE_FL_859007                      ; $80CCE8 |
  JSL.L CODE_FL_808315                      ; $80CCEC |
  JML.L CODE_FL_80C873                      ; $80CCF0 |


CODE_80CCF4:
  RTL                                       ; $80CCF4 |


CODE_FL_80CCF5:
  STZ.W $0426                               ; $80CCF5 |
  STZ.W $0428                               ; $80CCF8 |
  STZ.W $04E6                               ; $80CCFB |
  STZ.W $04E8                               ; $80CCFE |
  BRA CODE_80CD22                           ; $80CD01 |


CODE_FL_80CD03:
  JSR.W CODE_FN_80CF91                      ; $80CD03 |
  LDA.B $78                                 ; $80CD06 |
  BEQ CODE_80CD22                           ; $80CD08 |
  AND.W #$00FF                              ; $80CD0A |
  CMP.W #$0001                              ; $80CD0D |
  BNE CODE_80CD15                           ; $80CD10 |
  JMP.W CODE_JP_80CF90                      ; $80CD12 |


CODE_80CD15:
  CMP.W #$0002                              ; $80CD15 |
  BNE CODE_80CD1E                           ; $80CD18 |
  JML.L CODE_JL_8DED7A                      ; $80CD1A |


CODE_80CD1E:
  JML.L CODE_JL_8DEF32                      ; $80CD1E |


CODE_80CD22:
  LDA.B $76                                 ; $80CD22 |
  AND.W #$0002                              ; $80CD24 |
  STA.B $76                                 ; $80CD27 |
  JSL.L CODE_FL_8380F8                      ; $80CD29 |
  JSL.L CODE_FL_83AC78                      ; $80CD2D |
  JSL.L CODE_FL_8590A4                      ; $80CD31 |
  JSL.L CODE_FL_8CA04E                      ; $80CD35 |
  JSL.L CODE_FL_83FB19                      ; $80CD39 |
  JSL.L CODE_FL_83DC10                      ; $80CD3D |
  LDA.B $E8                                 ; $80CD41 |
  BNE CODE_80CD4B                           ; $80CD43 |
  JSL.L CODE_FL_80D9D3                      ; $80CD45 |
  BRA CODE_80CD4F                           ; $80CD49 |


CODE_80CD4B:
  JSL.L CODE_FL_80DF1A                      ; $80CD4B |

CODE_80CD4F:
  JSL.L CODE_FL_80CF06                      ; $80CD4F |
  STZ.W $19B2                               ; $80CD53 |
  JSL.L CODE_FL_92FFD7                      ; $80CD56 |
  JSL.L CODE_FL_859133                      ; $80CD5A |
  JSL.L CODE_FL_85859C                      ; $80CD5E |
  JSL.L CODE_FL_84A2E9                      ; $80CD62 |
  JSL.L CODE_FL_8DFE7D                      ; $80CD66 |
  LDA.B $3A                                 ; $80CD6A |
  CMP.W #$0009                              ; $80CD6C |
  BNE CODE_80CD7E                           ; $80CD6F |
  LDA.B $7E                                 ; $80CD71 |
  CMP.W #$0003                              ; $80CD73 |
  BNE CODE_80CD7E                           ; $80CD76 |
  LDA.B $B2                                 ; $80CD78 |
  CMP.B !r_room_id                          ; $80CD7A |
  BEQ CODE_80CD94                           ; $80CD7C |

CODE_80CD7E:
  LDA.B $B2                                 ; $80CD7E |
  STA.W $1938                               ; $80CD80 |
  LDA.B !r_room_id                          ; $80CD83 |
  PHA                                       ; $80CD85 |
  LDA.B $B2                                 ; $80CD86 |
  STA.B !r_room_id                          ; $80CD88 |
  JSL.L CODE_FL_85915F                      ; $80CD8A |
  STZ.W $19CC                               ; $80CD8E |
  PLA                                       ; $80CD91 |
  STA.B !r_room_id                          ; $80CD92 |

CODE_80CD94:
  RTL                                       ; $80CD94 |

CODE_FL_80CD95:
  JSL.L CODE_FL_86BB8C                      ; $80CD95 |
  LDA.W $19CC                               ; $80CD99 |
  BEQ CODE_80CDA4                           ; $80CD9C |
  JSL.L CODE_FL_92FD40                      ; $80CD9E |
  BCS CODE_80CDA8                           ; $80CDA2 |

CODE_80CDA4:
  JML.L CODE_JL_80CDCD                      ; $80CDA4 |


CODE_80CDA8:
  RTL                                       ; $80CDA8 |

CODE_FL_80CDA9:
  JSL.L CODE_FL_86BB8C                      ; $80CDA9 |
  JML.L CODE_JL_80CDF3                      ; $80CDAD |

CODE_FL_80CDB1:
  JSL.L CODE_FL_86BB8C                      ; $80CDB1 |
  JSL.L CODE_FL_83D46C                      ; $80CDB5 |
  JSL.L CODE_FL_80CE2C                      ; $80CDB9 |
  JSL.L CODE_FL_A0FA43                      ; $80CDBD |
  JML.L CODE_FL_808315                      ; $80CDC1 |

CODE_FL_80CDC5:
  JSL.L CODE_FL_86BB8C                      ; $80CDC5 |
  JML.L CODE_FL_80CE75                      ; $80CDC9 |


CODE_JL_80CDCD:
  JSL.L CODE_FL_80B05F                      ; $80CDCD |
  JSL.L CODE_FL_80D50D                      ; $80CDD1 |

  JSL.L CODE_FL_80C873                      ; $80CDD5 |
  LDA.W #$0040                              ; $80CDD9 |
  STA.W $1754                               ; $80CDDC |
  JSL.L CODE_FL_8089DB                      ; $80CDDF |
  JSL.L CODE_FL_A0F9E7                      ; $80CDE3 |
  LDA.W $1FA0                               ; $80CDE7 |
  AND.W #$000F                              ; $80CDEA |
  BEQ CODE_80CE2B                           ; $80CDED |
  JML.L CODE_FL_80C213                      ; $80CDEF |


CODE_JL_80CDF3:
  LDA.W $1F30                               ; $80CDF3 |
  BNE CODE_80CE2B                           ; $80CDF6 |
  JSR.W CODE_FN_80D05B                      ; $80CDF8 |
  SEP #$20                                  ; $80CDFB |
  LDA.B #$22                                ; $80CDFD |
  STA.W !reg_bg12nba                        ; $80CDFF |
  REP #$20                                  ; $80CE02 |
  JSL.L CODE_FL_808302                      ; $80CE04 |
  JSL.L CODE_FL_808C9F                      ; $80CE08 |
  JSL.L CODE_FL_80977D                      ; $80CE0C |
  STZ.W $19B4                               ; $80CE10 |
  JSL.L CODE_FL_85858F                      ; $80CE13 |
  JSL.L CODE_FL_859007                      ; $80CE17 |
  JSL.L CODE_FL_80C1ED                      ; $80CE1B |
  JSL.L CODE_FL_808D45                      ; $80CE1F |
  JSL.L CODE_FL_808315                      ; $80CE23 |
  JML.L CODE_FL_80C873                      ; $80CE27 |


CODE_80CE2B:
  RTL                                       ; $80CE2B |


CODE_FL_80CE2C:
  STZ.B $A4                                 ; $80CE2C |
  JSL.L CODE_FL_80D53F                      ; $80CE2E |
  JSL.L CODE_FL_80D52D                      ; $80CE32 |
  JSL.L CODE_FL_808302                      ; $80CE36 |
  LDA.W $19B6                               ; $80CE3A |
  CMP.B !r_room_mode                        ; $80CE3D |
  BNE CODE_80CE45                           ; $80CE3F |
  JSL.L CODE_FL_80CFFD                      ; $80CE41 |

CODE_80CE45:
  JSL.L CODE_FL_80D571                      ; $80CE45 |
  JSL.L CODE_FL_8584E1                      ; $80CE49 |

CODE_80CE4D:
  JSL.L CODE_FL_80D7A5                      ; $80CE4D |
  JSL.L CODE_FL_809570                      ; $80CE51 |
  JSL.L CODE_FL_92FFD7                      ; $80CE55 |

  JSL.L CODE_FL_85859C                      ; $80CE59 |
  LDA.W $1754                               ; $80CE5D |
  BNE CODE_80CE4D                           ; $80CE60 |
  LDY.W #$B6B6                              ; $80CE62 |

  JSL.L CODE_FL_80C27C                      ; $80CE65 |
  JSL.L CODE_FL_80D55E                      ; $80CE69 |
  JSL.L CODE_FL_83B27C                      ; $80CE6D |

  JML.L CODE_FL_80C873                      ; $80CE71 |


CODE_FL_80CE75:
  JSR.W CODE_FN_80D1AC                      ; $80CE75 |
  JSL.L CODE_FL_84A1E6                      ; $80CE78 |
  JSL.L CODE_FL_838051                      ; $80CE7C |
  JSL.L CODE_FL_80C239                      ; $80CE80 |
  JSL.L CODE_FL_80B04D                      ; $80CE84 |
  STZ.W $197E                               ; $80CE88 |
  LDA.W #$0003                              ; $80CE8B |
  STA.B $7E                                 ; $80CE8E |

  STZ.B $84                                 ; $80CE90 |
  RTL                                       ; $80CE92 |

CODE_FL_80CE93:
  LDA.W #$0001                              ; $80CE93 |
  STA.B $76                                 ; $80CE96 |
  LDA.W $1F30                               ; $80CE98 |
  BNE CODE_80CEB4                           ; $80CE9B |
  LDA.W $0418                               ; $80CE9D |
  ORA.W $04D8                               ; $80CEA0 |

  BEQ CODE_80CEB5                           ; $80CEA3 |

CODE_JL_80CEA5:
  JSL.L CODE_FL_8482D4                      ; $80CEA5 |
  LDA.W #$0009                              ; $80CEA9 |
  JSL.L CODE_FL_8085EC                      ; $80CEAC |
  JSL.L CODE_FL_808938                      ; $80CEB0 |

CODE_80CEB4:
  RTL                                       ; $80CEB4 |


CODE_80CEB5:
  LDA.W #$000B                              ; $80CEB5 |
  JML.L CODE_FL_8085EC                      ; $80CEB8 |

  LDA.W #$0001                              ; $80CEBC |
  STA.B $76                                 ; $80CEBF |
  LDA.W $1F30                               ; $80CEC1 |
  BNE CODE_80CED9                           ; $80CEC4 |
  LDA.W $0418                               ; $80CEC6 |
  ORA.W $04D8                               ; $80CEC9 |
  BEQ CODE_80CEB5                           ; $80CECC |
  LDA.W #$0009                              ; $80CECE |
  JSL.L CODE_FL_8085EC                      ; $80CED1 |
  JSL.L CODE_FL_808938                      ; $80CED5 |

CODE_80CED9:
  RTL                                       ; $80CED9 |

CODE_FL_80CEDA:
  JSL.L CODE_FL_80CCF5                      ; $80CEDA |
  LDA.W $1F30                               ; $80CEDE |
  BNE CODE_80CEB4                           ; $80CEE1 |
  LDA.W #$0009                              ; $80CEE3 |
  JSL.L CODE_FL_8085EC                      ; $80CEE6 |
  JML.L CODE_FL_808938                      ; $80CEEA |

  LDA.W #$0001                              ; $80CEEE |
  STA.W $1978                               ; $80CEF1 |
  LDX.W #$04C0                              ; $80CEF4 |

CODE_80CEF7:
  STX.B $94                                 ; $80CEF7 |
  JSL.L CODE_FL_83DB41                      ; $80CEF9 |
  LDX.W #$0400                              ; $80CEFD |
  DEC.W $1978                               ; $80CF00 |
  BEQ CODE_80CEF7                           ; $80CF03 |
  RTL                                       ; $80CF05 |


CODE_FL_80CF06:
  LDA.W #$0001                              ; $80CF06 |
  STA.W $1978                               ; $80CF09 |
  LDX.W #$04C0                              ; $80CF0C |

CODE_80CF0F:
  STX.B $94                                 ; $80CF0F |
  LDA.B $18,X                               ; $80CF11 |
  BEQ CODE_80CF19                           ; $80CF13 |
  JSL.L CODE_FL_83DB41                      ; $80CF15 |

CODE_80CF19:
  LDX.W #$0400                              ; $80CF19 |
  DEC.W $1978                               ; $80CF1C |
  BEQ CODE_80CF0F                           ; $80CF1F |
  RTL                                       ; $80CF21 |

CODE_FL_80CF22:
  JSL.L CODE_FL_80CD03                      ; $80CF22 |
  LDA.W $1F30                               ; $80CF26 |

  BNE CODE_80CF35                           ; $80CF29 |
  STZ.B $3A                                 ; $80CF2B |
  JSL.L CODE_FL_80883F                      ; $80CF2D |
  JSL.L CODE_FL_8088AF                      ; $80CF31 |

CODE_80CF35:
  RTL                                       ; $80CF35 |

CODE_FL_80CF36:
  JSL.L CODE_FL_80CCF5                      ; $80CF36 |
  LDA.W $1F30                               ; $80CF3A |
  BNE CODE_80CF46                           ; $80CF3D |
  LDA.W #$000B                              ; $80CF3F |
  JML.L CODE_FL_8085EC                      ; $80CF42 |


CODE_80CF46:
  RTL                                       ; $80CF46 |

CODE_FL_80CF47:
  LDA.W $1F30                               ; $80CF47 |
  BNE CODE_80CF46                           ; $80CF4A |
  LDA.W #$0002                              ; $80CF4C |
  STA.B !r_room_mode                        ; $80CF4F |
  LDA.W #$8000                              ; $80CF51 |
  STA.B $DA                                 ; $80CF54 |
  LDA.W #$0000                              ; $80CF56 |
  JML.L CODE_FL_80C876                      ; $80CF59 |

  LDA.W #$000A                              ; $80CF5D |
  STA.B $7E                                 ; $80CF60 |
  STZ.B $80                                 ; $80CF62 |
  STZ.B $3C                                 ; $80CF64 |
  JSL.L CODE_FL_808938                      ; $80CF66 |
  JML.L CODE_FL_80C213                      ; $80CF6A |

  LDA.B $7E                                 ; $80CF6E |
  CMP.W #$0003                              ; $80CF70 |

  BNE CODE_80CF82                           ; $80CF73 |
  LDA.W #$0008                              ; $80CF75 |
  STA.B $7E                                 ; $80CF78 |
  JSL.L CODE_FL_808938                      ; $80CF7A |
  JML.L CODE_FL_80C213                      ; $80CF7E |


CODE_80CF82:
  RTL                                       ; $80CF82 |

  LDA.W #$0009                              ; $80CF83 |
  STA.B $7E                                 ; $80CF86 |
  JSL.L CODE_FL_808938                      ; $80CF88 |
  JML.L CODE_FL_80C213                      ; $80CF8C |


CODE_JP_80CF90:
  RTL                                       ; $80CF90 |


CODE_FN_80CF91:
  LDA.L $7E7D90                             ; $80CF91 |

  BNE CODE_80CFFC                           ; $80CF95 |
  LDA.B $78                                 ; $80CF97 |

  BNE CODE_80CFFC                           ; $80CF99 |
  LDA.B $E4                                 ; $80CF9B |
  BNE CODE_80CFFC                           ; $80CF9D |

  JSL.L CODE_FL_8DFF29                      ; $80CF9F |

  BIT.W #$0040                              ; $80CFA3 |
  BEQ CODE_80CFE9                           ; $80CFA6 |
  LDA.B !r_room_mode                        ; $80CFA8 |
  CMP.W #$0001                              ; $80CFAA |
  BEQ CODE_80CFCF                           ; $80CFAD |
  LDA.W #$026E                              ; $80CFAF |
  JSL.L CODE_FL_80A634                      ; $80CFB2 |
  BCC CODE_80CFFC                           ; $80CFB6 |
  LDA.B !r_room_id                          ; $80CFB8 |
  CMP.W #$0132                              ; $80CFBA |
  BEQ CODE_80CFE2                           ; $80CFBD |
  CMP.W #$0133                              ; $80CFBF |
  BEQ CODE_80CFE2                           ; $80CFC2 |
  CMP.W #$0130                              ; $80CFC4 |

  BCS CODE_80CFFC                           ; $80CFC7 |
  LDA.B $CC                                 ; $80CFC9 |

  BEQ CODE_80CFFC                           ; $80CFCB |
  BRA CODE_80CFE2                           ; $80CFCD |


CODE_80CFCF:
  LDA.B !r_room_id                          ; $80CFCF |
  CMP.W #$002C                              ; $80CFD1 |
  BEQ CODE_80CFFC                           ; $80CFD4 |
  CMP.W #$0063                              ; $80CFD6 |
  BCC CODE_80CFE2                           ; $80CFD9 |
  CMP.W #$006B                              ; $80CFDB |
  BCS CODE_80CFE2                           ; $80CFDE |
  BRA CODE_80CFFC                           ; $80CFE0 |


CODE_80CFE2:
  LDA.W #$0003                              ; $80CFE2 |
  STA.B $78                                 ; $80CFE5 |
  BRA CODE_80CFFC                           ; $80CFE7 |


CODE_80CFE9:
  BIT.W #$1000                              ; $80CFE9 |
  BEQ CODE_80CFFC                           ; $80CFEC |
  LDA.B !r_room_id                          ; $80CFEE |
  CMP.W #$0140                              ; $80CFF0 |
  BCS CODE_80CFFC                           ; $80CFF3 |
  INC.B $78                                 ; $80CFF5 |
  INC.B $78                                 ; $80CFF7 |
  STZ.B $80                                 ; $80CFF9 |
  RTS                                       ; $80CFFB |


CODE_80CFFC:
  RTS                                       ; $80CFFC |


CODE_FL_80CFFD:
  REP #$30                                  ; $80CFFD |
  PHB                                       ; $80CFFF |
  LDA.W #$0000                              ; $80D000 |
  STA.L $7F4800                             ; $80D003 |
  LDA.W #$17FD                              ; $80D007 |
  LDX.W #$4801                              ; $80D00A |
  TXY                                       ; $80D00D |
  INY                                       ; $80D00E |
  MVN $7F,$7F                               ; $80D00F |
  PLB                                       ; $80D012 |
  LDA.B !r_room_mode                        ; $80D013 |
  CMP.W #$0000                              ; $80D015 |
  BEQ CODE_80D02E                           ; $80D018 |

  LDA.B $A0                                 ; $80D01A |
  CMP.W #$000B                              ; $80D01C |
  BCC CODE_80D024                           ; $80D01F |
  LDA.W #$0000                              ; $80D021 |

CODE_80D024:
  ASL A                                     ; $80D024 |
  TAY                                       ; $80D025 |
  LDA.W PTR16_818EC8,Y                      ; $80D026 |
  TAX                                       ; $80D029 |
  JML.L load_asset                          ; $80D02A |


CODE_80D02E:
  LDA.B $CC                                 ; $80D02E |
  CMP.W #$0003                              ; $80D030 |
  BCS CODE_80D05A                           ; $80D033 |
  ASL A                                     ; $80D035 |
  TAY                                       ; $80D036 |
  CPY.W #$0000                              ; $80D037 |
  BNE CODE_80D044                           ; $80D03A |
  LDA.L $7003EC                             ; $80D03C |
  BEQ CODE_80D04D                           ; $80D040 |
  BRA CODE_80D055                           ; $80D042 |


CODE_80D044:
  LDA.W #$0594                              ; $80D044 |
  JSL.L CODE_FL_8CF9D2                      ; $80D047 |
  BCS CODE_80D055                           ; $80D04B |

CODE_80D04D:
  LDA.W PTR16_818EDE,Y                      ; $80D04D |

CODE_80D050:
  TAX                                       ; $80D050 |
  JML.L load_asset                          ; $80D051 |


CODE_80D055:
  LDA.W PTR16_818EE2,Y                      ; $80D055 |
  BRA CODE_80D050                           ; $80D058 |


CODE_80D05A:
  RTL                                       ; $80D05A |


CODE_FN_80D05B:
  TDC                                       ; $80D05B |
  STA.L $7E7D90                             ; $80D05C |
  STZ.W $00E4                               ; $80D060 |
  LDY.B !r_room_mode                        ; $80D063 |
  CPY.W #$0000                              ; $80D065 |
  BEQ CODE_80D06F                           ; $80D068 |
  JSL.L CODE_FL_8B806B                      ; $80D06A |
  RTS                                       ; $80D06E |


CODE_80D06F:
  JSL.L CODE_FL_8B8067                      ; $80D06F |
  RTS                                       ; $80D073 |


CODE_FL_80D074:
  LDA.W #$0001                              ; $80D074 |
  STA.B $76                                 ; $80D077 |
  LDA.B $7E                                 ; $80D079 |
  ASL A                                     ; $80D07B |
  TAX                                       ; $80D07C |
  LDA.W PTR16_818EE6,X                      ; $80D07D |
  PHA                                       ; $80D080 |
  RTS                                       ; $80D081 |

CODE_FL_80D082:
  STZ.B $C4                                 ; $80D082 |
  STZ.W $197E                               ; $80D084 |
  JSR.W CODE_FN_80D05B                      ; $80D087 |
  INC.B $7E                                 ; $80D08A |
  LDA.W $199A                               ; $80D08C |
  BNE CODE_80D0A3                           ; $80D08F |
  STZ.W $1756                               ; $80D091 |
  STZ.W $1758                               ; $80D094 |
  LDA.W #$0080                              ; $80D097 |
  STA.W $195A                               ; $80D09A |
  STA.W $195C                               ; $80D09D |
  STZ.W $195E                               ; $80D0A0 |

CODE_80D0A3:
  LDA.W $00E6                               ; $80D0A3 |
  AND.W #$8000                              ; $80D0A6 |
  STA.W $00E6                               ; $80D0A9 |
  STZ.W $19B4                               ; $80D0AC |
  LDA.W #$FFFF                              ; $80D0AF |
  STA.B $C0                                 ; $80D0B2 |
  JSL.L CODE_FL_80B067                      ; $80D0B4 |
  STZ.B $A4                                 ; $80D0B8 |
  JSL.L CODE_FL_8089DB                      ; $80D0BA |
  STZ.W $19B6                               ; $80D0BE |
  JSL.L CODE_FL_80CFFD                      ; $80D0C1 |
  JSL.L CODE_FL_80D50D                      ; $80D0C5 |
  JSL.L CODE_FL_808CFC                      ; $80D0C9 |
  JSL.L CODE_FL_85858F                      ; $80D0CD |
  LDA.W $1FA0                               ; $80D0D1 |
  AND.W #$007F                              ; $80D0D4 |
  BEQ CODE_80D0DD                           ; $80D0D7 |
  JML.L CODE_FL_80C213                      ; $80D0D9 |


CODE_80D0DD:
  STZ.W $1F30                               ; $80D0DD |
  RTL                                       ; $80D0E0 |

  JSL.L CODE_FL_80B067                      ; $80D0E1 |
  STZ.B $A4                                 ; $80D0E5 |
  JML.L CODE_FL_80C213                      ; $80D0E7 |

CODE_FL_80D0EB:
  LDA.W $1F30                               ; $80D0EB |
  BNE CODE_80D12F                           ; $80D0EE |
  JSL.L CODE_FL_808302                      ; $80D0F0 |
  LDA.W #$1090                              ; $80D0F4 |
  STA.W $1968                               ; $80D0F7 |
  JSL.L CODE_FL_808BC2                      ; $80D0FA |
  JSL.L CODE_FL_80C1ED                      ; $80D0FE |
  JSL.L CODE_FL_808D45                      ; $80D102 |
  JSL.L CODE_FL_80977D                      ; $80D106 |
  STZ.W $0400                               ; $80D10A |
  STZ.W $04C0                               ; $80D10D |
  LDY.W #$B6B6                              ; $80D110 |
  JSL.L CODE_FL_80C27C                      ; $80D113 |
  JSL.L CODE_FL_80D55E                      ; $80D117 |
  LDA.W #$0002                              ; $80D11B |
  STA.B $5C                                 ; $80D11E |
  JSL.L CODE_FL_859007                      ; $80D120 |
  STZ.W $199E                               ; $80D124 |
  JSL.L CODE_FL_808315                      ; $80D127 |
  JML.L CODE_FL_80C873                      ; $80D12B |


CODE_80D12F:
  RTL                                       ; $80D12F |

CODE_FL_80D130:
  LDA.B !r_room_mode                        ; $80D130 |
  STA.L $7008E4                             ; $80D132 |
  JSL.L CODE_FL_84A1D8                      ; $80D136 |

  JSL.L CODE_FL_84A1ED                      ; $80D13A |
  JSL.L CODE_FL_80D53F                      ; $80D13E |
  JSL.L CODE_FL_80D4C9                      ; $80D142 |
  JSL.L CODE_FL_808302                      ; $80D146 |

  STZ.B $E4                                 ; $80D14A |

  LDA.W #$7FFF                              ; $80D14C |
  STA.W $1C6C                               ; $80D14F |
  JSL.L CODE_FL_80D571                      ; $80D152 |
  JSL.L CODE_FL_8584E1                      ; $80D156 |

CODE_80D15A:
  JSL.L CODE_FL_80D7A5                      ; $80D15A |
  JSL.L CODE_FL_809570                      ; $80D15E |
  JSL.L CODE_FL_92FFD7                      ; $80D162 |
  JSL.L CODE_FL_85859C                      ; $80D166 |
  LDA.W $1754                               ; $80D16A |
  BNE CODE_80D15A                           ; $80D16D |
  JSL.L CODE_FL_80B04D                      ; $80D16F |
  JSR.W CODE_FN_80D1AC                      ; $80D173 |

  JSL.L CODE_FL_84A1E6                      ; $80D176 |
  STZ.W $199A                               ; $80D17A |
  LDA.W #$FFFF                              ; $80D17D |
  STA.W $197C                               ; $80D180 |
  JSL.L CODE_FL_838051                      ; $80D183 |
  INC.B $7E                                 ; $80D187 |
  STZ.W $1FAA                               ; $80D189 |
  JSL.L CODE_FL_80C222                      ; $80D18C |
  JSL.L CODE_FL_80C239                      ; $80D190 |
  JSL.L CODE_FL_A0F9E7                      ; $80D194 |
  JSL.L CODE_FL_A0FA43                      ; $80D198 |
  JSL.L CODE_FL_83B27C                      ; $80D19C |
  STZ.B $84                                 ; $80D1A0 |
  STZ.W $199C                               ; $80D1A2 |
  STZ.W $1976                               ; $80D1A5 |
  JML.L CODE_FL_808315                      ; $80D1A8 |


CODE_FN_80D1AC:
  INC.B $A4                                 ; $80D1AC |
  LDA.W #$0004                              ; $80D1AE |
  STA.W $16B2                               ; $80D1B1 |
  STZ.W $16A2                               ; $80D1B4 |
  LDY.B !r_room_id                          ; $80D1B7 |
  LDA.W DATA8_81AA74,Y                      ; $80D1B9 |
  AND.W #$00FF                              ; $80D1BC |
  STA.B $92                                 ; $80D1BF |
  STZ.W $1960                               ; $80D1C1 |
  STZ.W $1962                               ; $80D1C4 |
  STZ.W $1966                               ; $80D1C7 |
  STZ.W $1964                               ; $80D1CA |
  RTS                                       ; $80D1CD |

  INC.B $A4                                 ; $80D1CE |
  JSL.L CODE_FL_80B04D                      ; $80D1D0 |
  JML.L CODE_FL_80C222                      ; $80D1D4 |

  STZ.W $0426                               ; $80D1D8 |
  STZ.W $0428                               ; $80D1DB |
  STZ.W $042A                               ; $80D1DE |
  STZ.W $04E6                               ; $80D1E1 |
  STZ.W $04E8                               ; $80D1E4 |
  STZ.W $04EA                               ; $80D1E7 |
  BRA CODE_80D22A                           ; $80D1EA |

CODE_FL_80D1EC:
  LDA.W #$FFFF                              ; $80D1EC |
  STA.B $C0                                 ; $80D1EF |

CODE_JL_80D1F1:
  LDA.W $1F60                               ; $80D1F1 |
  BNE CODE_80D1FB                           ; $80D1F4 |
  LDA.W #$2C00                              ; $80D1F6 |
  STA.B $4A                                 ; $80D1F9 |

CODE_80D1FB:
  JSR.W CODE_FN_80CF91                      ; $80D1FB |
  LDA.B $78                                 ; $80D1FE |
  BEQ CODE_80D21E                           ; $80D200 |
  AND.W #$00FF                              ; $80D202 |
  CMP.W #$0001                              ; $80D205 |
  BNE CODE_80D20D                           ; $80D208 |
  JMP.W CODE_JP_80CF90                      ; $80D20A |


CODE_80D20D:
  CMP.W #$0002                              ; $80D20D |
  BNE CODE_80D216                           ; $80D210 |
  JML.L CODE_JL_8DED7A                      ; $80D212 |


CODE_80D216:
  JSL.L CODE_FL_849A82                      ; $80D216 |
  JML.L CODE_FL_848655                      ; $80D21A |


CODE_80D21E:
  STZ.B $A2                                 ; $80D21E |
  STZ.B $76                                 ; $80D220 |
  JSL.L CODE_FL_8380F8                      ; $80D222 |
  JSL.L CODE_FL_83B413                      ; $80D226 |

CODE_80D22A:
  JSL.L CODE_FL_8590A4                      ; $80D22A |
  JSL.L CODE_FL_8CA04E                      ; $80D22E |
  JSL.L CODE_FL_89FE00                      ; $80D232 |
  JSL.L CODE_FL_80DF1A                      ; $80D236 |
  JSL.L CODE_FL_80CF06                      ; $80D23A |
  JSL.L CODE_FL_92FFD7                      ; $80D23E |

  JSL.L CODE_FL_859133                      ; $80D242 |
  JSL.L CODE_FL_85859C                      ; $80D246 |
  JSL.L CODE_FL_84A2E9                      ; $80D24A |
  LDA.B $7E                                 ; $80D24E |
  CMP.W #$0003                              ; $80D250 |
  BNE CODE_80D262                           ; $80D253 |
  LDA.B $3A                                 ; $80D255 |
  CMP.W #$0009                              ; $80D257 |
  BNE CODE_80D262                           ; $80D25A |
  LDA.B $B2                                 ; $80D25C |
  CMP.B !r_room_id                          ; $80D25E |
  BEQ CODE_80D281                           ; $80D260 |

CODE_80D262:
  JSL.L CODE_FL_83D496                      ; $80D262 |
  LDA.B $7E                                 ; $80D266 |
  CMP.W #$0008                              ; $80D268 |
  BEQ CODE_80D281                           ; $80D26B |
  LDA.B !r_room_id                          ; $80D26D |
  CMP.W #$0140                              ; $80D26F |
  BCS CODE_80D281                           ; $80D272 |
  CMP.W #$0131                              ; $80D274 |
  BEQ CODE_80D281                           ; $80D277 |
  CMP.W #$0027                              ; $80D279 |
  BEQ CODE_80D281                           ; $80D27C |
  STZ.W $19CC                               ; $80D27E |

CODE_80D281:
  RTL                                       ; $80D281 |

  RTL                                       ; $80D282 |

CODE_FL_80D283:
  JSL.L CODE_FL_80D306                      ; $80D283 |
  STZ.W $19CC                               ; $80D287 |
  RTL                                       ; $80D28A |

CODE_FL_80D28B:
  LDA.W $19CC                               ; $80D28B |
  BEQ CODE_FL_80D296                        ; $80D28E |
  JSL.L CODE_FL_92FD40                      ; $80D290 |
  BCS CODE_80D29A                           ; $80D294 |

CODE_FL_80D296:
  JML.L CODE_JL_80CDCD                      ; $80D296 |


CODE_80D29A:
  RTL                                       ; $80D29A |

CODE_FL_80D29B:
  JML.L CODE_JL_80CDF3                      ; $80D29B |

CODE_FL_80D29F:
  LDA.W #$FFFF                              ; $80D29F |
  STA.W $197C                               ; $80D2A2 |
  JSL.L CODE_FL_80CE2C                      ; $80D2A5 |

  JSL.L CODE_FL_A0FA43                      ; $80D2A9 |
  JML.L CODE_FL_808315                      ; $80D2AD |

CODE_FL_80D2B1:
  JSL.L CODE_FL_80CE2C                      ; $80D2B1 |
  JSL.L CODE_FL_A0FA43                      ; $80D2B5 |
  JML.L CODE_FL_808315                      ; $80D2B9 |

CODE_FL_80D2BD:
  JML.L CODE_FL_80CE75                      ; $80D2BD |

CODE_FL_80D2C1:
  JSL.L CODE_FL_80CE75                      ; $80D2C1 |
  LDA.W #$000C                              ; $80D2C5 |
  JML.L CODE_FL_80C876                      ; $80D2C8 |

CODE_FL_80D2CC:
  LDA.W $1F30                               ; $80D2CC |

  BNE CODE_80D2EE                           ; $80D2CF |

  LDA.B !r_room_id                          ; $80D2D1 |
  CMP.W #$0126                              ; $80D2D3 |
  BEQ CODE_80D2DD                           ; $80D2D6 |
  LDA.W #$00FD                              ; $80D2D8 |

  BRA CODE_80D2E0                           ; $80D2DB |


CODE_80D2DD:
  LDA.W #$00FF                              ; $80D2DD |

CODE_80D2E0:
  STA.B !r_room_id                          ; $80D2E0 |
  LDA.W #$0005                              ; $80D2E2 |

  STA.B !r_room_mode                        ; $80D2E5 |
  LDA.W #$0000                              ; $80D2E7 |
  JML.L CODE_FL_80C876                      ; $80D2EA |


CODE_80D2EE:
  RTL                                       ; $80D2EE |

  RTL                                       ; $80D2EF |

CODE_FL_80D2F0:
  LDA.W $1F30                               ; $80D2F0 |
  BNE CODE_80D2EE                           ; $80D2F3 |
  LDA.W #$0002                              ; $80D2F5 |
  STA.B !r_room_mode                        ; $80D2F8 |
  LDA.W #$8001                              ; $80D2FA |
  STA.B $DA                                 ; $80D2FD |

  LDA.W #$0000                              ; $80D2FF |
  JML.L CODE_FL_80C876                      ; $80D302 |


CODE_FL_80D306:
  JML.L CODE_JL_80D1F1                      ; $80D306 |


CODE_FL_80D30A:
  INC.W $1C8E                               ; $80D30A |
  JSL.L CODE_FL_8DD161                      ; $80D30D |
  JSL.L CODE_FL_80D31B                      ; $80D311 |
  LDA.W $1CB4                               ; $80D315 |
  STA.B $E4                                 ; $80D318 |
  RTL                                       ; $80D31A |


CODE_FL_80D31B:
  LDA.B $7E                                 ; $80D31B |
  ASL A                                     ; $80D31D |
  TAX                                       ; $80D31E |

  LDA.W PTR16_818F0C,X                      ; $80D31F |
  PHA                                       ; $80D322 |
  RTS                                       ; $80D323 |

CODE_FL_80D324:
  INC.B $7E                                 ; $80D324 |
  STZ.W $1756                               ; $80D326 |
  STZ.W $1758                               ; $80D329 |
  STZ.W $1CAE                               ; $80D32C |
  STZ.B $A4                                 ; $80D32F |
  JSL.L CODE_FL_80C1ED                      ; $80D331 |
  JSL.L CODE_FL_808D45                      ; $80D335 |
  JSL.L CODE_FL_808D75                      ; $80D339 |
  JSL.L CODE_FL_80977D                      ; $80D33D |
  SEP #$20                                  ; $80D341 |
  LDA.B #$22                                ; $80D343 |
  STA.W !reg_bg12nba                        ; $80D345 |
  REP #$20                                  ; $80D348 |
  JSL.L CODE_FL_80D50D                      ; $80D34A |
  JSL.L CODE_FL_808CB3                      ; $80D34E |
  JML.L CODE_FL_85858F                      ; $80D352 |

  RTL                                       ; $80D356 |

CODE_FL_80D357:
  INC.B $7E                                 ; $80D357 |
  JSL.L CODE_FL_808302                      ; $80D359 |
  LDA.W #$0001                              ; $80D35D |
  STA.W $197A                               ; $80D360 |
  INC.W $1932                               ; $80D363 |
  JSL.L CODE_FL_84A1D8                      ; $80D366 |
  LDX.W #asset_88CDCA                       ; $80D36A |
  JSL.L load_asset                          ; $80D36D |
  LDA.B !r_room_id                          ; $80D371 |
  CMP.W #$00FF                              ; $80D373 |
  BNE CODE_80D38A                           ; $80D376 |
  LDX.W #$047A                              ; $80D378 |

CODE_80D37B:
  LDA.L $7E6000,X                           ; $80D37B |
  ORA.W #$0100                              ; $80D37F |
  STA.L $7E6000,X                           ; $80D382 |
  DEX                                       ; $80D386 |
  DEX                                       ; $80D387 |
  BPL CODE_80D37B                           ; $80D388 |

CODE_80D38A:
  LDA.W #$0001                              ; $80D38A |
  STA.B $5C                                 ; $80D38D |
  STZ.W $0400                               ; $80D38F |
  STZ.W $04C0                               ; $80D392 |
  STZ.W $042E                               ; $80D395 |
  STZ.W $04EE                               ; $80D398 |
  JSL.L CODE_FL_859007                      ; $80D39B |
  JSL.L CODE_FL_A0F9E7                      ; $80D39F |
  JSL.L CODE_FL_A0FA43                      ; $80D3A3 |
  JSL.L CODE_FL_808315                      ; $80D3A7 |
  JSL.L CODE_FL_84A1ED                      ; $80D3AB |
  LDY.W #$B6B6                              ; $80D3AF |
  LDX.W #$1F30                              ; $80D3B2 |
  JSL.L CODE_FL_80C27C                      ; $80D3B5 |
  JML.L CODE_FL_80D55E                      ; $80D3B9 |

CODE_FL_80D3BD:
  STZ.W $1CB2                               ; $80D3BD |
  JSL.L CODE_FL_8B80CE                      ; $80D3C0 |
  STZ.B $E4                                 ; $80D3C4 |
  STZ.W $1CB4                               ; $80D3C6 |
  STZ.B $76                                 ; $80D3C9 |
  STZ.B $78                                 ; $80D3CB |
  INC.B $7E                                 ; $80D3CD |
  LDA.B !r_room_id                          ; $80D3CF |
  CMP.W #$00FF                              ; $80D3D1 |
  BEQ CODE_80D3DF                           ; $80D3D4 |
  LDX.W #asset_88CDD6                       ; $80D3D6 |
  JSL.L load_asset                          ; $80D3D9 |
  BRA CODE_80D41F                           ; $80D3DD |


CODE_80D3DF:
  LDX.W #asset_88CEB8                       ; $80D3DF |
  JSL.L load_asset                          ; $80D3E2 |
  JSL.L CODE_FL_808302                      ; $80D3E6 |
  LDX.W #asset_88CECF                       ; $80D3EA |
  JSL.L load_asset                          ; $80D3ED |
  JSL.L CODE_FL_808302                      ; $80D3F1 |
  LDX.W #$1FFE                              ; $80D3F5 |

CODE_80D3F8:
  LDA.L $7F0000,X                           ; $80D3F8 |
  ORA.W #$2000                              ; $80D3FC |
  STA.L $7F0000,X                           ; $80D3FF |
  DEX                                       ; $80D403 |
  DEX                                       ; $80D404 |
  BPL CODE_80D3F8                           ; $80D405 |
  PHX                                       ; $80D407 |
  LDX.W #$2000                              ; $80D408 |
  LDA.W #$007F                              ; $80D40B |
  STA.B $00                                 ; $80D40E |
  LDA.W #$0000                              ; $80D410 |
  LDY.W #$1000                              ; $80D413 |
  JSL.L CODE_FL_809671                      ; $80D416 |
  PLX                                       ; $80D41A |
  JSL.L CODE_FL_8095B5                      ; $80D41B |

CODE_80D41F:
  JSL.L CODE_FL_808315                      ; $80D41F |
  STZ.W $1960                               ; $80D423 |
  STZ.W $1962                               ; $80D426 |
  LDY.W #$0400                              ; $80D429 |
  LDA.W $0418                               ; $80D42C |
  BNE CODE_80D434                           ; $80D42F |
  LDY.W #$04C0                              ; $80D431 |

CODE_80D434:
  STY.B $E0                                 ; $80D434 |
  STZ.W $1CA4                               ; $80D436 |
  JSL.L CODE_FL_86830F                      ; $80D439 |
  JSL.L CODE_FL_8380F8                      ; $80D43D |
  JSL.L CODE_FL_869128                      ; $80D441 |

  BRA CODE_80D453                           ; $80D445 |


CODE_FL_80D447:
  JSL.L CODE_FL_868113                      ; $80D447 |
  JSL.L CODE_FL_8380F8                      ; $80D44B |
  JSL.L CODE_FL_869128                      ; $80D44F |

CODE_80D453:
  JSL.L CODE_FL_80D9D3                      ; $80D453 |

  JSL.L CODE_FL_8590A4                      ; $80D457 |
  JSL.L CODE_FL_92FFD7                      ; $80D45B |
  JSL.L CODE_FL_859133                      ; $80D45F |

  JSL.L CODE_FL_85859C                      ; $80D463 |
  LDX.B $E0                                 ; $80D467 |
  STX.B $94                                 ; $80D469 |
  JSL.L CODE_FL_83DB41                      ; $80D46B |
  JSL.L CODE_FL_84A2E9                      ; $80D46F |
  RTL                                       ; $80D473 |

CODE_FL_80D474:
  LDA.W $1F30                               ; $80D474 |
  BEQ CODE_80D47C                           ; $80D477 |
  JMP.W CODE_FL_80D447                      ; $80D479 |


CODE_80D47C:
  LDA.W #$000B                              ; $80D47C |
  JML.L CODE_FL_8085F6                      ; $80D47F |

CODE_FL_80D483:
  LDA.W $1F30                               ; $80D483 |
  BEQ CODE_80D48B                           ; $80D486 |
  JMP.W CODE_FL_80D447                      ; $80D488 |


CODE_80D48B:
  STZ.W $1CB4                               ; $80D48B |
  STZ.B $E4                                 ; $80D48E |
  LDA.W #$8001                              ; $80D490 |
  STA.B $DA                                 ; $80D493 |
  SEC                                       ; $80D495 |
  LDA.B !r_room_id                          ; $80D496 |
  SBC.W #$00FC                              ; $80D498 |
  PHX                                       ; $80D49B |
  ASL A                                     ; $80D49C |
  TAX                                       ; $80D49D |
  LDA.L PTR16_80D4A8,X                      ; $80D49E |
  PLX                                       ; $80D4A2 |
  STA.B $00                                 ; $80D4A3 |
  JMP.W ($0000)                             ; $80D4A5 |

PTR16_80D4A8:
  dw CODE_80D4B0                            ; $80D4A8 |
  dw CODE_80D4B4                            ; $80D4AA |
  dw CODE_80D4B8                            ; $80D4AC |
  dw CODE_80D4BC                            ; $80D4AE |

CODE_80D4B0:
  JML.L CODE_JL_848329                      ; $80D4B0 |


CODE_80D4B4:
  JML.L CODE_JL_84833E                      ; $80D4B4 |


CODE_80D4B8:
  JML.L CODE_JL_848343                      ; $80D4B8 |


CODE_80D4BC:
  JML.L CODE_JL_84834D                      ; $80D4BC |

  RTL                                       ; $80D4C0 |

  JSL.L CODE_FL_80D553                      ; $80D4C1 |
  JSL.L CODE_FL_80D50D                      ; $80D4C5 |

CODE_FL_80D4C9:
  JSL.L CODE_FL_80D52D                      ; $80D4C9 |
  LDA.W #$0040                              ; $80D4CD |
  STA.W $1754                               ; $80D4D0 |

  RTL                                       ; $80D4D3 |

  LDA.B !r_room_id                          ; $80D4D4 |
  SEC                                       ; $80D4D6 |
  SBC.W #$0030                              ; $80D4D7 |
  ASL A                                     ; $80D4DA |

  TAY                                       ; $80D4DB |
  PHB                                       ; $80D4DC |

  PEA.W $8484                               ; $80D4DD |
  PLB                                       ; $80D4E0 |

  PLB                                       ; $80D4E1 |
  LDA.W PTR16_848EC9,Y                      ; $80D4E2 |
  BMI CODE_80D4ED                           ; $80D4E5 |
  ORA.W #$8000                              ; $80D4E7 |
  INC.W $19BC                               ; $80D4EA |

CODE_80D4ED:
  TAX                                       ; $80D4ED |
  PLB                                       ; $80D4EE |
  JSL.L load_asset                          ; $80D4EF |
  LDA.B !r_room_id                          ; $80D4F3 |
  SEC                                       ; $80D4F5 |
  SBC.W #$0030                              ; $80D4F6 |
  ASL A                                     ; $80D4F9 |
  TAY                                       ; $80D4FA |
  PHB                                       ; $80D4FB |
  PEA.W $8484                               ; $80D4FC |
  PLB                                       ; $80D4FF |
  PLB                                       ; $80D500 |
  LDA.W PTR16_8491D3,Y                      ; $80D501 |
  ORA.W #$8000                              ; $80D504 |
  TAX                                       ; $80D507 |
  PLB                                       ; $80D508 |
  JML.L load_asset                          ; $80D509 |


CODE_FL_80D50D:
  JSL.L CODE_FL_808921                      ; $80D50D |
  LDX.B !r_room_id                          ; $80D511 |
  LDA.W DATA8_81B517,X                      ; $80D513 |
  AND.W #$00FF                              ; $80D516 |
  STA.B $E8                                 ; $80D519 |
  JSR.W CODE_FN_80D56C                      ; $80D51B |
  PHB                                       ; $80D51E |
  PEA.W $8484                               ; $80D51F |
  PLB                                       ; $80D522 |
  PLB                                       ; $80D523 |
  LDA.W PTR16_8494DD,X                      ; $80D524 |
  TAX                                       ; $80D527 |
  PLB                                       ; $80D528 |
  JML.L CODE_FL_84BB14                      ; $80D529 |


CODE_FL_80D52D:
  JSR.W CODE_FN_80D56C                      ; $80D52D |
  PHB                                       ; $80D530 |
  PEA.W $8484                               ; $80D531 |
  PLB                                       ; $80D534 |
  PLB                                       ; $80D535 |
  LDA.W PTR16_848BBF,X                      ; $80D536 |
  TAX                                       ; $80D539 |
  PLB                                       ; $80D53A |
  JML.L load_asset                          ; $80D53B |


CODE_FL_80D53F:
  JSR.W CODE_FN_80D56C                      ; $80D53F |
  LDY.W LOOSE_OP_00B20D,X                   ; $80D542 |
  JSL.L CODE_FL_808D78                      ; $80D545 |
  LDA.W #$00FF                              ; $80D549 |
  STA.W $1FF8                               ; $80D54C |
  STA.W $1FF8                               ; $80D54F |
  RTL                                       ; $80D552 |


CODE_FL_80D553:
  JSR.W CODE_FN_80D56C                      ; $80D553 |
  LDA.W PTR16_818F1A,X                      ; $80D556 |
  TAY                                       ; $80D559 |
  JML.L CODE_FL_80C27C                      ; $80D55A |


CODE_FL_80D55E:
  JSR.W CODE_FN_80D56C                      ; $80D55E |
  LDA.W PTR16_818F1A,X                      ; $80D561 |
  TAY                                       ; $80D564 |
  LDX.W #$1F40                              ; $80D565 |
  JML.L CODE_FL_80C27F                      ; $80D568 |


CODE_FN_80D56C:
  LDA.B !r_room_id                          ; $80D56C |
  ASL A                                     ; $80D56E |
  TAX                                       ; $80D56F |
  RTS                                       ; $80D570 |


CODE_FL_80D571:
  LDA.W #$0040                              ; $80D571 |
  STA.W $1754                               ; $80D574 |
  LDA.W #$1660                              ; $80D577 |
  TCD                                       ; $80D57A |
  LDA.W !r_room_id                          ; $80D57B |
  ASL A                                     ; $80D57E |
  ASL A                                     ; $80D57F |
  TAY                                       ; $80D580 |
  LDA.W DATA8_81ABF8,Y                      ; $80D581 |
  AND.W #$FF00                              ; $80D584 |
  STA.W $1762                               ; $80D587 |
  LDA.W DATA8_81ABF8+1,Y                    ; $80D58A |
  AND.W #$FF00                              ; $80D58D |
  STA.W $1764                               ; $80D590 |
  LDA.W DATA8_81ABF8+4,Y                    ; $80D593 |
  AND.W #$00FF                              ; $80D596 |
  STA.W $1760                               ; $80D599 |
  LDA.L $7F4800                             ; $80D59C |
  AND.W #$00FF                              ; $80D5A0 |
  STA.W $1766                               ; $80D5A3 |
  LDA.L $7F4801                             ; $80D5A6 |
  AND.W #$00FF                              ; $80D5AA |
  STA.W $1768                               ; $80D5AD |
  LDA.L $7F4802                             ; $80D5B0 |
  AND.W #$00FF                              ; $80D5B4 |
  STA.W $176A                               ; $80D5B7 |
  JSR.W CODE_FN_80DEC5                      ; $80D5BA |
  SEP #$20                                  ; $80D5BD |
  LDA.B #$FF                                ; $80D5BF |
  STA.B $82                                 ; $80D5C1 |
  STA.B $83                                 ; $80D5C3 |
  STA.B $D0                                 ; $80D5C5 |
  STA.B $D1                                 ; $80D5C7 |
  STZ.B $98                                 ; $80D5C9 |
  STZ.B $E6                                 ; $80D5CB |
  STZ.B $84                                 ; $80D5CD |
  STZ.B $85                                 ; $80D5CF |
  STZ.B $D2                                 ; $80D5D1 |
  STZ.B $D3                                 ; $80D5D3 |
  STZ.B $E8                                 ; $80D5D5 |
  STZ.B $EA                                 ; $80D5D7 |
  REP #$20                                  ; $80D5D9 |
  LDA.W DATA16_81A460,X                     ; $80D5DB |
  STA.B $F2                                 ; $80D5DE |
  AND.W #$FF00                              ; $80D5E0 |
  BEQ CODE_80D5ED                           ; $80D5E3 |
  LDA.W CODE_00A76A,X                       ; $80D5E5 |
  STA.B $F0                                 ; $80D5E8 |
  JMP.W CODE_JP_80D7A0                      ; $80D5EA |


CODE_80D5ED:
  LDY.W CODE_00A76A,X                       ; $80D5ED |
  LDA.W CODE_00D14A,Y                       ; $80D5F0 |
  STA.B $A0                                 ; $80D5F3 |
  LDA.W CODE_00D14C,Y                       ; $80D5F5 |
  STA.B $A2                                 ; $80D5F8 |
  LDA.W LOOSE_OP_00D14E,Y                   ; $80D5FA |
  STA.B $A4                                 ; $80D5FD |
  LDA.W LOOSE_OP_00D150,Y                   ; $80D5FF |
  STA.B $A6                                 ; $80D602 |
  STZ.B $B0                                 ; $80D604 |
  STZ.B $B2                                 ; $80D606 |
  STZ.B $B4                                 ; $80D608 |
  STZ.B $B6                                 ; $80D60A |
  LDY.W #$0000                              ; $80D60C |

CODE_80D60F:
  LDA.B $A0                                 ; $80D60F |
  CLC                                       ; $80D611 |
  ADC.B $B0                                 ; $80D612 |
  STA.B $B0                                 ; $80D614 |
  STA.W $17E0,Y                             ; $80D616 |
  INY                                       ; $80D619 |
  INY                                       ; $80D61A |
  CPY.W #$0010                              ; $80D61B |
  BCC CODE_80D60F                           ; $80D61E |
  LDY.W #$0000                              ; $80D620 |

CODE_80D623:
  LDA.B $A2                                 ; $80D623 |
  CLC                                       ; $80D625 |
  ADC.B $B2                                 ; $80D626 |
  STA.B $B2                                 ; $80D628 |
  EOR.W #$FFFF                              ; $80D62A |
  INC A                                     ; $80D62D |
  STA.W $17F0,Y                             ; $80D62E |
  INY                                       ; $80D631 |
  INY                                       ; $80D632 |
  CPY.W #$0010                              ; $80D633 |
  BCC CODE_80D623                           ; $80D636 |
  LDY.W #$0000                              ; $80D638 |

CODE_80D63B:
  LDA.B $A4                                 ; $80D63B |
  CLC                                       ; $80D63D |
  ADC.B $B4                                 ; $80D63E |
  STA.B $B4                                 ; $80D640 |
  STA.W $1800,Y                             ; $80D642 |
  INY                                       ; $80D645 |
  INY                                       ; $80D646 |
  CPY.W #$0010                              ; $80D647 |
  BCC CODE_80D63B                           ; $80D64A |
  LDY.W #$0000                              ; $80D64C |

CODE_80D64F:
  LDA.B $A6                                 ; $80D64F |
  CLC                                       ; $80D651 |
  ADC.B $B6                                 ; $80D652 |
  STA.B $B6                                 ; $80D654 |
  EOR.W #$FFFF                              ; $80D656 |
  INC A                                     ; $80D659 |
  STA.W $1810,Y                             ; $80D65A |
  INY                                       ; $80D65D |
  INY                                       ; $80D65E |
  CPY.W #$0010                              ; $80D65F |
  BCC CODE_80D64F                           ; $80D662 |
  TXA                                       ; $80D664 |
  ASL A                                     ; $80D665 |
  TAX                                       ; $80D666 |
  LDA.W DATA8_819838,X                      ; $80D667 |
  AND.W #$00FF                              ; $80D66A |
  STA.B $86                                 ; $80D66D |
  SEP #$20                                  ; $80D66F |
  DEC A                                     ; $80D671 |
  DEC A                                     ; $80D672 |
  STA.W $00AF                               ; $80D673 |
  STZ.W $00AE                               ; $80D676 |
  REP #$20                                  ; $80D679 |
  LDA.W DATA8_819838+1,X                    ; $80D67B |
  AND.W #$00FF                              ; $80D67E |
  STA.B $88                                 ; $80D681 |
  SEP #$20                                  ; $80D683 |
  DEC A                                     ; $80D685 |
  STA.W $00B1                               ; $80D686 |
  STZ.W $00B0                               ; $80D689 |
  REP #$20                                  ; $80D68C |
  LDA.W DATA8_819838+2,X                    ; $80D68E |
  AND.W #$00FF                              ; $80D691 |
  STA.B $D4                                 ; $80D694 |
  LDA.W DATA8_819838+3,X                    ; $80D696 |
  AND.W #$00FF                              ; $80D699 |
  STA.B $D6                                 ; $80D69C |
  LDA.W DATA8_819E4C,X                      ; $80D69E |
  AND.W #$00FF                              ; $80D6A1 |
  TAY                                       ; $80D6A4 |
  LDA.W DATA8_81D13A,Y                      ; $80D6A5 |
  STA.B $06                                 ; $80D6A8 |
  LDA.W DATA8_819224-1,X                    ; $80D6AA |
  BIT.W #$8000                              ; $80D6AD |
  BEQ CODE_80D6C5                           ; $80D6B0 |
  LDA.B $F6                                 ; $80D6B2 |
  BNE CODE_80D6C2                           ; $80D6B4 |
  LDA.W DATA8_819224-1,X                    ; $80D6B6 |
  AND.W #$7F00                              ; $80D6B9 |
  SEC                                       ; $80D6BC |
  SBC.W #$0100                              ; $80D6BD |
  STA.B $F6                                 ; $80D6C0 |

CODE_80D6C2:
  LDA.W #$0100                              ; $80D6C2 |

CODE_80D6C5:
  AND.W #$FF00                              ; $80D6C5 |
  STA.W $19A6                               ; $80D6C8 |
  CLC                                       ; $80D6CB |
  ADC.B $F6                                 ; $80D6CC |
  CLC                                       ; $80D6CE |
  AND.W #$7FFF                              ; $80D6CF |
  ADC.W DATA8_81D13A+2,Y                    ; $80D6D2 |
  STA.B $02                                 ; $80D6D5 |
  LDA.W DATA8_819E4C+1,X                    ; $80D6D7 |
  AND.W #$00FF                              ; $80D6DA |
  TAY                                       ; $80D6DD |
  LDA.W DATA8_81D13A,Y                      ; $80D6DE |
  STA.B $16                                 ; $80D6E1 |
  LDA.W DATA8_819224,X                      ; $80D6E3 |
  BIT.W #$8000                              ; $80D6E6 |
  BEQ CODE_80D6FE                           ; $80D6E9 |
  LDA.B $F8                                 ; $80D6EB |
  BNE CODE_80D6FB                           ; $80D6ED |
  LDA.W DATA8_819224,X                      ; $80D6EF |
  AND.W #$7F00                              ; $80D6F2 |
  SEC                                       ; $80D6F5 |
  SBC.W #$0100                              ; $80D6F6 |
  STA.B $F8                                 ; $80D6F9 |

CODE_80D6FB:
  LDA.W #$0100                              ; $80D6FB |

CODE_80D6FE:
  AND.W #$FF00                              ; $80D6FE |
  STA.W $19A8                               ; $80D701 |
  CLC                                       ; $80D704 |
  ADC.B $F8                                 ; $80D705 |
  CLC                                       ; $80D707 |
  AND.W #$7FFF                              ; $80D708 |
  ADC.W DATA8_81D13A+2,Y                    ; $80D70B |
  STA.B $12                                 ; $80D70E |
  LDA.B $F6                                 ; $80D710 |
  AND.W #$7FFF                              ; $80D712 |
  STA.B $A4                                 ; $80D715 |
  PHY                                       ; $80D717 |
  LDA.W !r_room_id                          ; $80D718 |
  ASL A                                     ; $80D71B |
  TAY                                       ; $80D71C |
  LDA.W DATA16_81A460,Y                     ; $80D71D |
  BIT.W #$0003                              ; $80D720 |
  BEQ CODE_80D730                           ; $80D723 |
  PLY                                       ; $80D725 |
  LDY.W $17E0                               ; $80D726 |
  JSR.W CODE_FN_80D7D8                      ; $80D729 |
  STA.B $C0                                 ; $80D72C |
  BRA CODE_80D736                           ; $80D72E |


CODE_80D730:
  PLY                                       ; $80D730 |
  LDA.W #$0000                              ; $80D731 |
  STA.B $C0                                 ; $80D734 |

CODE_80D736:
  LDA.B $F8                                 ; $80D736 |
  AND.W #$7FFF                              ; $80D738 |
  STA.B $A4                                 ; $80D73B |
  PHY                                       ; $80D73D |
  LDA.W !r_room_id                          ; $80D73E |
  ASL A                                     ; $80D741 |
  TAY                                       ; $80D742 |
  LDA.W DATA16_81A460,Y                     ; $80D743 |
  BIT.W #$000C                              ; $80D746 |
  BEQ CODE_80D756                           ; $80D749 |
  PLY                                       ; $80D74B |
  LDY.W $1800                               ; $80D74C |
  JSR.W CODE_FN_80D7D8                      ; $80D74F |
  STA.B $C2                                 ; $80D752 |
  BRA CODE_80D75C                           ; $80D754 |


CODE_80D756:
  PLY                                       ; $80D756 |
  LDA.W #$0000                              ; $80D757 |
  STA.B $C2                                 ; $80D75A |

CODE_80D75C:
  LDA.W DATA8_819E4C+2,X                    ; $80D75C |
  AND.W #$00FF                              ; $80D75F |
  TAY                                       ; $80D762 |
  LDA.W DATA8_81D13A,Y                      ; $80D763 |
  STA.B $26                                 ; $80D766 |
  LDA.W DATA8_819224+1,X                    ; $80D768 |
  AND.W #$FF00                              ; $80D76B |
  CLC                                       ; $80D76E |
  ADC.B $C0                                 ; $80D76F |
  CLC                                       ; $80D771 |
  ADC.W DATA8_81D13A+2,Y                    ; $80D772 |
  STA.B $22                                 ; $80D775 |
  LDA.W DATA8_819E4C+3,X                    ; $80D777 |
  AND.W #$00FF                              ; $80D77A |
  TAY                                       ; $80D77D |
  LDA.W DATA8_81D13A,Y                      ; $80D77E |
  STA.B $36                                 ; $80D781 |
  LDA.W DATA8_819224+2,X                    ; $80D783 |
  AND.W #$FF00                              ; $80D786 |
  CLC                                       ; $80D789 |
  ADC.B $C2                                 ; $80D78A |
  CLC                                       ; $80D78C |
  ADC.W DATA8_81D13A+2,Y                    ; $80D78D |
  STA.B $32                                 ; $80D790 |
  LDA.L $7F7002                             ; $80D792 |
  STA.W $00F0                               ; $80D796 |
  LDA.L $7F7004                             ; $80D799 |
  STA.W $00F2                               ; $80D79D |

CODE_JP_80D7A0:
  LDA.W #$0000                              ; $80D7A0 |
  TCD                                       ; $80D7A3 |
  RTL                                       ; $80D7A4 |


CODE_FL_80D7A5:
  LDA.B $E8                                 ; $80D7A5 |
  BNE CODE_80D7AE                           ; $80D7A7 |
  JSR.W CODE_FN_80DC9D                      ; $80D7A9 |
  BRA CODE_80D7B1                           ; $80D7AC |


CODE_80D7AE:
  JSR.W CODE_FN_80E156                      ; $80D7AE |

CODE_80D7B1:
  JSL.L CODE_FL_80E5BF                      ; $80D7B1 |
  DEC.W $1754                               ; $80D7B5 |
  BNE CODE_80D7D7                           ; $80D7B8 |
  STZ.W $1666                               ; $80D7BA |
  STZ.W $1676                               ; $80D7BD |
  STZ.W $1686                               ; $80D7C0 |
  STZ.W $1696                               ; $80D7C3 |
  STZ.B $92                                 ; $80D7C6 |
  STZ.W $1960                               ; $80D7C8 |
  STZ.W $1962                               ; $80D7CB |

  STZ.W $1964                               ; $80D7CE |
  STZ.W $1966                               ; $80D7D1 |
  INC.W $16E0                               ; $80D7D4 |

CODE_80D7D7:
  RTL                                       ; $80D7D7 |


CODE_FN_80D7D8:
  SEP #$20                                  ; $80D7D8 |
  STY.B $A0                                 ; $80D7DA |
  LDA.B $A0                                 ; $80D7DC |
  STA.W !reg_wrmpya                         ; $80D7DE |
  LDA.B $A4                                 ; $80D7E1 |
  STA.W !reg_wrmpyb                         ; $80D7E3 |
  NOP                                       ; $80D7E6 |
  NOP                                       ; $80D7E7 |
  NOP                                       ; $80D7E8 |
  NOP                                       ; $80D7E9 |
  LDA.W !reg_rdmpyh                         ; $80D7EA |
  STA.B $B0                                 ; $80D7ED |
  STZ.B $B1                                 ; $80D7EF |
  LDA.B $A5                                 ; $80D7F1 |
  STA.W !reg_wrmpyb                         ; $80D7F3 |
  CLC                                       ; $80D7F6 |
  REP #$20                                  ; $80D7F7 |
  NOP                                       ; $80D7F9 |
  LDA.B $B0                                 ; $80D7FA |
  ADC.W !reg_rdmpyl                         ; $80D7FC |
  TAY                                       ; $80D7FF |
  SEP #$20                                  ; $80D800 |
  LDA.B $A1                                 ; $80D802 |
  STA.W !reg_wrmpya                         ; $80D804 |
  LDA.B $A4                                 ; $80D807 |
  STA.W !reg_wrmpyb                         ; $80D809 |
  NOP                                       ; $80D80C |
  CLC                                       ; $80D80D |
  REP #$20                                  ; $80D80E |
  TYA                                       ; $80D810 |
  ADC.W !reg_rdmpyl                         ; $80D811 |
  STA.B $B0                                 ; $80D814 |
  SEP #$20                                  ; $80D816 |
  LDA.B $A5                                 ; $80D818 |
  STA.W !reg_wrmpyb                         ; $80D81A |
  NOP                                       ; $80D81D |
  NOP                                       ; $80D81E |
  CLC                                       ; $80D81F |
  LDA.W !reg_rdmpyl                         ; $80D820 |
  ADC.B $B1                                 ; $80D823 |
  STA.B $B1                                 ; $80D825 |
  REP #$20                                  ; $80D827 |
  LDA.B $B0                                 ; $80D829 |
  RTS                                       ; $80D82B |

  JSR.W CODE_FN_80D866                      ; $80D82C |
  PHB                                       ; $80D82F |
  PEA.W $8484                               ; $80D830 |
  PLB                                       ; $80D833 |
  PLB                                       ; $80D834 |
  LDA.W PTR16_8494DD,X                      ; $80D835 |
  TAX                                       ; $80D838 |
  PLB                                       ; $80D839 |
  JSL.L CODE_FL_84BB14                      ; $80D83A |
  JSR.W CODE_FN_80D866                      ; $80D83E |
  PHB                                       ; $80D841 |
  PEA.W $8484                               ; $80D842 |
  PLB                                       ; $80D845 |
  PLB                                       ; $80D846 |
  LDA.W PTR16_848BBF,X                      ; $80D847 |
  TAX                                       ; $80D84A |
  PLB                                       ; $80D84B |
  JSL.L load_asset                          ; $80D84C |
  RTL                                       ; $80D850 |

  JSR.W CODE_FN_80D866                      ; $80D851 |
  LDA.W PTR16_818F1A,X                      ; $80D854 |
  TAY                                       ; $80D857 |
  JSL.L CODE_FL_80C27C                      ; $80D858 |
  LDA.W #$0040                              ; $80D85C |
  STA.W $1754                               ; $80D85F |

  STZ.W $16E0                               ; $80D862 |
  RTL                                       ; $80D865 |


CODE_FN_80D866:
  LDA.B $8E                                 ; $80D866 |
  ASL A                                     ; $80D868 |
  TAX                                       ; $80D869 |
  RTS                                       ; $80D86A |

  LDA.W $1754                               ; $80D86B |
  CMP.W #$0040                              ; $80D86E |
  BEQ CODE_80D876                           ; $80D871 |
  JMP.W CODE_JP_80D9B3                      ; $80D873 |


CODE_80D876:
  LDA.W #$1660                              ; $80D876 |
  TCD                                       ; $80D879 |
  JSR.W CODE_FN_80DEC5                      ; $80D87A |
  TXA                                       ; $80D87D |
  ASL A                                     ; $80D87E |
  TAX                                       ; $80D87F |
  LDA.W DATA8_819838,X                      ; $80D880 |
  AND.W #$00FF                              ; $80D883 |
  STA.B $86                                 ; $80D886 |
  LDA.W DATA8_819838+1,X                    ; $80D888 |
  AND.W #$00FF                              ; $80D88B |
  STA.B $88                                 ; $80D88E |
  LDA.W DATA8_819838+2,X                    ; $80D890 |
  AND.W #$00FF                              ; $80D893 |
  STA.B $D4                                 ; $80D896 |
  LDA.W DATA8_819838+3,X                    ; $80D898 |
  AND.W #$00FF                              ; $80D89B |
  STA.B $D6                                 ; $80D89E |
  STZ.B $42                                 ; $80D8A0 |
  STZ.B $52                                 ; $80D8A2 |
  LDA.W DATA8_819E4C,X                      ; $80D8A4 |
  AND.W #$00FF                              ; $80D8A7 |
  TAY                                       ; $80D8AA |
  LDA.W DATA8_81D13A,Y                      ; $80D8AB |
  STA.B $06                                 ; $80D8AE |
  LDA.W DATA8_819224-1,X                    ; $80D8B0 |
  AND.W #$FF00                              ; $80D8B3 |
  CLC                                       ; $80D8B6 |
  ADC.W DATA8_81D13A+2,Y                    ; $80D8B7 |
  STA.B $02                                 ; $80D8BA |
  LDA.W DATA8_819E4C+1,X                    ; $80D8BC |
  AND.W #$00FF                              ; $80D8BF |
  TAY                                       ; $80D8C2 |
  LDA.W DATA8_81D13A,Y                      ; $80D8C3 |
  STA.B $16                                 ; $80D8C6 |
  LDA.W DATA8_819224,X                      ; $80D8C8 |
  AND.W #$FF00                              ; $80D8CB |
  CLC                                       ; $80D8CE |
  ADC.W DATA8_81D13A+2,Y                    ; $80D8CF |
  STA.B $12                                 ; $80D8D2 |
  LDA.W DATA8_819E4C+2,X                    ; $80D8D4 |
  AND.W #$00FF                              ; $80D8D7 |
  TAY                                       ; $80D8DA |
  LDA.W DATA8_81D13A,Y                      ; $80D8DB |
  STA.B $26                                 ; $80D8DE |
  LDA.W DATA8_819224+1,X                    ; $80D8E0 |
  AND.W #$FF00                              ; $80D8E3 |

CODE_FN_80D8E6:
  CLC                                       ; $80D8E6 |
  ADC.W DATA8_81D13A+2,Y                    ; $80D8E7 |
  STA.B $22                                 ; $80D8EA |
  LDA.W CODE_009E4F,X                       ; $80D8EC |
  AND.W #$00FF                              ; $80D8EF |
  TAY                                       ; $80D8F2 |
  LDA.W DATA8_81D13A,Y                      ; $80D8F3 |
  STA.B $36                                 ; $80D8F6 |
  LDA.W DATA8_819224+2,X                    ; $80D8F8 |
  AND.W #$FF00                              ; $80D8FB |
  CLC                                       ; $80D8FE |
  ADC.W DATA8_81D13A+2,Y                    ; $80D8FF |
  STA.B $32                                 ; $80D902 |
  SEP #$20                                  ; $80D904 |
  LDA.B #$FF                                ; $80D906 |
  STA.B $82                                 ; $80D908 |
  STA.B $83                                 ; $80D90A |
  STA.B $D0                                 ; $80D90C |
  STA.B $D1                                 ; $80D90E |
  STZ.B $98                                 ; $80D910 |
  STZ.B $E6                                 ; $80D912 |
  STZ.B $84                                 ; $80D914 |
  STZ.B $85                                 ; $80D916 |
  STZ.B $D2                                 ; $80D918 |
  STZ.B $D3                                 ; $80D91A |
  STZ.B $E8                                 ; $80D91C |
  STZ.B $EA                                 ; $80D91E |
  REP #$20                                  ; $80D920 |
  LDA.W !r_room_id                          ; $80D922 |
  ASL A                                     ; $80D925 |
  TAX                                       ; $80D926 |
  LDA.W DATA16_81A460,X                     ; $80D927 |
  STA.B $F2                                 ; $80D92A |
  AND.W #$FF00                              ; $80D92C |
  BEQ CODE_80D938                           ; $80D92F |
  LDA.W CODE_00A76A,X                       ; $80D931 |
  STA.B $F0                                 ; $80D934 |
  BRA CODE_80D9AF                           ; $80D936 |


CODE_80D938:
  LDY.W CODE_00A76A,X                       ; $80D938 |
  LDA.W CODE_00D14A,Y                       ; $80D93B |
  STA.B $A0                                 ; $80D93E |
  LDA.W CODE_00D14C,Y                       ; $80D940 |
  STA.B $A2                                 ; $80D943 |
  LDA.W LOOSE_OP_00D14E,Y                   ; $80D945 |
  STA.B $A4                                 ; $80D948 |
  LDA.W LOOSE_OP_00D150,Y                   ; $80D94A |
  STA.B $A6                                 ; $80D94D |
  STZ.B $B0                                 ; $80D94F |
  STZ.B $B2                                 ; $80D951 |
  STZ.B $B4                                 ; $80D953 |
  STZ.B $B6                                 ; $80D955 |
  LDY.W #$0000                              ; $80D957 |

CODE_80D95A:
  LDA.B $A0                                 ; $80D95A |
  CLC                                       ; $80D95C |
  ADC.B $B0                                 ; $80D95D |
  STA.B $B0                                 ; $80D95F |
  STA.W $17E0,Y                             ; $80D961 |
  INY                                       ; $80D964 |
  INY                                       ; $80D965 |
  CPY.W #$0010                              ; $80D966 |
  BCC CODE_80D95A                           ; $80D969 |
  LDY.W #$0000                              ; $80D96B |

CODE_80D96E:
  LDA.B $A2                                 ; $80D96E |
  CLC                                       ; $80D970 |
  ADC.B $B2                                 ; $80D971 |
  STA.B $B2                                 ; $80D973 |
  EOR.W #$FFFF                              ; $80D975 |
  INC A                                     ; $80D978 |
  STA.W $17F0,Y                             ; $80D979 |
  INY                                       ; $80D97C |
  INY                                       ; $80D97D |
  CPY.W #$0010                              ; $80D97E |
  BCC CODE_80D96E                           ; $80D981 |
  LDY.W #$0000                              ; $80D983 |

CODE_80D986:
  LDA.B $A4                                 ; $80D986 |
  CLC                                       ; $80D988 |
  ADC.B $B4                                 ; $80D989 |
  STA.B $B4                                 ; $80D98B |
  STA.W $1800,Y                             ; $80D98D |
  INY                                       ; $80D990 |
  INY                                       ; $80D991 |
  CPY.W #$0010                              ; $80D992 |
  BCC CODE_80D986                           ; $80D995 |
  LDY.W #$0000                              ; $80D997 |

CODE_80D99A:
  LDA.B $A6                                 ; $80D99A |
  CLC                                       ; $80D99C |
  ADC.B $B6                                 ; $80D99D |
  STA.B $B6                                 ; $80D99F |
  EOR.W #$FFFF                              ; $80D9A1 |
  INC A                                     ; $80D9A4 |
  STA.W $1810,Y                             ; $80D9A5 |
  INY                                       ; $80D9A8 |
  INY                                       ; $80D9A9 |
  CPY.W #$0010                              ; $80D9AA |
  BCC CODE_80D99A                           ; $80D9AD |

CODE_80D9AF:
  LDA.W #$0000                              ; $80D9AF |
  TCD                                       ; $80D9B2 |

CODE_JP_80D9B3:
  JSR.W CODE_FN_80DC9D                      ; $80D9B3 |
  JSL.L CODE_FL_80E5BF                      ; $80D9B6 |
  JSL.L CODE_FL_809570                      ; $80D9BA |
  DEC.W $1754                               ; $80D9BE |
  BNE CODE_JP_80D9B3                        ; $80D9C1 |
  STZ.W $1666                               ; $80D9C3 |
  STZ.W $1676                               ; $80D9C6 |
  STZ.W $1686                               ; $80D9C9 |
  STZ.W $1696                               ; $80D9CC |
  INC.W $16E0                               ; $80D9CF |
  RTL                                       ; $80D9D2 |


CODE_FL_80D9D3:
  JSR.W CODE_FN_80DCF3                      ; $80D9D3 |
  JSL.L CODE_FL_80E4BB                      ; $80D9D6 |
  STZ.W $1666                               ; $80D9DA |
  STZ.W $1676                               ; $80D9DD |
  STZ.W $1686                               ; $80D9E0 |
  STZ.W $1696                               ; $80D9E3 |
  RTL                                       ; $80D9E6 |


CODE_JP_80D9E7:
  LDA.B $85                                 ; $80D9E7 |
  LSR A                                     ; $80D9E9 |
  BCS CODE_80DA08                           ; $80D9EA |
  REP #$20                                  ; $80D9EC |
  LDA.B $02                                 ; $80D9EE |
  SEC                                       ; $80D9F0 |
  SBC.W #$0061                              ; $80D9F1 |
  STA.B $90                                 ; $80D9F4 |
  BPL CODE_80DA1C                           ; $80D9F6 |
  STZ.B $98                                 ; $80D9F8 |
  LDA.W #$0000                              ; $80D9FA |
  TCD                                       ; $80D9FD |
  RTS                                       ; $80D9FE |


CODE_80D9FF:
  STZ.B $98                                 ; $80D9FF |
  REP #$20                                  ; $80DA01 |
  LDA.W #$0000                              ; $80DA03 |

  TCD                                       ; $80DA06 |
  RTS                                       ; $80DA07 |


CODE_80DA08:
  REP #$20                                  ; $80DA08 |

  LDA.B $02                                 ; $80DA0A |

  CLC                                       ; $80DA0C |
  ADC.W #$015F                              ; $80DA0D |
  STA.B $90                                 ; $80DA10 |
  SEP #$20                                  ; $80DA12 |
  LDA.B $91                                 ; $80DA14 |

  CMP.B $86                                 ; $80DA16 |
  BCS CODE_80D9FF                           ; $80DA18 |
  REP #$20                                  ; $80DA1A |

CODE_80DA1C:
  LDY.W #$000F                              ; $80DA1C |
  LDA.B $12                                 ; $80DA1F |
  SEC                                       ; $80DA21 |
  SBC.W #$0061                              ; $80DA22 |
  BPL CODE_80DA3D                           ; $80DA25 |
  DEY                                       ; $80DA27 |
  CMP.W #$FFE0                              ; $80DA28 |
  BCS CODE_80DA3A                           ; $80DA2B |
  DEY                                       ; $80DA2D |
  CMP.W #$FFC0                              ; $80DA2E |
  BCS CODE_80DA3A                           ; $80DA31 |
  DEY                                       ; $80DA33 |
  CMP.W #$FFA0                              ; $80DA34 |
  BCS CODE_80DA3A                           ; $80DA37 |
  DEY                                       ; $80DA39 |

CODE_80DA3A:
  LDA.W #$0000                              ; $80DA3A |

CODE_80DA3D:
  STA.B $92                                 ; $80DA3D |
  STY.B $8E                                 ; $80DA3F |
  LDA.W #$0005                              ; $80DA41 |
  STA.B $A0                                 ; $80DA44 |
  JSR.W CODE_FN_80DEDF                      ; $80DA46 |
  JSR.W CODE_FN_80DBC8                      ; $80DA49 |
  JSR.W CODE_FN_80DBF4                      ; $80DA4C |

CODE_80DA4F:
  LDX.B $8A                                 ; $80DA4F |
  LDA.L $7FC000,X                           ; $80DA51 |
  AND.W #$00FF                              ; $80DA55 |
  ASL A                                     ; $80DA58 |
  ASL A                                     ; $80DA59 |
  STA.B $B4                                 ; $80DA5A |
  ASL A                                     ; $80DA5C |
  ASL A                                     ; $80DA5D |
  ASL A                                     ; $80DA5E |
  ADC.W #$A000                              ; $80DA5F |
  STA.B $B0                                 ; $80DA62 |
  JSR.W CODE_FN_80DC20                      ; $80DA64 |
  DEC.B $8E                                 ; $80DA67 |
  BEQ CODE_80DAB5                           ; $80DA69 |
  DEC.B $A0                                 ; $80DA6B |
  BEQ CODE_80DABC                           ; $80DA6D |

CODE_80DA6F:
  LDA.B $8A                                 ; $80DA6F |
  CLC                                       ; $80DA71 |
  ADC.W #$0008                              ; $80DA72 |
  STA.B $8A                                 ; $80DA75 |
  AND.W #$0038                              ; $80DA77 |
  BEQ CODE_80DA85                           ; $80DA7A |
  LDA.B $B2                                 ; $80DA7C |
  ADC.W #$0020                              ; $80DA7E |
  STA.B $B2                                 ; $80DA81 |
  BRA CODE_80DA4F                           ; $80DA83 |


CODE_80DA85:
  LDA.B $92                                 ; $80DA85 |
  CLC                                       ; $80DA87 |
  ADC.W #$0100                              ; $80DA88 |
  AND.W #$FF00                              ; $80DA8B |
  STA.B $92                                 ; $80DA8E |
  SEP #$20                                  ; $80DA90 |
  LDA.B $93                                 ; $80DA92 |
  CMP.B $88                                 ; $80DA94 |
  BCS CODE_80DAAC                           ; $80DA96 |
  REP #$20                                  ; $80DA98 |
  JSR.W CODE_FN_80DEDF                      ; $80DA9A |
  LDA.B $B2                                 ; $80DA9D |
  EOR.W #$0800                              ; $80DA9F |
  AND.W #$0C1F                              ; $80DAA2 |
  STA.B $B2                                 ; $80DAA5 |
  JSR.W CODE_FN_80DBF4                      ; $80DAA7 |
  BRA CODE_80DA4F                           ; $80DAAA |


CODE_80DAAC:
  STZ.B $98                                 ; $80DAAC |
  REP #$20                                  ; $80DAAE |
  LDA.W #$0000                              ; $80DAB0 |
  TCD                                       ; $80DAB3 |
  RTS                                       ; $80DAB4 |


CODE_80DAB5:
  STZ.B $98                                 ; $80DAB5 |
  LDA.W #$0000                              ; $80DAB7 |
  TCD                                       ; $80DABA |
  RTS                                       ; $80DABB |


CODE_80DABC:
  LDA.B $B0                                 ; $80DABC |

  STA.B $94                                 ; $80DABE |

  LDA.B $B2                                 ; $80DAC0 |

  STA.B $96                                 ; $80DAC2 |

  LDA.W #$0000                              ; $80DAC4 |

  TCD                                       ; $80DAC7 |

  RTS                                       ; $80DAC8 |


CODE_JP_80DAC9:
  REP #$20                                  ; $80DAC9 |
  LDA.B $94                                 ; $80DACB |
  STA.B $B0                                 ; $80DACD |
  LDA.B $96                                 ; $80DACF |
  STA.B $B2                                 ; $80DAD1 |
  LDA.W #$0005                              ; $80DAD3 |

  STA.B $A0                                 ; $80DAD6 |

  LDA.B $85                                 ; $80DAD8 |

  AND.W #$0003                              ; $80DADA |
  BNE CODE_80DA6F                           ; $80DADD |
  JMP.W CODE_JP_80DB6B                      ; $80DADF |


CODE_JP_80DAE2:
  LDA.B $85                                 ; $80DAE2 |
  AND.B #$08                                ; $80DAE4 |
  BEQ CODE_80DB04                           ; $80DAE6 |
  REP #$20                                  ; $80DAE8 |
  LDA.B $12                                 ; $80DAEA |
  SEC                                       ; $80DAEC |
  SBC.W #$0061                              ; $80DAED |
  STA.B $92                                 ; $80DAF0 |
  BPL CODE_80DB18                           ; $80DAF2 |
  STZ.B $98                                 ; $80DAF4 |
  LDA.W #$0000                              ; $80DAF6 |
  TCD                                       ; $80DAF9 |
  RTS                                       ; $80DAFA |


CODE_80DAFB:
  STZ.B $98                                 ; $80DAFB |
  REP #$20                                  ; $80DAFD |
  LDA.W #$0000                              ; $80DAFF |
  TCD                                       ; $80DB02 |
  RTS                                       ; $80DB03 |


CODE_80DB04:
  REP #$20                                  ; $80DB04 |
  LDA.B $12                                 ; $80DB06 |
  CLC                                       ; $80DB08 |
  ADC.W #$015F                              ; $80DB09 |
  STA.B $92                                 ; $80DB0C |
  SEP #$20                                  ; $80DB0E |
  LDA.B $93                                 ; $80DB10 |
  CMP.B $88                                 ; $80DB12 |
  BCS CODE_80DAFB                           ; $80DB14 |
  REP #$20                                  ; $80DB16 |

CODE_80DB18:
  LDY.W #$000F                              ; $80DB18 |
  LDA.B $02                                 ; $80DB1B |
  SEC                                       ; $80DB1D |
  SBC.W #$0061                              ; $80DB1E |
  BPL CODE_80DB39                           ; $80DB21 |
  DEY                                       ; $80DB23 |
  CMP.W #$FFE0                              ; $80DB24 |

  BCS CODE_80DB36                           ; $80DB27 |

  DEY                                       ; $80DB29 |
  CMP.W #$FFC0                              ; $80DB2A |
  BCS CODE_80DB36                           ; $80DB2D |
  DEY                                       ; $80DB2F |
  CMP.W #$FFA0                              ; $80DB30 |
  BCS CODE_80DB36                           ; $80DB33 |
  DEY                                       ; $80DB35 |

CODE_80DB36:
  LDA.W #$0000                              ; $80DB36 |

CODE_80DB39:
  STA.B $90                                 ; $80DB39 |
  STY.B $8E                                 ; $80DB3B |
  LDA.W #$0005                              ; $80DB3D |

  STA.B $A0                                 ; $80DB40 |
  JSR.W CODE_FN_80DEDF                      ; $80DB42 |
  JSR.W CODE_FN_80DBC8                      ; $80DB45 |

  JSR.W CODE_FN_80DBF4                      ; $80DB48 |

CODE_80DB4B:
  LDX.B $8A                                 ; $80DB4B |

  LDA.L $7FC000,X                           ; $80DB4D |
  AND.W #$00FF                              ; $80DB51 |
  ASL A                                     ; $80DB54 |
  ASL A                                     ; $80DB55 |
  STA.B $B4                                 ; $80DB56 |
  ASL A                                     ; $80DB58 |
  ASL A                                     ; $80DB59 |
  ASL A                                     ; $80DB5A |
  ADC.W #$A000                              ; $80DB5B |
  STA.B $B0                                 ; $80DB5E |
  JSR.W CODE_FN_80DC20                      ; $80DB60 |
  DEC.B $8E                                 ; $80DB63 |
  BEQ CODE_80DBB4                           ; $80DB65 |
  DEC.B $A0                                 ; $80DB67 |
  BEQ CODE_80DBBB                           ; $80DB69 |

CODE_JP_80DB6B:
  LDA.B $8A                                 ; $80DB6B |
  AND.W #$0007                              ; $80DB6D |
  CMP.W #$0007                              ; $80DB70 |
  BEQ CODE_80DB84                           ; $80DB73 |
  INC.B $8A                                 ; $80DB75 |
  LDA.B $B2                                 ; $80DB77 |
  AND.W #$FF9F                              ; $80DB79 |
  CLC                                       ; $80DB7C |
  ADC.W #$0004                              ; $80DB7D |
  STA.B $B2                                 ; $80DB80 |

  BRA CODE_80DB4B                           ; $80DB82 |


CODE_80DB84:
  LDA.B $90                                 ; $80DB84 |

  CLC                                       ; $80DB86 |

  ADC.W #$0100                              ; $80DB87 |
  AND.W #$FF00                              ; $80DB8A |
  STA.B $90                                 ; $80DB8D |
  SEP #$20                                  ; $80DB8F |
  LDA.B $91                                 ; $80DB91 |
  CMP.B $86                                 ; $80DB93 |
  BCS CODE_80DBAB                           ; $80DB95 |
  REP #$20                                  ; $80DB97 |
  JSR.W CODE_FN_80DEDF                      ; $80DB99 |
  LDA.B $B2                                 ; $80DB9C |
  EOR.W #$0400                              ; $80DB9E |
  AND.W #$0F80                              ; $80DBA1 |
  STA.B $B2                                 ; $80DBA4 |
  JSR.W CODE_FN_80DBF4                      ; $80DBA6 |
  BRA CODE_80DB4B                           ; $80DBA9 |


CODE_80DBAB:
  STZ.B $98                                 ; $80DBAB |
  REP #$20                                  ; $80DBAD |
  LDA.W #$0000                              ; $80DBAF |
  TCD                                       ; $80DBB2 |
  RTS                                       ; $80DBB3 |


CODE_80DBB4:
  STZ.B $98                                 ; $80DBB4 |
  LDA.W #$0000                              ; $80DBB6 |
  TCD                                       ; $80DBB9 |
  RTS                                       ; $80DBBA |


CODE_80DBBB:
  LDA.B $B0                                 ; $80DBBB |
  STA.B $94                                 ; $80DBBD |
  LDA.B $B2                                 ; $80DBBF |
  STA.B $96                                 ; $80DBC1 |
  LDA.W #$0000                              ; $80DBC3 |
  TCD                                       ; $80DBC6 |
  RTS                                       ; $80DBC7 |


CODE_FN_80DBC8:
  SEP #$20                                  ; $80DBC8 |
  LDA.B $90                                 ; $80DBCA |
  AND.B #$E0                                ; $80DBCC |
  LSR A                                     ; $80DBCE |
  LSR A                                     ; $80DBCF |
  LSR A                                     ; $80DBD0 |
  STA.B $B2                                 ; $80DBD1 |
  LDA.B $91                                 ; $80DBD3 |
  AND.B #$01                                ; $80DBD5 |
  ASL A                                     ; $80DBD7 |
  ASL A                                     ; $80DBD8 |
  STA.B $B3                                 ; $80DBD9 |
  LDA.B $93                                 ; $80DBDB |
  AND.B #$01                                ; $80DBDD |
  ASL A                                     ; $80DBDF |
  ASL A                                     ; $80DBE0 |
  ASL A                                     ; $80DBE1 |
  ORA.B $B3                                 ; $80DBE2 |
  STA.B $B3                                 ; $80DBE4 |
  LDA.B $92                                 ; $80DBE6 |
  REP #$20                                  ; $80DBE8 |
  AND.W #$00E0                              ; $80DBEA |
  ASL A                                     ; $80DBED |
  ASL A                                     ; $80DBEE |
  ADC.B $B2                                 ; $80DBEF |
  STA.B $B2                                 ; $80DBF1 |
  RTS                                       ; $80DBF3 |


CODE_FN_80DBF4:
  LDA.B $8C                                 ; $80DBF4 |
  SEP #$20                                  ; $80DBF6 |
  XBA                                       ; $80DBF8 |
  REP #$20                                  ; $80DBF9 |
  LSR A                                     ; $80DBFB |
  LSR A                                     ; $80DBFC |
  STA.B $C2                                 ; $80DBFD |
  SEP #$20                                  ; $80DBFF |
  LDA.B $90                                 ; $80DC01 |
  LSR A                                     ; $80DC03 |
  LSR A                                     ; $80DC04 |
  LSR A                                     ; $80DC05 |
  LSR A                                     ; $80DC06 |
  LSR A                                     ; $80DC07 |
  STA.B $C0                                 ; $80DC08 |
  LDA.B $92                                 ; $80DC0A |
  AND.B #$E0                                ; $80DC0C |
  LSR A                                     ; $80DC0E |
  LSR A                                     ; $80DC0F |
  CLC                                       ; $80DC10 |
  ADC.B $C0                                 ; $80DC11 |
  STA.B $C0                                 ; $80DC13 |
  STZ.B $C1                                 ; $80DC15 |
  REP #$20                                  ; $80DC17 |
  LDA.B $C0                                 ; $80DC19 |
  ADC.B $C2                                 ; $80DC1B |
  STA.B $8A                                 ; $80DC1D |
  RTS                                       ; $80DC1F |


CODE_FN_80DC20:
  PEA.W $7E00                               ; $80DC20 |
  PLB                                       ; $80DC23 |
  PLB                                       ; $80DC24 |
  LDY.W $19D0                               ; $80DC25 |
  STY.B $A2                                 ; $80DC28 |
  LDA.B $B0                                 ; $80DC2A |
  STA.W $0000,Y                             ; $80DC2C |
  ADC.W #$0008                              ; $80DC2F |
  STA.W $0004,Y                             ; $80DC32 |
  ADC.W #$0008                              ; $80DC35 |
  STA.W $0008,Y                             ; $80DC38 |
  ADC.W #$0008                              ; $80DC3B |
  STA.B $B0                                 ; $80DC3E |
  STA.W $000C,Y                             ; $80DC40 |
  LDA.B $B2                                 ; $80DC43 |
  STA.W $0002,Y                             ; $80DC45 |
  AND.W #$0FFF                              ; $80DC48 |
  TAX                                       ; $80DC4B |
  LDY.B $B4                                 ; $80DC4C |
  LDA.W $8000,Y                             ; $80DC4E |
  STA.L $7F8000,X                           ; $80DC51 |
  LDA.W $8001,Y                             ; $80DC55 |
  STA.L $7F8002,X                           ; $80DC58 |
  LDY.B $A2                                 ; $80DC5C |
  LDA.B $B2                                 ; $80DC5E |
  ADC.W #$0020                              ; $80DC60 |
  STA.B $B2                                 ; $80DC63 |
  STA.W $0006,Y                             ; $80DC65 |
  ADC.W #$0020                              ; $80DC68 |
  STA.B $B2                                 ; $80DC6B |
  STA.W $000A,Y                             ; $80DC6D |
  AND.W #$0FFF                              ; $80DC70 |
  TAX                                       ; $80DC73 |
  LDY.B $B4                                 ; $80DC74 |
  LDA.W $8002,Y                             ; $80DC76 |
  STA.L $7F8000,X                           ; $80DC79 |
  LDA.W $8003,Y                             ; $80DC7D |
  STA.L $7F8002,X                           ; $80DC80 |
  LDY.B $A2                                 ; $80DC84 |
  LDA.B $B2                                 ; $80DC86 |
  ADC.W #$0020                              ; $80DC88 |
  STA.B $B2                                 ; $80DC8B |
  STA.W $000E,Y                             ; $80DC8D |
  TYA                                       ; $80DC90 |
  ADC.W #$0010                              ; $80DC91 |
  STA.W $19D0                               ; $80DC94 |
  PEA.W $8100                               ; $80DC97 |
  PLB                                       ; $80DC9A |
  PLB                                       ; $80DC9B |
  RTS                                       ; $80DC9C |


CODE_FN_80DC9D:
  LDA.W #$1660                              ; $80DC9D |
  TCD                                       ; $80DCA0 |
  STZ.B $EC                                 ; $80DCA1 |
  STZ.B $EE                                 ; $80DCA3 |
  LDA.B $06                                 ; $80DCA5 |
  BNE CODE_80DCAC                           ; $80DCA7 |
  JMP.W CODE_JP_80DD44                      ; $80DCA9 |


CODE_80DCAC:
  CLC                                       ; $80DCAC |
  BMI CODE_80DCD0                           ; $80DCAD |
  ADC.B $02                                 ; $80DCAF |
  STA.B $02                                 ; $80DCB1 |
  JSR.W CODE_FN_80DDF3                      ; $80DCB3 |
  LDA.B $82                                 ; $80DCB6 |
  CLC                                       ; $80DCB8 |
  ADC.B $EC                                 ; $80DCB9 |
  STA.B $82                                 ; $80DCBB |
  BMI CODE_80DCCC                           ; $80DCBD |
  SEC                                       ; $80DCBF |
  SBC.B #$20                                ; $80DCC0 |
  STA.B $82                                 ; $80DCC2 |
  LDA.B $84                                 ; $80DCC4 |
  AND.B #$0C                                ; $80DCC6 |
  ORA.B #$01                                ; $80DCC8 |
  STA.B $84                                 ; $80DCCA |

CODE_80DCCC:
  REP #$20                                  ; $80DCCC |
  BRA CODE_JP_80DD44                        ; $80DCCE |


CODE_80DCD0:
  ADC.B $02                                 ; $80DCD0 |
  STA.B $02                                 ; $80DCD2 |
  JSR.W CODE_FN_80DDF7                      ; $80DCD4 |
  LDA.B $82                                 ; $80DCD7 |
  CLC                                       ; $80DCD9 |
  ADC.B $EC                                 ; $80DCDA |
  STA.B $82                                 ; $80DCDC |
  CMP.B #$E0                                ; $80DCDE |
  BCS CODE_80DCEF                           ; $80DCE0 |
  CLC                                       ; $80DCE2 |
  ADC.B #$20                                ; $80DCE3 |
  STA.B $82                                 ; $80DCE5 |
  LDA.B $84                                 ; $80DCE7 |
  AND.B #$0C                                ; $80DCE9 |
  ORA.B #$02                                ; $80DCEB |
  STA.B $84                                 ; $80DCED |

CODE_80DCEF:
  REP #$20                                  ; $80DCEF |
  BRA CODE_JP_80DD44                        ; $80DCF1 |


CODE_FN_80DCF3:
  LDA.W #$1660                              ; $80DCF3 |
  TCD                                       ; $80DCF6 |
  STZ.B $EC                                 ; $80DCF7 |
  STZ.B $EE                                 ; $80DCF9 |
  LDA.B $06                                 ; $80DCFB |
  BEQ CODE_JP_80DD44                        ; $80DCFD |
  CLC                                       ; $80DCFF |
  BMI CODE_80DD23                           ; $80DD00 |
  ADC.B $02                                 ; $80DD02 |
  STA.B $02                                 ; $80DD04 |
  JSR.W CODE_FN_80DDFB                      ; $80DD06 |
  LDA.B $82                                 ; $80DD09 |
  CLC                                       ; $80DD0B |
  ADC.B $EC                                 ; $80DD0C |
  STA.B $82                                 ; $80DD0E |
  BMI CODE_80DD1F                           ; $80DD10 |
  SEC                                       ; $80DD12 |
  SBC.B #$20                                ; $80DD13 |
  STA.B $82                                 ; $80DD15 |
  LDA.B $84                                 ; $80DD17 |
  AND.B #$0C                                ; $80DD19 |
  ORA.B #$01                                ; $80DD1B |
  STA.B $84                                 ; $80DD1D |

CODE_80DD1F:
  REP #$20                                  ; $80DD1F |
  BRA CODE_JP_80DD44                        ; $80DD21 |


CODE_80DD23:
  ADC.B $02                                 ; $80DD23 |
  STA.B $02                                 ; $80DD25 |
  JSR.W CODE_FN_80DE2A                      ; $80DD27 |
  LDA.B $82                                 ; $80DD2A |
  CLC                                       ; $80DD2C |
  ADC.B $EC                                 ; $80DD2D |
  STA.B $82                                 ; $80DD2F |
  CMP.B #$E0                                ; $80DD31 |
  BCS CODE_80DD42                           ; $80DD33 |
  CLC                                       ; $80DD35 |
  ADC.B #$20                                ; $80DD36 |
  STA.B $82                                 ; $80DD38 |
  LDA.B $84                                 ; $80DD3A |
  AND.B #$0C                                ; $80DD3C |
  ORA.B #$02                                ; $80DD3E |
  STA.B $84                                 ; $80DD40 |

CODE_80DD42:
  REP #$20                                  ; $80DD42 |

CODE_JP_80DD44:
  LDA.B $16                                 ; $80DD44 |
  BEQ CODE_80DDA7                           ; $80DD46 |
  CLC                                       ; $80DD48 |
  BPL CODE_80DD6C                           ; $80DD49 |
  ADC.B $12                                 ; $80DD4B |
  STA.B $12                                 ; $80DD4D |
  JSR.W CODE_FN_80DE8F                      ; $80DD4F |
  LDA.B $83                                 ; $80DD52 |
  CLC                                       ; $80DD54 |
  ADC.B $EE                                 ; $80DD55 |
  STA.B $83                                 ; $80DD57 |
  CMP.B #$E0                                ; $80DD59 |
  BCS CODE_80DD89                           ; $80DD5B |
  CLC                                       ; $80DD5D |
  ADC.B #$20                                ; $80DD5E |
  STA.B $83                                 ; $80DD60 |
  LDA.B $84                                 ; $80DD62 |
  AND.B #$03                                ; $80DD64 |
  ORA.B #$08                                ; $80DD66 |
  STA.B $84                                 ; $80DD68 |
  BRA CODE_80DD89                           ; $80DD6A |


CODE_80DD6C:
  ADC.B $12                                 ; $80DD6C |
  STA.B $12                                 ; $80DD6E |
  JSR.W CODE_FN_80DE60                      ; $80DD70 |
  LDA.B $83                                 ; $80DD73 |
  CLC                                       ; $80DD75 |
  ADC.B $EE                                 ; $80DD76 |
  STA.B $83                                 ; $80DD78 |
  BMI CODE_80DD89                           ; $80DD7A |
  SEC                                       ; $80DD7C |
  SBC.B #$20                                ; $80DD7D |
  STA.B $83                                 ; $80DD7F |
  LDA.B $84                                 ; $80DD81 |
  AND.B #$03                                ; $80DD83 |
  ORA.B #$04                                ; $80DD85 |
  STA.B $84                                 ; $80DD87 |

CODE_80DD89:
  LDA.B $98                                 ; $80DD89 |
  BEQ CODE_80DDAD                           ; $80DD8B |
  LDA.B $84                                 ; $80DD8D |
  BEQ CODE_80DD9B                           ; $80DD8F |
  BIT.B #$0C                                ; $80DD91 |
  BNE CODE_80DD9E                           ; $80DD93 |
  LDA.B $85                                 ; $80DD95 |
  AND.B #$03                                ; $80DD97 |
  BNE CODE_80DDAB                           ; $80DD99 |

CODE_80DD9B:
  JMP.W CODE_JP_80DAC9                      ; $80DD9B |


CODE_80DD9E:
  LDA.B $85                                 ; $80DD9E |
  AND.B #$0C                                ; $80DDA0 |
  BNE CODE_80DDAB                           ; $80DDA2 |
  JMP.W CODE_JP_80DAC9                      ; $80DDA4 |


CODE_80DDA7:
  SEP #$20                                  ; $80DDA7 |
  BRA CODE_80DD89                           ; $80DDA9 |


CODE_80DDAB:
  STZ.B $98                                 ; $80DDAB |

CODE_80DDAD:
  LDA.B $85                                 ; $80DDAD |
  AND.B #$03                                ; $80DDAF |
  BNE CODE_80DDC6                           ; $80DDB1 |
  LDA.B $84                                 ; $80DDB3 |
  AND.B #$03                                ; $80DDB5 |
  BNE CODE_80DDD9                           ; $80DDB7 |
  LDA.B $84                                 ; $80DDB9 |
  AND.B #$0C                                ; $80DDBB |
  BNE CODE_80DDE6                           ; $80DDBD |
  REP #$20                                  ; $80DDBF |
  LDA.W #$0000                              ; $80DDC1 |
  TCD                                       ; $80DDC4 |
  RTS                                       ; $80DDC5 |


CODE_80DDC6:
  LDA.B $84                                 ; $80DDC6 |
  AND.B #$0C                                ; $80DDC8 |
  BNE CODE_80DDE6                           ; $80DDCA |
  LDA.B $84                                 ; $80DDCC |
  AND.B #$03                                ; $80DDCE |
  BNE CODE_80DDD9                           ; $80DDD0 |
  REP #$20                                  ; $80DDD2 |
  LDA.W #$0000                              ; $80DDD4 |
  TCD                                       ; $80DDD7 |
  RTS                                       ; $80DDD8 |


CODE_80DDD9:
  STA.B $85                                 ; $80DDD9 |
  LDA.B $84                                 ; $80DDDB |
  AND.B #$0C                                ; $80DDDD |
  STA.B $84                                 ; $80DDDF |
  INC.B $98                                 ; $80DDE1 |
  JMP.W CODE_JP_80D9E7                      ; $80DDE3 |


CODE_80DDE6:
  STA.B $85                                 ; $80DDE6 |
  LDA.B $84                                 ; $80DDE8 |
  AND.B #$03                                ; $80DDEA |
  STA.B $84                                 ; $80DDEC |
  INC.B $98                                 ; $80DDEE |
  JMP.W CODE_JP_80DAE2                      ; $80DDF0 |


CODE_FN_80DDF3:
  SEP #$20                                  ; $80DDF3 |
  BRA CODE_80DE1B                           ; $80DDF5 |


CODE_FN_80DDF7:
  SEP #$20                                  ; $80DDF7 |
  BRA CODE_80DE57                           ; $80DDF9 |


CODE_FN_80DDFB:
  ADC.W #$00FF                              ; $80DDFB |
  SEP #$20                                  ; $80DDFE |
  XBA                                       ; $80DE00 |
  CMP.B $86                                 ; $80DE01 |
  BCS CODE_80DE20                           ; $80DE03 |
  STA.B $B0                                 ; $80DE05 |
  LDA.B $13                                 ; $80DE07 |
  STA.B $B2                                 ; $80DE09 |
  JSR.W CODE_FN_80DEFF                      ; $80DE0B |
  BMI CODE_80DE20                           ; $80DE0E |
  LDA.B $12                                 ; $80DE10 |
  BEQ CODE_80DE1B                           ; $80DE12 |
  INC.B $B2                                 ; $80DE14 |
  JSR.W CODE_FN_80DEFF                      ; $80DE16 |
  BMI CODE_80DE20                           ; $80DE19 |

CODE_80DE1B:
  LDA.B $06                                 ; $80DE1B |
  STA.B $EC                                 ; $80DE1D |
  RTS                                       ; $80DE1F |


CODE_80DE20:
  LDA.B $06                                 ; $80DE20 |
  SEC                                       ; $80DE22 |
  SBC.B $02                                 ; $80DE23 |
  STA.B $EC                                 ; $80DE25 |
  STZ.B $02                                 ; $80DE27 |
  RTS                                       ; $80DE29 |


CODE_FN_80DE2A:
  SEP #$20                                  ; $80DE2A |
  XBA                                       ; $80DE2C |
  BMI CODE_80DE45                           ; $80DE2D |
  STA.B $B0                                 ; $80DE2F |
  LDA.B $13                                 ; $80DE31 |
  STA.B $B2                                 ; $80DE33 |
  JSR.W CODE_FN_80DEFF                      ; $80DE35 |
  BMI CODE_80DE45                           ; $80DE38 |
  LDA.B $12                                 ; $80DE3A |
  BEQ CODE_80DE57                           ; $80DE3C |
  INC.B $B2                                 ; $80DE3E |
  JSR.W CODE_FN_80DEFF                      ; $80DE40 |
  BPL CODE_80DE57                           ; $80DE43 |

CODE_80DE45:
  INC.B $03                                 ; $80DE45 |
  LDA.B $06                                 ; $80DE47 |
  SEC                                       ; $80DE49 |
  SBC.B $02                                 ; $80DE4A |
  BEQ CODE_80DE54                           ; $80DE4C |
  STA.B $EC                                 ; $80DE4E |
  LDA.B #$FF                                ; $80DE50 |
  STA.B $ED                                 ; $80DE52 |

CODE_80DE54:
  STZ.B $02                                 ; $80DE54 |
  RTS                                       ; $80DE56 |


CODE_80DE57:
  LDA.B $06                                 ; $80DE57 |
  STA.B $EC                                 ; $80DE59 |
  LDA.B #$FF                                ; $80DE5B |
  STA.B $ED                                 ; $80DE5D |
  RTS                                       ; $80DE5F |


CODE_FN_80DE60:
  ADC.W #$00FF                              ; $80DE60 |
  SEP #$20                                  ; $80DE63 |
  XBA                                       ; $80DE65 |
  CMP.B $88                                 ; $80DE66 |
  BCS CODE_80DE85                           ; $80DE68 |
  STA.B $B2                                 ; $80DE6A |
  LDA.B $03                                 ; $80DE6C |
  STA.B $B0                                 ; $80DE6E |
  JSR.W CODE_FN_80DEFF                      ; $80DE70 |
  BMI CODE_80DE85                           ; $80DE73 |
  LDA.B $02                                 ; $80DE75 |
  BEQ CODE_80DE80                           ; $80DE77 |
  INC.B $B0                                 ; $80DE79 |
  JSR.W CODE_FN_80DEFF                      ; $80DE7B |
  BMI CODE_80DE85                           ; $80DE7E |

CODE_80DE80:
  LDA.B $16                                 ; $80DE80 |
  STA.B $EE                                 ; $80DE82 |
  RTS                                       ; $80DE84 |


CODE_80DE85:
  LDA.B $16                                 ; $80DE85 |
  SEC                                       ; $80DE87 |
  SBC.B $12                                 ; $80DE88 |
  STA.B $EE                                 ; $80DE8A |
  STZ.B $12                                 ; $80DE8C |
  RTS                                       ; $80DE8E |


CODE_FN_80DE8F:
  SEP #$20                                  ; $80DE8F |
  XBA                                       ; $80DE91 |
  BMI CODE_80DEAA                           ; $80DE92 |
  STA.B $B2                                 ; $80DE94 |
  LDA.B $03                                 ; $80DE96 |
  STA.B $B0                                 ; $80DE98 |
  JSR.W CODE_FN_80DEFF                      ; $80DE9A |
  BMI CODE_80DEAA                           ; $80DE9D |
  LDA.B $02                                 ; $80DE9F |
  BEQ CODE_80DEBC                           ; $80DEA1 |
  INC.B $B0                                 ; $80DEA3 |
  JSR.W CODE_FN_80DEFF                      ; $80DEA5 |
  BPL CODE_80DEBC                           ; $80DEA8 |

CODE_80DEAA:
  INC.B $13                                 ; $80DEAA |
  LDA.B $16                                 ; $80DEAC |

  SEC                                       ; $80DEAE |
  SBC.B $12                                 ; $80DEAF |
  BEQ CODE_80DEB9                           ; $80DEB1 |
  STA.B $EE                                 ; $80DEB3 |
  LDA.B #$FF                                ; $80DEB5 |
  STA.B $EF                                 ; $80DEB7 |

CODE_80DEB9:
  STZ.B $12                                 ; $80DEB9 |
  RTS                                       ; $80DEBB |


CODE_80DEBC:
  LDA.B $16                                 ; $80DEBC |

  STA.B $EE                                 ; $80DEBE |
  LDA.B #$FF                                ; $80DEC0 |
  STA.B $EF                                 ; $80DEC2 |
  RTS                                       ; $80DEC4 |


CODE_FN_80DEC5:
  LDA.W !r_room_id                          ; $80DEC5 |
  ASL A                                     ; $80DEC8 |
  TAX                                       ; $80DEC9 |
  LDA.W PTR16_81B9A6,X                      ; $80DECA | foreground pattern?

  STA.B $9A                                 ; $80DECD |
  LDA.W PTR16_81BCB0,X                      ; $80DECF | background pattern?
  STA.B $9D                                 ; $80DED2 |
  SEP #$20                                  ; $80DED4 |
  LDA.B #$81                                ; $80DED6 |
  STA.B $9C                                 ; $80DED8 |
  STA.B $9F                                 ; $80DEDA |
  REP #$20                                  ; $80DEDC |

  RTS                                       ; $80DEDE |


CODE_FN_80DEDF:
  SEP #$20                                  ; $80DEDF |
  LDA.B $93                                 ; $80DEE1 |
  STA.W !reg_wrmpya                         ; $80DEE3 |
  LDA.B $86                                 ; $80DEE6 |
  STA.W !reg_wrmpyb                         ; $80DEE8 |
  REP #$20                                  ; $80DEEB |
  LDA.B $91                                 ; $80DEED |
  AND.W #$00FF                              ; $80DEEF |
  CLC                                       ; $80DEF2 |
  ADC.W !reg_rdmpyl                         ; $80DEF3 |
  TAY                                       ; $80DEF6 |
  LDA.B [$9A],Y                             ; $80DEF7 |
  AND.W #$007F                              ; $80DEF9 |
  STA.B $8C                                 ; $80DEFC |
  RTS                                       ; $80DEFE |


CODE_FN_80DEFF:
  LDA.B $B2                                 ; $80DEFF |
  STA.W !reg_wrmpya                         ; $80DF01 |
  LDA.B $86                                 ; $80DF04 |
  STA.W !reg_wrmpyb                         ; $80DF06 |
  REP #$20                                  ; $80DF09 |
  LDA.B $B0                                 ; $80DF0B |
  AND.W #$00FF                              ; $80DF0D |

  CLC                                       ; $80DF10 |
  ADC.W !reg_rdmpyl                         ; $80DF11 |
  TAY                                       ; $80DF14 |
  SEP #$20                                  ; $80DF15 |
  LDA.B [$9A],Y                             ; $80DF17 |
  RTS                                       ; $80DF19 |


CODE_FL_80DF1A:
  JSR.W CODE_FN_80E1AC                      ; $80DF1A |
  JSL.L CODE_FL_80E4BB                      ; $80DF1D |
  STZ.W $1666                               ; $80DF21 |

  STZ.W $1676                               ; $80DF24 |
  STZ.W $1686                               ; $80DF27 |
  STZ.W $1696                               ; $80DF2A |
  RTL                                       ; $80DF2D |


CODE_JP_80DF2E:
  LDA.B $85                                 ; $80DF2E |

  LSR A                                     ; $80DF30 |
  BCS CODE_80DF4F                           ; $80DF31 |
  REP #$20                                  ; $80DF33 |

  LDA.B $02                                 ; $80DF35 |
  SEC                                       ; $80DF37 |

  SBC.W #$0061                              ; $80DF38 |
  STA.B $90                                 ; $80DF3B |

  BPL CODE_80DF63                           ; $80DF3D |
  STZ.B $98                                 ; $80DF3F |
  LDA.W #$0000                              ; $80DF41 |
  TCD                                       ; $80DF44 |
  RTS                                       ; $80DF45 |


CODE_80DF46:
  STZ.B $98                                 ; $80DF46 |

  REP #$20                                  ; $80DF48 |
  LDA.W #$0000                              ; $80DF4A |
  TCD                                       ; $80DF4D |
  RTS                                       ; $80DF4E |


CODE_80DF4F:
  REP #$20                                  ; $80DF4F |
  LDA.B $02                                 ; $80DF51 |
  CLC                                       ; $80DF53 |
  ADC.W #$015F                              ; $80DF54 |
  STA.B $90                                 ; $80DF57 |
  SEP #$20                                  ; $80DF59 |
  LDA.B $91                                 ; $80DF5B |
  CMP.B $86                                 ; $80DF5D |
  BCS CODE_80DF46                           ; $80DF5F |
  REP #$20                                  ; $80DF61 |

CODE_80DF63:
  LDY.W #$000F                              ; $80DF63 |
  LDA.B $12                                 ; $80DF66 |
  SEC                                       ; $80DF68 |
  SBC.W #$0061                              ; $80DF69 |
  BPL CODE_80DF84                           ; $80DF6C |
  DEY                                       ; $80DF6E |
  CMP.W #$FFE0                              ; $80DF6F |
  BCS CODE_80DF81                           ; $80DF72 |
  DEY                                       ; $80DF74 |
  CMP.W #$FFC0                              ; $80DF75 |
  BCS CODE_80DF81                           ; $80DF78 |
  DEY                                       ; $80DF7A |
  CMP.W #$FFA0                              ; $80DF7B |
  BCS CODE_80DF81                           ; $80DF7E |
  DEY                                       ; $80DF80 |

CODE_80DF81:
  LDA.W #$0000                              ; $80DF81 |

CODE_80DF84:
  STA.B $92                                 ; $80DF84 |
  STY.B $8E                                 ; $80DF86 |
  LDA.W #$0005                              ; $80DF88 |
  STA.B $A0                                 ; $80DF8B |
  JSR.W CODE_FN_80DEDF                      ; $80DF8D |
  JSR.W CODE_FN_80DBC8                      ; $80DF90 |
  JSR.W CODE_FN_80DBF4                      ; $80DF93 |

CODE_80DF96:
  LDX.B $8A                                 ; $80DF96 |
  LDA.L $7FC000,X                           ; $80DF98 |
  AND.W #$00FF                              ; $80DF9C |
  ASL A                                     ; $80DF9F |
  ASL A                                     ; $80DFA0 |
  STA.B $B4                                 ; $80DFA1 |
  ASL A                                     ; $80DFA3 |
  ASL A                                     ; $80DFA4 |
  ASL A                                     ; $80DFA5 |
  ADC.W #$A000                              ; $80DFA6 |
  STA.B $B0                                 ; $80DFA9 |
  JSR.W CODE_FN_80E10F                      ; $80DFAB |
  DEC.B $8E                                 ; $80DFAE |
  BEQ CODE_80DFFC                           ; $80DFB0 |
  DEC.B $A0                                 ; $80DFB2 |
  BEQ CODE_80E003                           ; $80DFB4 |

CODE_80DFB6:
  LDA.B $8A                                 ; $80DFB6 |
  CLC                                       ; $80DFB8 |
  ADC.W #$0008                              ; $80DFB9 |
  STA.B $8A                                 ; $80DFBC |
  AND.W #$0038                              ; $80DFBE |
  BEQ CODE_80DFCC                           ; $80DFC1 |
  LDA.B $B2                                 ; $80DFC3 |
  ADC.W #$0020                              ; $80DFC5 |
  STA.B $B2                                 ; $80DFC8 |
  BRA CODE_80DF96                           ; $80DFCA |


CODE_80DFCC:
  LDA.B $92                                 ; $80DFCC |
  CLC                                       ; $80DFCE |
  ADC.W #$0100                              ; $80DFCF |
  AND.W #$FF00                              ; $80DFD2 |
  STA.B $92                                 ; $80DFD5 |
  SEP #$20                                  ; $80DFD7 |
  LDA.B $93                                 ; $80DFD9 |
  CMP.B $88                                 ; $80DFDB |
  BCS CODE_80DFF3                           ; $80DFDD |
  REP #$20                                  ; $80DFDF |
  JSR.W CODE_FN_80DEDF                      ; $80DFE1 |
  LDA.B $B2                                 ; $80DFE4 |
  EOR.W #$0800                              ; $80DFE6 |
  AND.W #$0C1F                              ; $80DFE9 |
  STA.B $B2                                 ; $80DFEC |
  JSR.W CODE_FN_80DBF4                      ; $80DFEE |
  BRA CODE_80DF96                           ; $80DFF1 |


CODE_80DFF3:
  STZ.B $98                                 ; $80DFF3 |
  REP #$20                                  ; $80DFF5 |
  LDA.W #$0000                              ; $80DFF7 |
  TCD                                       ; $80DFFA |
  RTS                                       ; $80DFFB |


CODE_80DFFC:
  STZ.B $98                                 ; $80DFFC |
  LDA.W #$0000                              ; $80DFFE |
  TCD                                       ; $80E001 |
  RTS                                       ; $80E002 |


CODE_80E003:
  LDA.B $B0                                 ; $80E003 |
  STA.B $94                                 ; $80E005 |
  LDA.B $B2                                 ; $80E007 |
  STA.B $96                                 ; $80E009 |
  LDA.W #$0000                              ; $80E00B |
  TCD                                       ; $80E00E |
  RTS                                       ; $80E00F |


CODE_JP_80E010:
  REP #$20                                  ; $80E010 |
  LDA.B $94                                 ; $80E012 |
  STA.B $B0                                 ; $80E014 |
  LDA.B $96                                 ; $80E016 |
  STA.B $B2                                 ; $80E018 |
  LDA.W #$0005                              ; $80E01A |
  STA.B $A0                                 ; $80E01D |
  LDA.B $85                                 ; $80E01F |
  AND.W #$0003                              ; $80E021 |
  BNE CODE_80DFB6                           ; $80E024 |
  JMP.W CODE_JP_80E0B2                      ; $80E026 |


CODE_JP_80E029:
  LDA.B $85                                 ; $80E029 |
  AND.B #$08                                ; $80E02B |
  BEQ CODE_80E04B                           ; $80E02D |
  REP #$20                                  ; $80E02F |
  LDA.B $12                                 ; $80E031 |
  SEC                                       ; $80E033 |
  SBC.W #$0061                              ; $80E034 |
  STA.B $92                                 ; $80E037 |
  BPL CODE_80E05F                           ; $80E039 |
  STZ.B $98                                 ; $80E03B |
  LDA.W #$0000                              ; $80E03D |
  TCD                                       ; $80E040 |
  RTS                                       ; $80E041 |


CODE_80E042:
  STZ.B $98                                 ; $80E042 |
  REP #$20                                  ; $80E044 |
  LDA.W #$0000                              ; $80E046 |
  TCD                                       ; $80E049 |
  RTS                                       ; $80E04A |


CODE_80E04B:
  REP #$20                                  ; $80E04B |
  LDA.B $12                                 ; $80E04D |
  CLC                                       ; $80E04F |
  ADC.W #$015F                              ; $80E050 |
  STA.B $92                                 ; $80E053 |
  SEP #$20                                  ; $80E055 |
  LDA.B $93                                 ; $80E057 |
  CMP.B $88                                 ; $80E059 |
  BCS CODE_80E042                           ; $80E05B |
  REP #$20                                  ; $80E05D |

CODE_80E05F:
  LDY.W #$000F                              ; $80E05F |
  LDA.B $02                                 ; $80E062 |
  SEC                                       ; $80E064 |
  SBC.W #$0061                              ; $80E065 |
  BPL CODE_80E080                           ; $80E068 |
  DEY                                       ; $80E06A |
  CMP.W #$FFE0                              ; $80E06B |
  BCS CODE_80E07D                           ; $80E06E |
  DEY                                       ; $80E070 |
  CMP.W #$FFC0                              ; $80E071 |
  BCS CODE_80E07D                           ; $80E074 |
  DEY                                       ; $80E076 |
  CMP.W #$FFA0                              ; $80E077 |
  BCS CODE_80E07D                           ; $80E07A |
  DEY                                       ; $80E07C |

CODE_80E07D:
  LDA.W #$0000                              ; $80E07D |

CODE_80E080:
  STA.B $90                                 ; $80E080 |
  STY.B $8E                                 ; $80E082 |
  LDA.W #$0005                              ; $80E084 |
  STA.B $A0                                 ; $80E087 |
  JSR.W CODE_FN_80DEDF                      ; $80E089 |
  JSR.W CODE_FN_80DBC8                      ; $80E08C |
  JSR.W CODE_FN_80DBF4                      ; $80E08F |

CODE_80E092:
  LDX.B $8A                                 ; $80E092 |
  LDA.L $7FC000,X                           ; $80E094 |
  AND.W #$00FF                              ; $80E098 |
  ASL A                                     ; $80E09B |
  ASL A                                     ; $80E09C |
  STA.B $B4                                 ; $80E09D |
  ASL A                                     ; $80E09F |
  ASL A                                     ; $80E0A0 |
  ASL A                                     ; $80E0A1 |
  ADC.W #$A000                              ; $80E0A2 |
  STA.B $B0                                 ; $80E0A5 |
  JSR.W CODE_FN_80E10F                      ; $80E0A7 |
  DEC.B $8E                                 ; $80E0AA |
  BEQ CODE_80E0FB                           ; $80E0AC |
  DEC.B $A0                                 ; $80E0AE |
  BEQ CODE_80E102                           ; $80E0B0 |

CODE_JP_80E0B2:
  LDA.B $8A                                 ; $80E0B2 |
  AND.W #$0007                              ; $80E0B4 |
  CMP.W #$0007                              ; $80E0B7 |
  BEQ CODE_80E0CB                           ; $80E0BA |
  INC.B $8A                                 ; $80E0BC |
  LDA.B $B2                                 ; $80E0BE |
  AND.W #$FF9F                              ; $80E0C0 |
  CLC                                       ; $80E0C3 |
  ADC.W #$0004                              ; $80E0C4 |
  STA.B $B2                                 ; $80E0C7 |
  BRA CODE_80E092                           ; $80E0C9 |


CODE_80E0CB:
  LDA.B $90                                 ; $80E0CB |
  CLC                                       ; $80E0CD |
  ADC.W #$0100                              ; $80E0CE |
  AND.W #$FF00                              ; $80E0D1 |
  STA.B $90                                 ; $80E0D4 |
  SEP #$20                                  ; $80E0D6 |
  LDA.B $91                                 ; $80E0D8 |
  CMP.B $86                                 ; $80E0DA |
  BCS CODE_80E0F2                           ; $80E0DC |
  REP #$20                                  ; $80E0DE |
  JSR.W CODE_FN_80DEDF                      ; $80E0E0 |
  LDA.B $B2                                 ; $80E0E3 |
  EOR.W #$0400                              ; $80E0E5 |
  AND.W #$0F80                              ; $80E0E8 |
  STA.B $B2                                 ; $80E0EB |
  JSR.W CODE_FN_80DBF4                      ; $80E0ED |
  BRA CODE_80E092                           ; $80E0F0 |


CODE_80E0F2:
  STZ.B $98                                 ; $80E0F2 |
  REP #$20                                  ; $80E0F4 |
  LDA.W #$0000                              ; $80E0F6 |
  TCD                                       ; $80E0F9 |
  RTS                                       ; $80E0FA |


CODE_80E0FB:
  STZ.B $98                                 ; $80E0FB |
  LDA.W #$0000                              ; $80E0FD |
  TCD                                       ; $80E100 |
  RTS                                       ; $80E101 |


CODE_80E102:
  LDA.B $B0                                 ; $80E102 |
  STA.B $94                                 ; $80E104 |
  LDA.B $B2                                 ; $80E106 |
  STA.B $96                                 ; $80E108 |
  LDA.W #$0000                              ; $80E10A |
  TCD                                       ; $80E10D |
  RTS                                       ; $80E10E |


CODE_FN_80E10F:
  PEA.W $7E00                               ; $80E10F |
  PLB                                       ; $80E112 |
  PLB                                       ; $80E113 |
  LDY.W $19D0                               ; $80E114 |
  LDA.B $B0                                 ; $80E117 |
  STA.W $0000,Y                             ; $80E119 |
  ADC.W #$0008                              ; $80E11C |
  STA.W $0004,Y                             ; $80E11F |
  ADC.W #$0008                              ; $80E122 |
  STA.W $0008,Y                             ; $80E125 |
  ADC.W #$0008                              ; $80E128 |
  STA.B $B0                                 ; $80E12B |
  STA.W $000C,Y                             ; $80E12D |
  LDA.B $B2                                 ; $80E130 |
  STA.W $0002,Y                             ; $80E132 |
  ADC.W #$0020                              ; $80E135 |
  STA.W $0006,Y                             ; $80E138 |
  ADC.W #$0020                              ; $80E13B |
  STA.W $000A,Y                             ; $80E13E |
  ADC.W #$0020                              ; $80E141 |
  STA.B $B2                                 ; $80E144 |
  STA.W $000E,Y                             ; $80E146 |
  TYA                                       ; $80E149 |
  ADC.W #$0010                              ; $80E14A |
  STA.W $19D0                               ; $80E14D |
  PEA.W $8100                               ; $80E150 |
  PLB                                       ; $80E153 |
  PLB                                       ; $80E154 |
  RTS                                       ; $80E155 |


CODE_FN_80E156:
  LDA.W #$1660                              ; $80E156 |
  TCD                                       ; $80E159 |
  STZ.B $EC                                 ; $80E15A |
  STZ.B $EE                                 ; $80E15C |
  LDA.B $06                                 ; $80E15E |
  BNE CODE_80E165                           ; $80E160 |
  JMP.W CODE_JP_80E1FD                      ; $80E162 |


CODE_80E165:
  CLC                                       ; $80E165 |
  BMI CODE_80E189                           ; $80E166 |
  ADC.B $02                                 ; $80E168 |
  STA.B $02                                 ; $80E16A |
  JSR.W CODE_FN_80DDF3                      ; $80E16C |
  LDA.B $82                                 ; $80E16F |
  CLC                                       ; $80E171 |
  ADC.B $EC                                 ; $80E172 |
  STA.B $82                                 ; $80E174 |
  BMI CODE_80E185                           ; $80E176 |
  SEC                                       ; $80E178 |
  SBC.B #$20                                ; $80E179 |
  STA.B $82                                 ; $80E17B |
  LDA.B $84                                 ; $80E17D |
  AND.B #$0C                                ; $80E17F |
  ORA.B #$01                                ; $80E181 |
  STA.B $84                                 ; $80E183 |

CODE_80E185:
  REP #$20                                  ; $80E185 |
  BRA CODE_JP_80E1FD                        ; $80E187 |


CODE_80E189:
  ADC.B $02                                 ; $80E189 |
  STA.B $02                                 ; $80E18B |
  JSR.W CODE_FN_80DDF7                      ; $80E18D |

  LDA.B $82                                 ; $80E190 |
  CLC                                       ; $80E192 |
  ADC.B $EC                                 ; $80E193 |
  STA.B $82                                 ; $80E195 |
  CMP.B #$E0                                ; $80E197 |
  BCS CODE_80E1A8                           ; $80E199 |
  CLC                                       ; $80E19B |
  ADC.B #$20                                ; $80E19C |
  STA.B $82                                 ; $80E19E |
  LDA.B $84                                 ; $80E1A0 |
  AND.B #$0C                                ; $80E1A2 |
  ORA.B #$02                                ; $80E1A4 |
  STA.B $84                                 ; $80E1A6 |

CODE_80E1A8:
  REP #$20                                  ; $80E1A8 |
  BRA CODE_JP_80E1FD                        ; $80E1AA |


CODE_FN_80E1AC:
  LDA.W #$1660                              ; $80E1AC |
  TCD                                       ; $80E1AF |
  STZ.B $EC                                 ; $80E1B0 |
  STZ.B $EE                                 ; $80E1B2 |
  LDA.B $06                                 ; $80E1B4 |
  BEQ CODE_JP_80E1FD                        ; $80E1B6 |
  CLC                                       ; $80E1B8 |
  BMI CODE_80E1DC                           ; $80E1B9 |
  ADC.B $02                                 ; $80E1BB |
  STA.B $02                                 ; $80E1BD |
  JSR.W CODE_FN_80DDFB                      ; $80E1BF |
  LDA.B $82                                 ; $80E1C2 |
  CLC                                       ; $80E1C4 |
  ADC.B $EC                                 ; $80E1C5 |
  STA.B $82                                 ; $80E1C7 |
  BMI CODE_80E1D8                           ; $80E1C9 |
  SEC                                       ; $80E1CB |
  SBC.B #$20                                ; $80E1CC |
  STA.B $82                                 ; $80E1CE |
  LDA.B $84                                 ; $80E1D0 |
  AND.B #$0C                                ; $80E1D2 |
  ORA.B #$01                                ; $80E1D4 |
  STA.B $84                                 ; $80E1D6 |

CODE_80E1D8:
  REP #$20                                  ; $80E1D8 |
  BRA CODE_JP_80E1FD                        ; $80E1DA |


CODE_80E1DC:
  ADC.B $02                                 ; $80E1DC |
  STA.B $02                                 ; $80E1DE |
  JSR.W CODE_FN_80DE2A                      ; $80E1E0 |
  LDA.B $82                                 ; $80E1E3 |
  CLC                                       ; $80E1E5 |
  ADC.B $EC                                 ; $80E1E6 |
  STA.B $82                                 ; $80E1E8 |
  CMP.B #$E0                                ; $80E1EA |
  BCS CODE_80E1FB                           ; $80E1EC |
  CLC                                       ; $80E1EE |
  ADC.B #$20                                ; $80E1EF |
  STA.B $82                                 ; $80E1F1 |
  LDA.B $84                                 ; $80E1F3 |
  AND.B #$0C                                ; $80E1F5 |
  ORA.B #$02                                ; $80E1F7 |
  STA.B $84                                 ; $80E1F9 |

CODE_80E1FB:
  REP #$20                                  ; $80E1FB |

CODE_JP_80E1FD:
  LDA.B $16                                 ; $80E1FD |
  BEQ CODE_80E260                           ; $80E1FF |
  CLC                                       ; $80E201 |
  BPL CODE_80E225                           ; $80E202 |
  ADC.B $12                                 ; $80E204 |
  STA.B $12                                 ; $80E206 |
  JSR.W CODE_FN_80DE8F                      ; $80E208 |
  LDA.B $83                                 ; $80E20B |
  CLC                                       ; $80E20D |
  ADC.B $EE                                 ; $80E20E |
  STA.B $83                                 ; $80E210 |
  CMP.B #$E0                                ; $80E212 |
  BCS CODE_80E242                           ; $80E214 |
  CLC                                       ; $80E216 |
  ADC.B #$20                                ; $80E217 |
  STA.B $83                                 ; $80E219 |
  LDA.B $84                                 ; $80E21B |
  AND.B #$03                                ; $80E21D |
  ORA.B #$08                                ; $80E21F |
  STA.B $84                                 ; $80E221 |
  BRA CODE_80E242                           ; $80E223 |


CODE_80E225:
  ADC.B $12                                 ; $80E225 |
  STA.B $12                                 ; $80E227 |
  JSR.W CODE_FN_80DE60                      ; $80E229 |
  LDA.B $83                                 ; $80E22C |
  CLC                                       ; $80E22E |
  ADC.B $EE                                 ; $80E22F |
  STA.B $83                                 ; $80E231 |
  BMI CODE_80E242                           ; $80E233 |
  SEC                                       ; $80E235 |
  SBC.B #$20                                ; $80E236 |
  STA.B $83                                 ; $80E238 |
  LDA.B $84                                 ; $80E23A |
  AND.B #$03                                ; $80E23C |
  ORA.B #$04                                ; $80E23E |
  STA.B $84                                 ; $80E240 |

CODE_80E242:
  LDA.B $98                                 ; $80E242 |
  BEQ CODE_80E266                           ; $80E244 |
  LDA.B $84                                 ; $80E246 |
  BEQ CODE_80E254                           ; $80E248 |
  BIT.B #$0C                                ; $80E24A |
  BNE CODE_80E257                           ; $80E24C |
  LDA.B $85                                 ; $80E24E |
  AND.B #$03                                ; $80E250 |
  BNE CODE_80E264                           ; $80E252 |

CODE_80E254:
  JMP.W CODE_JP_80E010                      ; $80E254 |


CODE_80E257:
  LDA.B $85                                 ; $80E257 |
  AND.B #$0C                                ; $80E259 |
  BNE CODE_80E264                           ; $80E25B |
  JMP.W CODE_JP_80E010                      ; $80E25D |


CODE_80E260:
  SEP #$20                                  ; $80E260 |
  BRA CODE_80E242                           ; $80E262 |


CODE_80E264:
  STZ.B $98                                 ; $80E264 |

CODE_80E266:
  LDA.B $85                                 ; $80E266 |
  AND.B #$03                                ; $80E268 |
  BNE CODE_80E27F                           ; $80E26A |
  LDA.B $84                                 ; $80E26C |
  AND.B #$03                                ; $80E26E |
  BNE CODE_80E292                           ; $80E270 |
  LDA.B $84                                 ; $80E272 |
  AND.B #$0C                                ; $80E274 |
  BNE CODE_80E29F                           ; $80E276 |
  REP #$20                                  ; $80E278 |
  LDA.W #$0000                              ; $80E27A |
  TCD                                       ; $80E27D |
  RTS                                       ; $80E27E |


CODE_80E27F:
  LDA.B $84                                 ; $80E27F |
  AND.B #$0C                                ; $80E281 |
  BNE CODE_80E29F                           ; $80E283 |
  LDA.B $84                                 ; $80E285 |
  AND.B #$03                                ; $80E287 |
  BNE CODE_80E292                           ; $80E289 |
  REP #$20                                  ; $80E28B |
  LDA.W #$0000                              ; $80E28D |
  TCD                                       ; $80E290 |
  RTS                                       ; $80E291 |


CODE_80E292:
  STA.B $85                                 ; $80E292 |
  LDA.B $84                                 ; $80E294 |
  AND.B #$0C                                ; $80E296 |
  STA.B $84                                 ; $80E298 |
  INC.B $98                                 ; $80E29A |
  JMP.W CODE_JP_80DF2E                      ; $80E29C |


CODE_80E29F:
  STA.B $85                                 ; $80E29F |
  LDA.B $84                                 ; $80E2A1 |
  AND.B #$03                                ; $80E2A3 |
  STA.B $84                                 ; $80E2A5 |
  INC.B $98                                 ; $80E2A7 |
  JMP.W CODE_JP_80E029                      ; $80E2A9 |

  LDA.B $8C                                 ; $80E2AC |
  SEP #$20                                  ; $80E2AE |
  XBA                                       ; $80E2B0 |
  REP #$20                                  ; $80E2B1 |
  LSR A                                     ; $80E2B3 |

  STA.B $C2                                 ; $80E2B4 |
  SEP #$20                                  ; $80E2B6 |
  LDA.B $90                                 ; $80E2B8 |
  LSR A                                     ; $80E2BA |
  LSR A                                     ; $80E2BB |
  LSR A                                     ; $80E2BC |
  LSR A                                     ; $80E2BD |
  LSR A                                     ; $80E2BE |
  ASL A                                     ; $80E2BF |
  STA.B $C0                                 ; $80E2C0 |
  LDA.B $92                                 ; $80E2C2 |

  AND.B #$E0                                ; $80E2C4 |

  LSR A                                     ; $80E2C6 |
  CLC                                       ; $80E2C7 |
  ADC.B $C0                                 ; $80E2C8 |
  STA.B $C0                                 ; $80E2CA |
  STZ.B $C1                                 ; $80E2CC |
  REP #$20                                  ; $80E2CE |
  LDA.B $C0                                 ; $80E2D0 |
  ADC.B $C2                                 ; $80E2D2 |
  STA.B $8A                                 ; $80E2D4 |
  RTS                                       ; $80E2D6 |


CODE_JP_80E2D7:
  REP #$20                                  ; $80E2D7 |
  INC.B $E6                                 ; $80E2D9 |
  LDA.B $22                                 ; $80E2DB |
  SEC                                       ; $80E2DD |
  SBC.W #$0021                              ; $80E2DE |
  STA.B $B6                                 ; $80E2E1 |
  BMI CODE_80E35E                           ; $80E2E3 |
  BRA CODE_80E2FD                           ; $80E2E5 |


CODE_JP_80E2E7:
  REP #$20                                  ; $80E2E7 |
  INC.B $E6                                 ; $80E2E9 |
  LDA.B $22                                 ; $80E2EB |
  CLC                                       ; $80E2ED |
  ADC.W #$011F                              ; $80E2EE |
  STA.B $B6                                 ; $80E2F1 |
  SEP #$20                                  ; $80E2F3 |
  LDA.B $B7                                 ; $80E2F5 |
  CMP.B $D4                                 ; $80E2F7 |
  BCS CODE_80E355                           ; $80E2F9 |
  REP #$20                                  ; $80E2FB |

CODE_80E2FD:
  LDY.W #$0004                              ; $80E2FD |
  STY.B $DC                                 ; $80E300 |
  JSR.W CODE_FN_80E3E5                      ; $80E302 |
  JSR.W CODE_FN_80E443                      ; $80E305 |

CODE_80E308:
  LDX.B $D8                                 ; $80E308 |
  LDA.L $7FF000,X                           ; $80E30A |
  AND.W #$00FF                              ; $80E30E |
  JSR.W CODE_FN_80E478                      ; $80E311 |
  JSR.W CODE_FN_80E483                      ; $80E314 |
  LDA.B $B2                                 ; $80E317 |
  CLC                                       ; $80E319 |
  ADC.W #$0020                              ; $80E31A |
  STA.B $B2                                 ; $80E31D |
  LDA.B $D8                                 ; $80E31F |
  CLC                                       ; $80E321 |
  ADC.W #$0008                              ; $80E322 |
  STA.B $D8                                 ; $80E325 |
  TAX                                       ; $80E327 |
  LDA.L $7FF000,X                           ; $80E328 |
  AND.W #$00FF                              ; $80E32C |
  JSR.W CODE_FN_80E478                      ; $80E32F |
  JSR.W CODE_FN_80E483                      ; $80E332 |
  DEC.B $DC                                 ; $80E335 |
  BEQ CODE_80E35E                           ; $80E337 |
  LDA.B $B2                                 ; $80E339 |
  STA.B $E4                                 ; $80E33B |
  LDA.W #$0000                              ; $80E33D |
  TCD                                       ; $80E340 |
  RTL                                       ; $80E341 |


CODE_JP_80E342:
  REP #$20                                  ; $80E342 |

CODE_JP_80E344:
  LDA.B $D8                                 ; $80E344 |
  CLC                                       ; $80E346 |
  ADC.W #$0008                              ; $80E347 |
  STA.B $D8                                 ; $80E34A |
  LDA.B $E4                                 ; $80E34C |
  ADC.W #$0020                              ; $80E34E |
  STA.B $B2                                 ; $80E351 |
  BRA CODE_80E308                           ; $80E353 |


CODE_80E355:
  STZ.B $E6                                 ; $80E355 |
  REP #$20                                  ; $80E357 |
  LDA.W #$0000                              ; $80E359 |
  TCD                                       ; $80E35C |
  RTL                                       ; $80E35D |


CODE_80E35E:
  STZ.B $E6                                 ; $80E35E |
  LDA.W #$0000                              ; $80E360 |
  TCD                                       ; $80E363 |
  RTL                                       ; $80E364 |


CODE_JP_80E365:
  REP #$20                                  ; $80E365 |
  INC.B $E6                                 ; $80E367 |
  LDA.B $32                                 ; $80E369 |
  SEC                                       ; $80E36B |
  SBC.W #$0021                              ; $80E36C |
  STA.B $B6                                 ; $80E36F |
  BMI CODE_80E35E                           ; $80E371 |
  BRA CODE_80E38B                           ; $80E373 |


CODE_JP_80E375:
  REP #$20                                  ; $80E375 |
  INC.B $E6                                 ; $80E377 |
  LDA.B $32                                 ; $80E379 |
  CLC                                       ; $80E37B |
  ADC.W #$011F                              ; $80E37C |
  STA.B $B6                                 ; $80E37F |
  SEP #$20                                  ; $80E381 |
  LDA.B $B7                                 ; $80E383 |
  CMP.B $D6                                 ; $80E385 |
  BCS CODE_80E355                           ; $80E387 |
  REP #$20                                  ; $80E389 |

CODE_80E38B:
  LDY.W #$0004                              ; $80E38B |
  STY.B $DC                                 ; $80E38E |
  JSR.W CODE_FN_80E415                      ; $80E390 |
  JSR.W CODE_FN_80E45B                      ; $80E393 |

CODE_80E396:
  LDX.B $D8                                 ; $80E396 |
  LDA.L $7FF000,X                           ; $80E398 |
  AND.W #$00FF                              ; $80E39C |
  JSR.W CODE_FN_80E478                      ; $80E39F |
  JSR.W CODE_FN_80E483                      ; $80E3A2 |
  SEP #$20                                  ; $80E3A5 |
  LDA.B $B2                                 ; $80E3A7 |
  AND.B #$9F                                ; $80E3A9 |
  CLC                                       ; $80E3AB |
  ADC.B #$04                                ; $80E3AC |
  STA.B $B2                                 ; $80E3AE |
  REP #$20                                  ; $80E3B0 |
  INC.B $D8                                 ; $80E3B2 |
  LDX.B $D8                                 ; $80E3B4 |
  LDA.L $7FF000,X                           ; $80E3B6 |
  AND.W #$00FF                              ; $80E3BA |
  JSR.W CODE_FN_80E478                      ; $80E3BD |
  JSR.W CODE_FN_80E483                      ; $80E3C0 |
  DEC.B $DC                                 ; $80E3C3 |
  BEQ CODE_80E35E                           ; $80E3C5 |
  LDA.B $B2                                 ; $80E3C7 |
  STA.B $E4                                 ; $80E3C9 |
  LDA.W #$0000                              ; $80E3CB |
  TCD                                       ; $80E3CE |
  RTL                                       ; $80E3CF |


CODE_JP_80E3D0:
  SEP #$20                                  ; $80E3D0 |

CODE_JP_80E3D2:
  LDA.B $E5                                 ; $80E3D2 |
  STA.B $B3                                 ; $80E3D4 |
  LDA.B $E4                                 ; $80E3D6 |
  AND.W #$189F                              ; $80E3D8 |
  ADC.W #$8504                              ; $80E3DB |
  LDA.B ($C2)                               ; $80E3DE |
  JSR.W CODE_FN_80D8E6                      ; $80E3E0 |
  BRA CODE_80E396                           ; $80E3E3 |


CODE_FN_80E3E5:
  LDA.B $9D                                 ; $80E3E5 |
  STA.B $C0                                 ; $80E3E7 |
  SEP #$20                                  ; $80E3E9 |
  SEP #$10                                  ; $80E3EB |
  LDA.B $9F                                 ; $80E3ED |
  STA.B $C2                                 ; $80E3EF |
  LDY.B $B7                                 ; $80E3F1 |
  LDA.B [$C0],Y                             ; $80E3F3 |
  STA.B $C1                                 ; $80E3F5 |
  STZ.B $C0                                 ; $80E3F7 |
  LSR.B $C1                                 ; $80E3F9 |
  ROR.B $C0                                 ; $80E3FB |
  LSR.B $C1                                 ; $80E3FD |
  ROR.B $C0                                 ; $80E3FF |
  LDA.B $B6                                 ; $80E401 |
  LSR A                                     ; $80E403 |
  LSR A                                     ; $80E404 |
  LSR A                                     ; $80E405 |
  LSR A                                     ; $80E406 |
  LSR A                                     ; $80E407 |
  REP #$20                                  ; $80E408 |
  REP #$10                                  ; $80E40A |
  AND.W #$00FF                              ; $80E40C |
  CLC                                       ; $80E40F |
  ADC.B $C0                                 ; $80E410 |
  STA.B $D8                                 ; $80E412 |
  RTS                                       ; $80E414 |


CODE_FN_80E415:
  LDA.B $9D                                 ; $80E415 |
  STA.B $C0                                 ; $80E417 |
  SEP #$20                                  ; $80E419 |
  SEP #$10                                  ; $80E41B |
  LDA.B $9F                                 ; $80E41D |
  STA.B $C2                                 ; $80E41F |
  LDY.B $B7                                 ; $80E421 |
  LDA.B [$C0],Y                             ; $80E423 |
  STA.B $C1                                 ; $80E425 |
  STZ.B $C0                                 ; $80E427 |
  LSR.B $C1                                 ; $80E429 |
  ROR.B $C0                                 ; $80E42B |
  LSR.B $C1                                 ; $80E42D |
  ROR.B $C0                                 ; $80E42F |
  LDA.B $B6                                 ; $80E431 |
  AND.B #$E0                                ; $80E433 |
  LSR A                                     ; $80E435 |
  LSR A                                     ; $80E436 |
  REP #$20                                  ; $80E437 |
  REP #$10                                  ; $80E439 |
  AND.W #$00FF                              ; $80E43B |
  ADC.B $C0                                 ; $80E43E |
  STA.B $D8                                 ; $80E440 |
  RTS                                       ; $80E442 |


CODE_FN_80E443:
  SEP #$20                                  ; $80E443 |
  LDA.B $B6                                 ; $80E445 |
  AND.B #$E0                                ; $80E447 |
  LSR A                                     ; $80E449 |
  LSR A                                     ; $80E44A |
  LSR A                                     ; $80E44B |
  STA.B $B2                                 ; $80E44C |
  LDA.B $B7                                 ; $80E44E |
  AND.B #$01                                ; $80E450 |
  ASL A                                     ; $80E452 |
  ASL A                                     ; $80E453 |
  ORA.B #$10                                ; $80E454 |
  STA.B $B3                                 ; $80E456 |
  REP #$20                                  ; $80E458 |
  RTS                                       ; $80E45A |


CODE_FN_80E45B:
  SEP #$20                                  ; $80E45B |
  LDA.B $B7                                 ; $80E45D |
  AND.B #$01                                ; $80E45F |
  ASL A                                     ; $80E461 |
  ASL A                                     ; $80E462 |
  ASL A                                     ; $80E463 |
  ORA.B #$10                                ; $80E464 |
  STA.B $B3                                 ; $80E466 |
  STZ.B $B2                                 ; $80E468 |
  REP #$20                                  ; $80E46A |
  LDA.B $B6                                 ; $80E46C |
  AND.W #$00E0                              ; $80E46E |
  ASL A                                     ; $80E471 |
  ASL A                                     ; $80E472 |
  ORA.B $B2                                 ; $80E473 |
  STA.B $B2                                 ; $80E475 |
  RTS                                       ; $80E477 |


CODE_FN_80E478:
  ASL A                                     ; $80E478 |
  ASL A                                     ; $80E479 |
  ASL A                                     ; $80E47A |
  ASL A                                     ; $80E47B |
  ASL A                                     ; $80E47C |
  ADC.W #$D000                              ; $80E47D |
  STA.B $B0                                 ; $80E480 |
  RTS                                       ; $80E482 |


CODE_FN_80E483:
  PEA.W $7E00                               ; $80E483 |
  PLB                                       ; $80E486 |
  PLB                                       ; $80E487 |
  LDX.W $19D0                               ; $80E488 |
  LDY.W #$0004                              ; $80E48B |
  CLC                                       ; $80E48E |

CODE_80E48F:
  LDA.B $B0                                 ; $80E48F |
  STA.W $0000,X                             ; $80E491 |
  LDA.B $B2                                 ; $80E494 |
  STA.W $0002,X                             ; $80E496 |
  TXA                                       ; $80E499 |
  ADC.W #$0004                              ; $80E49A |
  DEY                                       ; $80E49D |
  BEQ CODE_80E4B1                           ; $80E49E |
  TAX                                       ; $80E4A0 |
  LDA.B $B0                                 ; $80E4A1 |
  ADC.W #$0008                              ; $80E4A3 |
  STA.B $B0                                 ; $80E4A6 |
  LDA.B $B2                                 ; $80E4A8 |
  ADC.W #$0020                              ; $80E4AA |
  STA.B $B2                                 ; $80E4AD |
  BRA CODE_80E48F                           ; $80E4AF |


CODE_80E4B1:
  STA.W $19D0                               ; $80E4B1 |
  PEA.W $8100                               ; $80E4B4 |
  PLB                                       ; $80E4B7 |
  PLB                                       ; $80E4B8 |
  RTS                                       ; $80E4B9 |


CODE_80E4BA:
  RTL                                       ; $80E4BA |


CODE_FL_80E4BB:
  LDA.W $1752                               ; $80E4BB |
  BEQ CODE_80E4BA                           ; $80E4BE |
  LDA.W #$1660                              ; $80E4C0 |
  TCD                                       ; $80E4C3 |
  LDA.B $F2                                 ; $80E4C4 |
  AND.W #$0003                              ; $80E4C6 |
  BEQ CODE_80E53B                           ; $80E4C9 |
  SEP #$20                                  ; $80E4CB |
  LDA.W $0093                               ; $80E4CD |
  BIT.B #$40                                ; $80E4D0 |
  BNE CODE_80E4DF                           ; $80E4D2 |
  BIT.B #$80                                ; $80E4D4 |
  BEQ CODE_80E4EA                           ; $80E4D6 |
  REP #$20                                  ; $80E4D8 |

CODE_80E4DA:
  LDA.W $1964                               ; $80E4DA |
  BRA CODE_80E50D                           ; $80E4DD |


CODE_80E4DF:
  REP #$20                                  ; $80E4DF |
  LDA.B $EC                                 ; $80E4E1 |
  AND.W #$00FF                              ; $80E4E3 |
  BEQ CODE_80E4DA                           ; $80E4E6 |
  SEP #$20                                  ; $80E4E8 |

CODE_80E4EA:
  LDA.B $EC                                 ; $80E4EA |
  BEQ CODE_80E539                           ; $80E4EC |
  BPL CODE_80E4F5                           ; $80E4EE |
  EOR.B #$FF                                ; $80E4F0 |
  INC A                                     ; $80E4F2 |
  ORA.B #$08                                ; $80E4F3 |

CODE_80E4F5:
  ASL A                                     ; $80E4F5 |
  TAX                                       ; $80E4F6 |
  REP #$20                                  ; $80E4F7 |
  LDA.W $0093                               ; $80E4F9 |

  BIT.W #$0040                              ; $80E4FC |
  BEQ CODE_80E50A                           ; $80E4FF |
  LDA.W $1964                               ; $80E501 |
  CLC                                       ; $80E504 |
  ADC.W $17DE,X                             ; $80E505 |
  BRA CODE_80E50D                           ; $80E508 |


CODE_80E50A:
  LDA.W $17DE,X                             ; $80E50A |

CODE_80E50D:
  CLC                                       ; $80E50D |
  ADC.B $E8                                 ; $80E50E |
  STA.B $E8                                 ; $80E510 |
  BPL CODE_80E520                           ; $80E512 |
  SEP #$20                                  ; $80E514 |
  LDA.B $E9                                 ; $80E516 |
  STA.B $26                                 ; $80E518 |
  LDA.B #$FF                                ; $80E51A |
  STA.B $27                                 ; $80E51C |
  BRA CODE_80E527                           ; $80E51E |


CODE_80E520:
  SEP #$20                                  ; $80E520 |
  XBA                                       ; $80E522 |
  BEQ CODE_80E539                           ; $80E523 |
  STA.B $26                                 ; $80E525 |

CODE_80E527:
  STZ.B $E9                                 ; $80E527 |
  REP #$20                                  ; $80E529 |
  LDA.B $F2                                 ; $80E52B |
  AND.W #$0030                              ; $80E52D |
  BNE CODE_80E53B                           ; $80E530 |
  LDA.B $26                                 ; $80E532 |
  CLC                                       ; $80E534 |
  ADC.B $22                                 ; $80E535 |
  STA.B $22                                 ; $80E537 |

CODE_80E539:
  REP #$20                                  ; $80E539 |

CODE_80E53B:
  LDA.B $F2                                 ; $80E53B |
  AND.W #$000C                              ; $80E53D |
  BEQ CODE_80E5B2                           ; $80E540 |
  SEP #$20                                  ; $80E542 |
  LDA.W $0093                               ; $80E544 |
  BIT.B #$10                                ; $80E547 |
  BNE CODE_80E556                           ; $80E549 |
  BIT.B #$20                                ; $80E54B |
  BEQ CODE_80E561                           ; $80E54D |
  REP #$20                                  ; $80E54F |

CODE_80E551:
  LDA.W $1966                               ; $80E551 |
  BRA CODE_80E584                           ; $80E554 |


CODE_80E556:
  REP #$20                                  ; $80E556 |
  LDA.B $EE                                 ; $80E558 |
  AND.W #$00FF                              ; $80E55A |
  BEQ CODE_80E551                           ; $80E55D |
  SEP #$20                                  ; $80E55F |

CODE_80E561:
  LDA.B $EE                                 ; $80E561 |
  BEQ CODE_80E5B0                           ; $80E563 |
  BPL CODE_80E56C                           ; $80E565 |
  EOR.B #$FF                                ; $80E567 |
  INC A                                     ; $80E569 |
  ORA.B #$08                                ; $80E56A |

CODE_80E56C:
  ASL A                                     ; $80E56C |
  TAX                                       ; $80E56D |
  REP #$20                                  ; $80E56E |
  LDA.W $0093                               ; $80E570 |
  BIT.W #$0010                              ; $80E573 |
  BEQ CODE_80E581                           ; $80E576 |
  LDA.W $1966                               ; $80E578 |
  CLC                                       ; $80E57B |
  ADC.W $17FE,X                             ; $80E57C |
  BRA CODE_80E584                           ; $80E57F |


CODE_80E581:
  LDA.W $17FE,X                             ; $80E581 |

CODE_80E584:
  CLC                                       ; $80E584 |
  ADC.B $EA                                 ; $80E585 |
  STA.B $EA                                 ; $80E587 |
  BPL CODE_80E597                           ; $80E589 |
  SEP #$20                                  ; $80E58B |
  LDA.B $EB                                 ; $80E58D |
  STA.B $36                                 ; $80E58F |
  LDA.B #$FF                                ; $80E591 |
  STA.B $37                                 ; $80E593 |
  BRA CODE_80E59E                           ; $80E595 |


CODE_80E597:
  SEP #$20                                  ; $80E597 |
  XBA                                       ; $80E599 |
  BEQ CODE_80E5B0                           ; $80E59A |
  STA.B $36                                 ; $80E59C |

CODE_80E59E:
  STZ.B $EB                                 ; $80E59E |
  REP #$20                                  ; $80E5A0 |
  LDA.B $F2                                 ; $80E5A2 |
  AND.W #$00C0                              ; $80E5A4 |
  BNE CODE_80E5B2                           ; $80E5A7 |
  LDA.B $36                                 ; $80E5A9 |
  CLC                                       ; $80E5AB |
  ADC.B $32                                 ; $80E5AC |
  STA.B $32                                 ; $80E5AE |

CODE_80E5B0:
  REP #$20                                  ; $80E5B0 |

CODE_80E5B2:
  LDA.B $F2                                 ; $80E5B2 |
  AND.W #$00FF                              ; $80E5B4 |
  CMP.W #$00F0                              ; $80E5B7 |
  BCC CODE_80E5C5                           ; $80E5BA |
  JMP.W CODE_JP_80E880                      ; $80E5BC |


CODE_FL_80E5BF:
  LDA.W #$1660                              ; $80E5BF |
  TCD                                       ; $80E5C2 |
  BRA CODE_80E5B2                           ; $80E5C3 |


CODE_80E5C5:
  BIT.W #$0030                              ; $80E5C5 |
  BEQ CODE_80E624                           ; $80E5C8 |
  LDA.B $26                                 ; $80E5CA |
  BEQ CODE_80E601                           ; $80E5CC |
  BMI CODE_80E5E8                           ; $80E5CE |
  CLC                                       ; $80E5D0 |
  ADC.B $22                                 ; $80E5D1 |
  STA.B $22                                 ; $80E5D3 |
  SEP #$20                                  ; $80E5D5 |
  LDA.B $D0                                 ; $80E5D7 |
  CLC                                       ; $80E5D9 |
  ADC.B $26                                 ; $80E5DA |
  STA.B $D0                                 ; $80E5DC |
  BMI CODE_80E608                           ; $80E5DE |
  SEC                                       ; $80E5E0 |
  SBC.B #$20                                ; $80E5E1 |
  STA.B $D0                                 ; $80E5E3 |
  JMP.W CODE_JP_80E2E7                      ; $80E5E5 |


CODE_80E5E8:
  CLC                                       ; $80E5E8 |
  ADC.B $22                                 ; $80E5E9 |
  STA.B $22                                 ; $80E5EB |
  SEP #$20                                  ; $80E5ED |
  LDA.B $D0                                 ; $80E5EF |
  CLC                                       ; $80E5F1 |
  ADC.B $26                                 ; $80E5F2 |
  STA.B $D0                                 ; $80E5F4 |
  CMP.B #$E0                                ; $80E5F6 |
  BCS CODE_80E608                           ; $80E5F8 |
  ADC.B #$20                                ; $80E5FA |
  STA.B $D0                                 ; $80E5FC |
  JMP.W CODE_JP_80E2D7                      ; $80E5FE |


CODE_80E601:
  LDA.B $E6                                 ; $80E601 |
  BEQ CODE_80E611                           ; $80E603 |
  JMP.W CODE_JP_80E344                      ; $80E605 |


CODE_80E608:
  LDA.B $E6                                 ; $80E608 |
  BEQ CODE_80E60F                           ; $80E60A |
  JMP.W CODE_JP_80E342                      ; $80E60C |


CODE_80E60F:
  REP #$20                                  ; $80E60F |

CODE_80E611:
  LDA.W #$0000                              ; $80E611 |
  TCD                                       ; $80E614 |
  RTL                                       ; $80E615 |


CODE_80E616:
  LDA.B $E6                                 ; $80E616 |
  BEQ CODE_80E611                           ; $80E618 |
  JMP.W CODE_JP_80E3D0                      ; $80E61A |


CODE_80E61D:
  LDA.B $E6                                 ; $80E61D |
  BEQ CODE_80E60F                           ; $80E61F |
  JMP.W CODE_JP_80E3D2                      ; $80E621 |


CODE_80E624:
  BIT.W #$00C0                              ; $80E624 |
  BEQ CODE_80E611                           ; $80E627 |
  LDA.B $36                                 ; $80E629 |
  BEQ CODE_80E616                           ; $80E62B |
  BMI CODE_80E647                           ; $80E62D |
  CLC                                       ; $80E62F |
  ADC.B $32                                 ; $80E630 |
  STA.B $32                                 ; $80E632 |
  SEP #$20                                  ; $80E634 |
  LDA.B $D1                                 ; $80E636 |
  CLC                                       ; $80E638 |
  ADC.B $36                                 ; $80E639 |
  STA.B $D1                                 ; $80E63B |
  BMI CODE_80E61D                           ; $80E63D |
  SEC                                       ; $80E63F |
  SBC.B #$20                                ; $80E640 |
  STA.B $D1                                 ; $80E642 |
  JMP.W CODE_JP_80E375                      ; $80E644 |


CODE_80E647:
  CLC                                       ; $80E647 |
  ADC.B $32                                 ; $80E648 |
  STA.B $32                                 ; $80E64A |
  SEP #$20                                  ; $80E64C |
  LDA.B $D1                                 ; $80E64E |
  CLC                                       ; $80E650 |
  ADC.B $36                                 ; $80E651 |
  STA.B $D1                                 ; $80E653 |
  CMP.B #$E0                                ; $80E655 |
  BCS CODE_80E61D                           ; $80E657 |
  CLC                                       ; $80E659 |
  ADC.B #$20                                ; $80E65A |
  STA.B $D1                                 ; $80E65C |
  JMP.W CODE_JP_80E365                      ; $80E65E |


CODE_JP_80E661:
  LDA.B $D3                                 ; $80E661 |
  LSR A                                     ; $80E663 |
  BCS CODE_80E682                           ; $80E664 |
  REP #$20                                  ; $80E666 |
  LDA.B $22                                 ; $80E668 |
  SEC                                       ; $80E66A |
  SBC.W #$0041                              ; $80E66B |
  STA.B $DE                                 ; $80E66E |
  BPL CODE_80E696                           ; $80E670 |
  STZ.B $E6                                 ; $80E672 |
  LDA.W #$0000                              ; $80E674 |
  TCD                                       ; $80E677 |
  RTL                                       ; $80E678 |


CODE_80E679:
  STZ.B $E6                                 ; $80E679 |
  REP #$20                                  ; $80E67B |
  LDA.W #$0000                              ; $80E67D |
  TCD                                       ; $80E680 |
  RTL                                       ; $80E681 |


CODE_80E682:
  REP #$20                                  ; $80E682 |
  LDA.B $22                                 ; $80E684 |
  CLC                                       ; $80E686 |
  ADC.W #$013F                              ; $80E687 |
  STA.B $DE                                 ; $80E68A |
  SEP #$20                                  ; $80E68C |
  LDA.B $DF                                 ; $80E68E |
  CMP.B $D4                                 ; $80E690 |
  BCS CODE_80E679                           ; $80E692 |

  REP #$20                                  ; $80E694 |

CODE_80E696:
  LDY.W #$000D                              ; $80E696 |
  LDA.B $32                                 ; $80E699 |
  SEC                                       ; $80E69B |
  SBC.W #$0041                              ; $80E69C |
  BPL CODE_80E6B1                           ; $80E69F |
  DEY                                       ; $80E6A1 |
  CMP.W #$FFE0                              ; $80E6A2 |
  BCS CODE_80E6AE                           ; $80E6A5 |
  DEY                                       ; $80E6A7 |
  CMP.W #$FFC0                              ; $80E6A8 |
  BCS CODE_80E6AE                           ; $80E6AB |
  DEY                                       ; $80E6AD |

CODE_80E6AE:
  LDA.W #$0000                              ; $80E6AE |

CODE_80E6B1:
  STA.B $E0                                 ; $80E6B1 |
  STY.B $DC                                 ; $80E6B3 |
  LDA.W #$0003                              ; $80E6B5 |
  STA.B $A0                                 ; $80E6B8 |
  JSR.W CODE_FN_80E972                      ; $80E6BA |
  JSR.W CODE_FN_80E826                      ; $80E6BD |
  JSR.W CODE_FN_80E854                      ; $80E6C0 |

CODE_80E6C3:
  LDX.B $D8                                 ; $80E6C3 |
  LDA.L $7FF000,X                           ; $80E6C5 |
  AND.W #$00FF                              ; $80E6C9 |
  JSR.W CODE_FN_80E478                      ; $80E6CC |
  JSR.W CODE_FN_80E483                      ; $80E6CF |
  DEC.B $DC                                 ; $80E6D2 |
  BEQ CODE_80E720                           ; $80E6D4 |
  DEC.B $A0                                 ; $80E6D6 |
  BEQ CODE_80E727                           ; $80E6D8 |

CODE_80E6DA:
  LDA.B $D8                                 ; $80E6DA |
  CLC                                       ; $80E6DC |
  ADC.W #$0008                              ; $80E6DD |
  STA.B $D8                                 ; $80E6E0 |
  AND.W #$0038                              ; $80E6E2 |
  BEQ CODE_80E6F0                           ; $80E6E5 |
  LDA.B $B2                                 ; $80E6E7 |
  ADC.W #$0020                              ; $80E6E9 |
  STA.B $B2                                 ; $80E6EC |
  BRA CODE_80E6C3                           ; $80E6EE |


CODE_80E6F0:
  LDA.B $E0                                 ; $80E6F0 |
  CLC                                       ; $80E6F2 |
  ADC.W #$0100                              ; $80E6F3 |
  AND.W #$FF00                              ; $80E6F6 |
  STA.B $E0                                 ; $80E6F9 |
  SEP #$20                                  ; $80E6FB |
  LDA.B $E1                                 ; $80E6FD |
  CMP.B $D6                                 ; $80E6FF |
  BCS CODE_80E717                           ; $80E701 |
  REP #$20                                  ; $80E703 |
  JSR.W CODE_FN_80E972                      ; $80E705 |
  LDA.B $B2                                 ; $80E708 |
  EOR.W #$0800                              ; $80E70A |
  AND.W #$1C1F                              ; $80E70D |
  STA.B $B2                                 ; $80E710 |
  JSR.W CODE_FN_80E854                      ; $80E712 |
  BRA CODE_80E6C3                           ; $80E715 |


CODE_80E717:
  STZ.B $E6                                 ; $80E717 |
  REP #$20                                  ; $80E719 |
  LDA.W #$0000                              ; $80E71B |
  TCD                                       ; $80E71E |
  RTL                                       ; $80E71F |


CODE_80E720:
  STZ.B $E6                                 ; $80E720 |
  LDA.W #$0000                              ; $80E722 |
  TCD                                       ; $80E725 |
  RTL                                       ; $80E726 |


CODE_80E727:
  LDA.B $B0                                 ; $80E727 |
  STA.B $E2                                 ; $80E729 |
  LDA.B $B2                                 ; $80E72B |
  STA.B $E4                                 ; $80E72D |
  LDA.W #$0000                              ; $80E72F |
  TCD                                       ; $80E732 |
  RTL                                       ; $80E733 |


CODE_JP_80E734:
  REP #$20                                  ; $80E734 |
  LDA.B $E2                                 ; $80E736 |
  STA.B $B0                                 ; $80E738 |
  LDA.B $E4                                 ; $80E73A |
  STA.B $B2                                 ; $80E73C |
  LDA.W #$0005                              ; $80E73E |
  STA.B $A0                                 ; $80E741 |
  LDA.B $D3                                 ; $80E743 |
  AND.W #$0003                              ; $80E745 |
  BNE CODE_80E6DA                           ; $80E748 |
  JMP.W CODE_JP_80E7C7                      ; $80E74A |


CODE_JP_80E74D:
  LDA.B $D3                                 ; $80E74D |
  AND.B #$08                                ; $80E74F |
  BEQ CODE_80E76F                           ; $80E751 |
  REP #$20                                  ; $80E753 |
  LDA.B $32                                 ; $80E755 |
  SEC                                       ; $80E757 |
  SBC.W #$0041                              ; $80E758 |
  STA.B $E0                                 ; $80E75B |
  BPL CODE_80E783                           ; $80E75D |
  STZ.B $E6                                 ; $80E75F |
  LDA.W #$0000                              ; $80E761 |
  TCD                                       ; $80E764 |
  RTL                                       ; $80E765 |


CODE_80E766:
  STZ.B $E6                                 ; $80E766 |
  REP #$20                                  ; $80E768 |
  LDA.W #$0000                              ; $80E76A |
  TCD                                       ; $80E76D |
  RTL                                       ; $80E76E |


CODE_80E76F:
  REP #$20                                  ; $80E76F |
  LDA.B $32                                 ; $80E771 |
  CLC                                       ; $80E773 |
  ADC.W #$013F                              ; $80E774 |
  STA.B $E0                                 ; $80E777 |
  SEP #$20                                  ; $80E779 |
  LDA.B $E1                                 ; $80E77B |
  CMP.B $D6                                 ; $80E77D |
  BCS CODE_80E766                           ; $80E77F |
  REP #$20                                  ; $80E781 |

CODE_80E783:
  LDY.W #$000D                              ; $80E783 |
  LDA.B $22                                 ; $80E786 |
  SEC                                       ; $80E788 |
  SBC.W #$0041                              ; $80E789 |
  BPL CODE_80E79E                           ; $80E78C |
  DEY                                       ; $80E78E |
  CMP.W #$FFE0                              ; $80E78F |
  BCS CODE_80E79B                           ; $80E792 |
  DEY                                       ; $80E794 |
  CMP.W #$FFC0                              ; $80E795 |
  BCS CODE_80E79B                           ; $80E798 |
  DEY                                       ; $80E79A |

CODE_80E79B:
  LDA.W #$0000                              ; $80E79B |

CODE_80E79E:
  STA.B $DE                                 ; $80E79E |
  STY.B $DC                                 ; $80E7A0 |
  LDA.W #$0003                              ; $80E7A2 |
  STA.B $A0                                 ; $80E7A5 |
  JSR.W CODE_FN_80E972                      ; $80E7A7 |
  JSR.W CODE_FN_80E826                      ; $80E7AA |
  JSR.W CODE_FN_80E854                      ; $80E7AD |

CODE_80E7B0:
  LDX.B $D8                                 ; $80E7B0 |
  LDA.L $7FF000,X                           ; $80E7B2 |
  AND.W #$00FF                              ; $80E7B6 |
  JSR.W CODE_FN_80E478                      ; $80E7B9 |
  JSR.W CODE_FN_80E483                      ; $80E7BC |
  DEC.B $DC                                 ; $80E7BF |
  BEQ CODE_80E810                           ; $80E7C1 |
  DEC.B $A0                                 ; $80E7C3 |
  BEQ CODE_80E817                           ; $80E7C5 |

CODE_JP_80E7C7:
  LDA.B $D8                                 ; $80E7C7 |
  AND.W #$0007                              ; $80E7C9 |
  CMP.W #$0007                              ; $80E7CC |
  BEQ CODE_80E7E0                           ; $80E7CF |
  INC.B $D8                                 ; $80E7D1 |
  LDA.B $B2                                 ; $80E7D3 |
  AND.W #$FF9F                              ; $80E7D5 |
  CLC                                       ; $80E7D8 |
  ADC.W #$0004                              ; $80E7D9 |
  STA.B $B2                                 ; $80E7DC |
  BRA CODE_80E7B0                           ; $80E7DE |


CODE_80E7E0:
  LDA.B $DE                                 ; $80E7E0 |
  CLC                                       ; $80E7E2 |
  ADC.W #$0100                              ; $80E7E3 |
  AND.W #$FF00                              ; $80E7E6 |
  STA.B $DE                                 ; $80E7E9 |
  SEP #$20                                  ; $80E7EB |
  LDA.B $DF                                 ; $80E7ED |
  CMP.B $D4                                 ; $80E7EF |
  BCS CODE_80E807                           ; $80E7F1 |
  REP #$20                                  ; $80E7F3 |
  JSR.W CODE_FN_80E972                      ; $80E7F5 |

  LDA.B $B2                                 ; $80E7F8 |
  EOR.W #$0400                              ; $80E7FA |
  AND.W #$1F80                              ; $80E7FD |
  STA.B $B2                                 ; $80E800 |
  JSR.W CODE_FN_80E854                      ; $80E802 |
  BRA CODE_80E7B0                           ; $80E805 |


CODE_80E807:
  STZ.B $E6                                 ; $80E807 |
  REP #$20                                  ; $80E809 |
  LDA.W #$0000                              ; $80E80B |
  TCD                                       ; $80E80E |
  RTL                                       ; $80E80F |


CODE_80E810:
  STZ.B $E6                                 ; $80E810 |
  LDA.W #$0000                              ; $80E812 |
  TCD                                       ; $80E815 |
  RTL                                       ; $80E816 |


CODE_80E817:
  LDA.B $B0                                 ; $80E817 |
  STA.W $1742                               ; $80E819 |
  LDA.B $B2                                 ; $80E81C |
  STA.W $1744                               ; $80E81E |
  LDA.W #$0000                              ; $80E821 |
  TCD                                       ; $80E824 |
  RTL                                       ; $80E825 |


CODE_FN_80E826:
  SEP #$20                                  ; $80E826 |
  LDA.B $DE                                 ; $80E828 |
  AND.B #$E0                                ; $80E82A |
  LSR A                                     ; $80E82C |
  LSR A                                     ; $80E82D |
  LSR A                                     ; $80E82E |
  STA.B $B2                                 ; $80E82F |
  LDA.B $DF                                 ; $80E831 |
  AND.B #$01                                ; $80E833 |
  ASL A                                     ; $80E835 |
  ASL A                                     ; $80E836 |
  STA.B $B3                                 ; $80E837 |
  LDA.B $E1                                 ; $80E839 |
  AND.B #$01                                ; $80E83B |
  ASL A                                     ; $80E83D |
  ASL A                                     ; $80E83E |
  ASL A                                     ; $80E83F |
  ORA.B $B3                                 ; $80E840 |
  ORA.B #$10                                ; $80E842 |
  STA.B $B3                                 ; $80E844 |
  LDA.B $E0                                 ; $80E846 |
  REP #$20                                  ; $80E848 |
  AND.W #$00E0                              ; $80E84A |
  ASL A                                     ; $80E84D |
  ASL A                                     ; $80E84E |
  ADC.B $B2                                 ; $80E84F |
  STA.B $B2                                 ; $80E851 |
  RTS                                       ; $80E853 |


CODE_FN_80E854:
  LDA.B $DA                                 ; $80E854 |
  SEP #$20                                  ; $80E856 |
  XBA                                       ; $80E858 |
  REP #$20                                  ; $80E859 |
  LSR A                                     ; $80E85B |
  LSR A                                     ; $80E85C |
  STA.B $C2                                 ; $80E85D |
  SEP #$20                                  ; $80E85F |
  LDA.B $DE                                 ; $80E861 |
  LSR A                                     ; $80E863 |
  LSR A                                     ; $80E864 |
  LSR A                                     ; $80E865 |
  LSR A                                     ; $80E866 |
  LSR A                                     ; $80E867 |
  STA.B $C0                                 ; $80E868 |
  LDA.B $E0                                 ; $80E86A |
  AND.B #$E0                                ; $80E86C |
  LSR A                                     ; $80E86E |
  LSR A                                     ; $80E86F |
  CLC                                       ; $80E870 |
  ADC.B $C0                                 ; $80E871 |
  STA.B $C0                                 ; $80E873 |
  STZ.B $C1                                 ; $80E875 |
  REP #$20                                  ; $80E877 |
  LDA.B $C0                                 ; $80E879 |
  ADC.B $C2                                 ; $80E87B |
  STA.B $D8                                 ; $80E87D |
  RTS                                       ; $80E87F |


CODE_JP_80E880:
  LDA.B $26                                 ; $80E880 |
  BEQ CODE_80E8C6                           ; $80E882 |
  CLC                                       ; $80E884 |
  BMI CODE_80E8A7                           ; $80E885 |
  ADC.B $22                                 ; $80E887 |
  STA.B $22                                 ; $80E889 |
  SEP #$20                                  ; $80E88B |
  LDA.B $D0                                 ; $80E88D |
  CLC                                       ; $80E88F |
  ADC.B $26                                 ; $80E890 |
  STA.B $D0                                 ; $80E892 |
  BMI CODE_80E8A3                           ; $80E894 |
  SEC                                       ; $80E896 |
  SBC.B #$20                                ; $80E897 |
  STA.B $D0                                 ; $80E899 |
  LDA.B $D2                                 ; $80E89B |
  AND.B #$0C                                ; $80E89D |
  ORA.B #$01                                ; $80E89F |
  STA.B $D2                                 ; $80E8A1 |

CODE_80E8A3:
  REP #$20                                  ; $80E8A3 |
  BRA CODE_80E8C6                           ; $80E8A5 |


CODE_80E8A7:
  ADC.B $22                                 ; $80E8A7 |
  STA.B $22                                 ; $80E8A9 |
  SEP #$20                                  ; $80E8AB |
  LDA.B $D0                                 ; $80E8AD |
  CLC                                       ; $80E8AF |
  ADC.B $26                                 ; $80E8B0 |
  STA.B $D0                                 ; $80E8B2 |
  CMP.B #$E0                                ; $80E8B4 |
  BCS CODE_80E8C4                           ; $80E8B6 |
  ADC.B #$20                                ; $80E8B8 |
  STA.B $D0                                 ; $80E8BA |
  LDA.B $D2                                 ; $80E8BC |
  AND.B #$0C                                ; $80E8BE |
  ORA.B #$02                                ; $80E8C0 |
  STA.B $D2                                 ; $80E8C2 |

CODE_80E8C4:
  REP #$20                                  ; $80E8C4 |

CODE_80E8C6:
  LDA.B $36                                 ; $80E8C6 |
  BEQ CODE_80E926                           ; $80E8C8 |
  CLC                                       ; $80E8CA |
  BPL CODE_80E8EC                           ; $80E8CB |
  ADC.B $32                                 ; $80E8CD |
  STA.B $32                                 ; $80E8CF |
  SEP #$20                                  ; $80E8D1 |
  LDA.B $D1                                 ; $80E8D3 |
  CLC                                       ; $80E8D5 |
  ADC.B $36                                 ; $80E8D6 |
  STA.B $D1                                 ; $80E8D8 |
  CMP.B #$E0                                ; $80E8DA |
  BCS CODE_80E908                           ; $80E8DC |
  ADC.B #$20                                ; $80E8DE |
  STA.B $D1                                 ; $80E8E0 |
  LDA.B $D2                                 ; $80E8E2 |
  AND.B #$03                                ; $80E8E4 |
  ORA.B #$08                                ; $80E8E6 |
  STA.B $D2                                 ; $80E8E8 |
  BRA CODE_80E908                           ; $80E8EA |


CODE_80E8EC:
  ADC.B $32                                 ; $80E8EC |
  STA.B $32                                 ; $80E8EE |
  SEP #$20                                  ; $80E8F0 |
  LDA.B $D1                                 ; $80E8F2 |
  CLC                                       ; $80E8F4 |
  ADC.B $36                                 ; $80E8F5 |
  STA.B $D1                                 ; $80E8F7 |
  BMI CODE_80E908                           ; $80E8F9 |
  SEC                                       ; $80E8FB |
  SBC.B #$20                                ; $80E8FC |
  STA.B $D1                                 ; $80E8FE |
  LDA.B $D2                                 ; $80E900 |
  AND.B #$03                                ; $80E902 |
  ORA.B #$04                                ; $80E904 |
  STA.B $D2                                 ; $80E906 |

CODE_80E908:
  LDA.B $E6                                 ; $80E908 |
  BEQ CODE_80E92C                           ; $80E90A |
  LDA.B $D2                                 ; $80E90C |
  BEQ CODE_80E91A                           ; $80E90E |
  BIT.B #$0C                                ; $80E910 |
  BNE CODE_80E91D                           ; $80E912 |
  LDA.B $D3                                 ; $80E914 |
  AND.B #$03                                ; $80E916 |
  BNE CODE_80E92A                           ; $80E918 |

CODE_80E91A:
  JMP.W CODE_JP_80E734                      ; $80E91A |


CODE_80E91D:
  LDA.B $D3                                 ; $80E91D |
  AND.B #$0C                                ; $80E91F |
  BNE CODE_80E92A                           ; $80E921 |
  JMP.W CODE_JP_80E734                      ; $80E923 |


CODE_80E926:
  SEP #$20                                  ; $80E926 |
  BRA CODE_80E908                           ; $80E928 |


CODE_80E92A:
  STZ.B $E6                                 ; $80E92A |

CODE_80E92C:
  LDA.B $D3                                 ; $80E92C |
  AND.B #$03                                ; $80E92E |
  BNE CODE_80E945                           ; $80E930 |
  LDA.B $D2                                 ; $80E932 |
  AND.B #$03                                ; $80E934 |
  BNE CODE_80E958                           ; $80E936 |
  LDA.B $D2                                 ; $80E938 |
  AND.B #$0C                                ; $80E93A |
  BNE CODE_80E965                           ; $80E93C |
  REP #$20                                  ; $80E93E |
  LDA.W #$0000                              ; $80E940 |
  TCD                                       ; $80E943 |
  RTL                                       ; $80E944 |


CODE_80E945:
  LDA.B $D2                                 ; $80E945 |
  AND.B #$0C                                ; $80E947 |
  BNE CODE_80E965                           ; $80E949 |
  LDA.B $D2                                 ; $80E94B |
  AND.B #$03                                ; $80E94D |
  BNE CODE_80E958                           ; $80E94F |
  REP #$20                                  ; $80E951 |
  LDA.W #$0000                              ; $80E953 |
  TCD                                       ; $80E956 |
  RTL                                       ; $80E957 |


CODE_80E958:
  STA.B $D3                                 ; $80E958 |
  LDA.B $D2                                 ; $80E95A |
  AND.B #$0C                                ; $80E95C |
  STA.B $D2                                 ; $80E95E |
  INC.B $E6                                 ; $80E960 |
  JMP.W CODE_JP_80E661                      ; $80E962 |


CODE_80E965:
  STA.B $D3                                 ; $80E965 |
  LDA.B $D2                                 ; $80E967 |
  AND.B #$03                                ; $80E969 |
  STA.B $D2                                 ; $80E96B |
  INC.B $E6                                 ; $80E96D |
  JMP.W CODE_JP_80E74D                      ; $80E96F |


CODE_FN_80E972:
  SEP #$20                                  ; $80E972 |
  LDA.B $E1                                 ; $80E974 |
  STA.W !reg_wrmpya                         ; $80E976 |
  LDA.B $D4                                 ; $80E979 |
  STA.W !reg_wrmpyb                         ; $80E97B |
  XBA                                       ; $80E97E |
  XBA                                       ; $80E97F |
  CLC                                       ; $80E980 |
  LDA.W !reg_rdmpyl                         ; $80E981 |
  ADC.B $DF                                 ; $80E984 |
  REP #$20                                  ; $80E986 |
  AND.W #$00FF                              ; $80E988 |
  TAY                                       ; $80E98B |

  LDA.B [$9D],Y                             ; $80E98C |
  AND.W #$007F                              ; $80E98E |
  STA.B $DA                                 ; $80E991 |
  RTS                                       ; $80E993 |


CODE_FL_80E994:
  PHB                                       ; $80E994 |
  PHX                                       ; $80E995 |
  PHY                                       ; $80E996 |
  TAX                                       ; $80E997 |
  STZ.W $195E                               ; $80E998 |
  LDA.W #$0001                              ; $80E99B |
  STA.W $1986                               ; $80E99E |
  PEA.W $8484                               ; $80E9A1 |
  PLB                                       ; $80E9A4 |
  PLB                                       ; $80E9A5 |
  LDA.W $19C4                               ; $80E9A6 |
  STA.B !r_room_id                          ; $80E9A9 |
  JSL.L CODE_FL_808A7A                      ; $80E9AB |
  LDA.W $19C0                               ; $80E9AF |
  STA.B $1A                                 ; $80E9B2 |
  AND.W #$00FF                              ; $80E9B4 |
  STA.B $0A                                 ; $80E9B7 |
  LDA.B $1A                                 ; $80E9B9 |
  AND.W #$FF00                              ; $80E9BB |
  STA.B $1A                                 ; $80E9BE |
  LDA.W $19BE                               ; $80E9C0 |
  STA.B $18                                 ; $80E9C3 |
  AND.W #$00FF                              ; $80E9C5 |
  STA.B $08                                 ; $80E9C8 |
  LDA.B $18                                 ; $80E9CA |
  AND.W #$FF00                              ; $80E9CC |
  STA.B $18                                 ; $80E9CF |
  JSL.L CODE_FL_80EA5B                      ; $80E9D1 |
  PLY                                       ; $80E9D5 |
  PLX                                       ; $80E9D6 |
  PLB                                       ; $80E9D7 |
  RTL                                       ; $80E9D8 |


CODE_FL_80E9D9:
  STZ.W $195E                               ; $80E9D9 |
  PHB                                       ; $80E9DC |
  PHX                                       ; $80E9DD |
  PHY                                       ; $80E9DE |
  TAX                                       ; $80E9DF |
  LDA.B $00                                 ; $80E9E0 |
  STA.W $193A                               ; $80E9E2 |
  BRA CODE_80E9EE                           ; $80E9E5 |


CODE_FL_80E9E7:
  STZ.W $195E                               ; $80E9E7 |

CODE_FL_80E9EA:
  PHB                                       ; $80E9EA |
  PHX                                       ; $80E9EB |
  PHY                                       ; $80E9EC |
  TAX                                       ; $80E9ED |

CODE_80E9EE:
  LDA.W #$0001                              ; $80E9EE |
  STA.W $199A                               ; $80E9F1 |
  LDA.B !r_room_id                          ; $80E9F4 |
  STA.L $7E7C08                             ; $80E9F6 |
  LDA.W #$0001                              ; $80E9FA |
  STA.W $1986                               ; $80E9FD |
  PEA.W $8484                               ; $80EA00 |
  PLB                                       ; $80EA03 |
  PLB                                       ; $80EA04 |
  LDA.W $0002,X                             ; $80EA05 |
  STA.B !r_room_id                          ; $80EA08 |
  JSL.L CODE_FL_808A7A                      ; $80EA0A |
  STX.B $00                                 ; $80EA0E |
  LDX.B !r_room_mode                        ; $80EA10 |
  LDA.L DATA8_80EDDE,X                      ; $80EA12 |
  AND.W #$00FF                              ; $80EA16 |
  LDX.B $00                                 ; $80EA19 |
  STA.B $00                                 ; $80EA1B |
  LDA.W $0000,X                             ; $80EA1D |
  AND.W #$00FF                              ; $80EA20 |
  CLC                                       ; $80EA23 |
  ADC.B $00                                 ; $80EA24 |
  ASL A                                     ; $80EA26 |
  ASL A                                     ; $80EA27 |
  ASL A                                     ; $80EA28 |
  ASL A                                     ; $80EA29 |
  STA.B $1A                                 ; $80EA2A |
  AND.W #$00FF                              ; $80EA2C |
  STA.B $0A                                 ; $80EA2F |
  LDA.B $1A                                 ; $80EA31 |
  AND.W #$FF00                              ; $80EA33 |
  STA.B $1A                                 ; $80EA36 |
  LDA.W $0001,X                             ; $80EA38 |
  AND.W #$00FF                              ; $80EA3B |
  CLC                                       ; $80EA3E |
  ADC.B $00                                 ; $80EA3F |

  ASL A                                     ; $80EA41 |
  ASL A                                     ; $80EA42 |

  ASL A                                     ; $80EA43 |
  ASL A                                     ; $80EA44 |
  STA.B $18                                 ; $80EA45 |
  AND.W #$00FF                              ; $80EA47 |
  STA.B $08                                 ; $80EA4A |
  LDA.B $18                                 ; $80EA4C |
  AND.W #$FF00                              ; $80EA4E |
  STA.B $18                                 ; $80EA51 |
  JSL.L CODE_FL_80EA5B                      ; $80EA53 |
  PLY                                       ; $80EA57 |
  PLX                                       ; $80EA58 |
  PLB                                       ; $80EA59 |
  RTL                                       ; $80EA5A |


CODE_FL_80EA5B:
  PHB                                       ; $80EA5B |
  PHX                                       ; $80EA5C |
  PHY                                       ; $80EA5D |
  PEA.W $8100                               ; $80EA5E |
  PLB                                       ; $80EA61 |
  PLB                                       ; $80EA62 |
  LDA.B !r_room_id                          ; $80EA63 |
  JSL.L CODE_FL_84827B                      ; $80EA65 |
  LDA.W #$0080                              ; $80EA69 |
  STA.B $12                                 ; $80EA6C |
  LDA.B $08                                 ; $80EA6E |
  SEC                                       ; $80EA70 |
  SBC.B $12                                 ; $80EA71 |
  CLC                                       ; $80EA73 |
  ADC.B $18                                 ; $80EA74 |
  BMI CODE_80EA8C                           ; $80EA76 |
  CMP.B $04                                 ; $80EA78 |
  BEQ CODE_80EA87                           ; $80EA7A |
  BCC CODE_80EA87                           ; $80EA7C |
  SBC.B $04                                 ; $80EA7E |
  CLC                                       ; $80EA80 |
  ADC.B $12                                 ; $80EA81 |
  STA.B $12                                 ; $80EA83 |
  LDA.B $04                                 ; $80EA85 |

CODE_80EA87:
  SEC                                       ; $80EA87 |
  SBC.B $00                                 ; $80EA88 |
  BCS CODE_80EA94                           ; $80EA8A |

CODE_80EA8C:
  CLC                                       ; $80EA8C |
  ADC.B $12                                 ; $80EA8D |
  STA.B $12                                 ; $80EA8F |
  LDA.W #$0000                              ; $80EA91 |

CODE_80EA94:
  STA.B $14                                 ; $80EA94 |
  AND.W #$001F                              ; $80EA96 |
  CLC                                       ; $80EA99 |
  ADC.B $12                                 ; $80EA9A |
  STA.W $195A                               ; $80EA9C |
  LDA.B $14                                 ; $80EA9F |
  AND.W #$FFE0                              ; $80EAA1 |
  STA.W $1756                               ; $80EAA4 |
  LDA.W #$0070                              ; $80EAA7 |
  STA.B $12                                 ; $80EAAA |
  LDA.B $0A                                 ; $80EAAC |

  SEC                                       ; $80EAAE |
  SBC.B $12                                 ; $80EAAF |
  CLC                                       ; $80EAB1 |
  ADC.B $1A                                 ; $80EAB2 |
  BMI CODE_80EACA                           ; $80EAB4 |
  CMP.B $06                                 ; $80EAB6 |

  BEQ CODE_80EAC5                           ; $80EAB8 |
  BCC CODE_80EAC5                           ; $80EABA |
  SBC.B $06                                 ; $80EABC |
  CLC                                       ; $80EABE |
  ADC.B $12                                 ; $80EABF |
  STA.B $12                                 ; $80EAC1 |
  LDA.B $06                                 ; $80EAC3 |

CODE_80EAC5:
  SEC                                       ; $80EAC5 |
  SBC.B $02                                 ; $80EAC6 |
  BCS CODE_80EAD2                           ; $80EAC8 |

CODE_80EACA:
  CLC                                       ; $80EACA |
  ADC.B $12                                 ; $80EACB |
  STA.B $12                                 ; $80EACD |
  LDA.W #$0000                              ; $80EACF |

CODE_80EAD2:
  STA.B $14                                 ; $80EAD2 |
  AND.W #$001F                              ; $80EAD4 |
  CLC                                       ; $80EAD7 |
  ADC.B $12                                 ; $80EAD8 |
  STA.W $195C                               ; $80EADA |
  LDA.B $14                                 ; $80EADD |
  AND.W #$FFE0                              ; $80EADF |
  STA.W $1758                               ; $80EAE2 |
  PLY                                       ; $80EAE5 |
  PLX                                       ; $80EAE6 |
  PLB                                       ; $80EAE7 |
  RTL                                       ; $80EAE8 |

  LDA.W $197E                               ; $80EAE9 |
  BNE CODE_80EB43                           ; $80EAEC |
  LDA.B $48,X                               ; $80EAEE |
  BEQ CODE_80EB43                           ; $80EAF0 |
  LDA.B $08                                 ; $80EAF2 |
  CLC                                       ; $80EAF4 |
  ADC.W $1662                               ; $80EAF5 |
  LSR A                                     ; $80EAF8 |
  LSR A                                     ; $80EAF9 |
  LSR A                                     ; $80EAFA |
  LSR A                                     ; $80EAFB |
  AND.W #$0FFF                              ; $80EAFC |
  STA.B $18                                 ; $80EAFF |
  LDA.B $0C                                 ; $80EB01 |
  CLC                                       ; $80EB03 |
  ADC.W $1672                               ; $80EB04 |
  LSR A                                     ; $80EB07 |
  LSR A                                     ; $80EB08 |
  LSR A                                     ; $80EB09 |
  LSR A                                     ; $80EB0A |
  AND.W #$0FFF                              ; $80EB0B |
  STA.B $1A                                 ; $80EB0E |
  LDA.B !r_room_id                          ; $80EB10 |
  ASL A                                     ; $80EB12 |
  TAY                                       ; $80EB13 |
  LDA.W DATA8_81F290,Y                      ; $80EB14 |
  STA.B $02                                 ; $80EB17 |
  LDY.W #$0000                              ; $80EB19 |
  SEP #$20                                  ; $80EB1C |

CODE_80EB1E:
  LDA.B [$02],Y                             ; $80EB1E |
  CMP.B #$FF                                ; $80EB20 |
  BEQ CODE_80EB43                           ; $80EB22 |
  CMP.B $1A                                 ; $80EB24 |
  BNE CODE_80EB3C                           ; $80EB26 |
  STA.B $04                                 ; $80EB28 |
  INY                                       ; $80EB2A |

  LDA.B [$02],Y                             ; $80EB2B |
  SEC                                       ; $80EB2D |
  SBC.B $1A                                 ; $80EB2E |

  BMI CODE_80EB38                           ; $80EB30 |
  CMP.B #$03                                ; $80EB32 |
  BCC CODE_80EB46                           ; $80EB34 |
  BRA CODE_80EB3D                           ; $80EB36 |


CODE_80EB38:
  CMP.B #$FE                                ; $80EB38 |
  BCS CODE_80EB46                           ; $80EB3A |

CODE_80EB3C:
  INY                                       ; $80EB3C |

CODE_80EB3D:
  INY                                       ; $80EB3D |
  INY                                       ; $80EB3E |
  INY                                       ; $80EB3F |
  INY                                       ; $80EB40 |
  BRA CODE_80EB1E                           ; $80EB41 |


CODE_80EB43:
  REP #$20                                  ; $80EB43 |
  RTL                                       ; $80EB45 |


CODE_80EB46:
  STZ.B $05                                 ; $80EB46 |
  REP #$20                                  ; $80EB48 |
  LDA.B [$00],Y                             ; $80EB4A |

  AND.W #$00FF                              ; $80EB4C |
  ASL A                                     ; $80EB4F |

  ASL A                                     ; $80EB50 |
  ASL A                                     ; $80EB51 |
  ASL A                                     ; $80EB52 |
  STA.W $19BE                               ; $80EB53 |
  STX.W $197E                               ; $80EB56 |
  LDA.B $04                                 ; $80EB59 |
  ASL A                                     ; $80EB5B |
  ASL A                                     ; $80EB5C |
  ASL A                                     ; $80EB5D |
  ASL A                                     ; $80EB5E |
  STA.W $19C0                               ; $80EB5F |
  RTL                                       ; $80EB62 |


CODE_FL_80EB63:
  LDA.W #$0000                              ; $80EB63 |
  STA.W $195E                               ; $80EB66 |
  LDA.W #$0001                              ; $80EB69 |
  STA.L $70034C                             ; $80EB6C |
  SEP #$20                                  ; $80EB70 |
  LDA.B #$02                                ; $80EB72 |
  STA.L $700690                             ; $80EB74 |
  REP #$20                                  ; $80EB78 |
  LDA.W #$F3A0                              ; $80EB7A |
  JSL.L CODE_FL_80E9EA                      ; $80EB7D |
  JML.L CODE_FL_848000                      ; $80EB81 |


CODE_JL_80EB85:
  LDA.W #$0200                              ; $80EB85 |

  STA.W $195E                               ; $80EB88 |
  LDA.W #$0000                              ; $80EB8B |
  STA.L $700758                             ; $80EB8E |
  LDA.W #$F59C                              ; $80EB92 |
  JSL.L CODE_FL_80E9EA                      ; $80EB95 |

CODE_FL_80EB99:
  INC.W $199A                               ; $80EB99 |
  LDA.W #$0000                              ; $80EB9C |
  JML.L CODE_FL_80C876                      ; $80EB9F |


CODE_JL_80EBA3:
  JSL.L CODE_FL_80C213                      ; $80EBA3 |
  LDA.W #$0000                              ; $80EBA7 |

  STA.W $195E                               ; $80EBAA |
  LDA.W #$0001                              ; $80EBAD |
  STA.L $70039C                             ; $80EBB0 |
  JSL.L CODE_FL_96FBB1                      ; $80EBB4 |
  LDA.W #$0002                              ; $80EBB8 |
  STA.L $700758                             ; $80EBBB |
  SEP #$20                                  ; $80EBBF |
  LDA.B #$02                                ; $80EBC1 |
  STA.L $700690                             ; $80EBC3 |
  REP #$20                                  ; $80EBC7 |
  LDA.W #$F4F8                              ; $80EBC9 |
  JSL.L CODE_FL_80E9EA                      ; $80EBCC |
  JML.L CODE_FL_848000                      ; $80EBD0 |


CODE_JL_80EBD4:
  JSL.L CODE_FL_80C213                      ; $80EBD4 |
  LDA.W #$0100                              ; $80EBD8 |
  STA.W $195E                               ; $80EBDB |
  LDA.W #$F384                              ; $80EBDE |
  JSL.L CODE_FL_80E9EA                      ; $80EBE1 |
  JML.L CODE_FL_848000                      ; $80EBE5 |


CODE_JL_80EBE9:
  TDC                                       ; $80EBE9 |
  STA.W $195E                               ; $80EBEA |
  JSL.L CODE_FL_80EC00                      ; $80EBED |
  LDA.W #$F514                              ; $80EBF1 |
  JSL.L CODE_FL_80E9EA                      ; $80EBF4 |
  JSL.L CODE_FL_80EB99                      ; $80EBF8 |
  JML.L CODE_FL_A0F9E7                      ; $80EBFC |


CODE_FL_80EC00:
  PHX                                       ; $80EC00 |
  LDX.W #$0400                              ; $80EC01 |
  LDY.W #$04C0                              ; $80EC04 |
  JSR.W CODE_FN_80EC2B                      ; $80EC07 |

  LDX.W #$04C0                              ; $80EC0A |
  LDY.W #$0400                              ; $80EC0D |
  JSR.W CODE_FN_80EC2B                      ; $80EC10 |
  LDA.W #$0081                              ; $80EC13 |
  STA.L $7002F8                             ; $80EC16 |
  STA.L $70030C                             ; $80EC1A |
  LDA.W #$0001                              ; $80EC1E |
  STA.L $700320                             ; $80EC21 |
  STA.L $700334                             ; $80EC25 |
  PLX                                       ; $80EC29 |
  RTL                                       ; $80EC2A |


CODE_FN_80EC2B:
  LDA.B $18,X                               ; $80EC2B |
  BEQ CODE_80EC4C                           ; $80EC2D |
  CMP.W #$0003                              ; $80EC2F |
  BCS CODE_80EC4C                           ; $80EC32 |
  LDA.W $0018,Y                             ; $80EC34 |
  CMP.W #$0003                              ; $80EC37 |
  BNE CODE_80EC41                           ; $80EC3A |
  LDY.W #$0004                              ; $80EC3C |
  BRA CODE_80EC44                           ; $80EC3F |


CODE_80EC41:
  LDY.W #$0003                              ; $80EC41 |

CODE_80EC44:
  STY.B $18,X                               ; $80EC44 |
  JSL.L CODE_FL_83CD69                      ; $80EC46 |
  REP #$20                                  ; $80EC4A |

CODE_80EC4C:
  RTS                                       ; $80EC4C |


CODE_FL_80EC4D:
  TDC                                       ; $80EC4D |
  STA.W $195E                               ; $80EC4E |
  JSL.L CODE_FL_80EC64                      ; $80EC51 |
  LDA.W #$F518                              ; $80EC55 |
  JSL.L CODE_FL_80E9EA                      ; $80EC58 |
  JSL.L CODE_FL_80EB99                      ; $80EC5C |
  JML.L CODE_FL_A0F9E7                      ; $80EC60 |


CODE_FL_80EC64:
  PHX                                       ; $80EC64 |
  LDX.W #$0400                              ; $80EC65 |
  LDY.W #$04C0                              ; $80EC68 |
  JSR.W CODE_FN_80EC8F                      ; $80EC6B |
  LDX.W #$04C0                              ; $80EC6E |
  LDY.W #$0400                              ; $80EC71 |
  JSR.W CODE_FN_80EC8F                      ; $80EC74 |
  LDA.W #$0001                              ; $80EC77 |
  STA.L $7002F8                             ; $80EC7A |
  STA.L $70030C                             ; $80EC7E |
  LDA.W #$0081                              ; $80EC82 |
  STA.L $700320                             ; $80EC85 |
  STA.L $700334                             ; $80EC89 |
  PLX                                       ; $80EC8D |

  RTL                                       ; $80EC8E |


CODE_FN_80EC8F:
  LDA.B $18,X                               ; $80EC8F |
  BEQ CODE_80ECB0                           ; $80EC91 |

  CMP.W #$0003                              ; $80EC93 |
  BCC CODE_80ECB0                           ; $80EC96 |
  LDA.W $0018,Y                             ; $80EC98 |
  CMP.W #$0001                              ; $80EC9B |
  BNE CODE_80ECA5                           ; $80EC9E |
  LDY.W #$0002                              ; $80ECA0 |
  BRA CODE_80ECA8                           ; $80ECA3 |


CODE_80ECA5:
  LDY.W #$0001                              ; $80ECA5 |

CODE_80ECA8:
  STY.B $18,X                               ; $80ECA8 |
  JSL.L CODE_FL_83CD69                      ; $80ECAA |
  REP #$20                                  ; $80ECAE |

CODE_80ECB0:
  RTS                                       ; $80ECB0 |


CODE_JL_80ECB1:
  TDC                                       ; $80ECB1 |
  STA.W $195E                               ; $80ECB2 |
  LDA.W #$000B                              ; $80ECB5 |
  STA.L $700758                             ; $80ECB8 |
  JSL.L CODE_FL_80893F                      ; $80ECBC |
  LDA.W #$F51C                              ; $80ECC0 |
  JSL.L CODE_FL_80E9EA                      ; $80ECC3 |
  JMP.W CODE_FL_80EB99                      ; $80ECC7 |

  LDA.W #$0400                              ; $80ECCA |
  STA.W $195E                               ; $80ECCD |
  LDA.W #$F518                              ; $80ECD0 |
  JSL.L CODE_FL_80E9EA                      ; $80ECD3 |
  JMP.W CODE_FL_80EB99                      ; $80ECD7 |


CODE_JL_80ECDA:
  JSL.L CODE_FL_80C213                      ; $80ECDA |
  LDA.W #$0000                              ; $80ECDE |
  STA.W $195E                               ; $80ECE1 |
  LDA.W #$F528                              ; $80ECE4 |
  JSL.L CODE_FL_80E9EA                      ; $80ECE7 |
  JML.L CODE_FL_848000                      ; $80ECEB |


CODE_JL_80ECEF:
  JSL.L CODE_FL_80C213                      ; $80ECEF |
  LDA.W #$0400                              ; $80ECF3 |
  STA.W $195E                               ; $80ECF6 |
  LDA.W #$F668                              ; $80ECF9 |
  JSL.L CODE_FL_80E9EA                      ; $80ECFC |
  JML.L CODE_FL_848000                      ; $80ED00 |


CODE_JL_80ED04:
  JSL.L CODE_FL_80C213                      ; $80ED04 |
  LDA.W #$0400                              ; $80ED08 |
  STA.W $195E                               ; $80ED0B |
  LDA.W #$F554                              ; $80ED0E |
  JSL.L CODE_FL_80E9EA                      ; $80ED11 |
  JML.L CODE_FL_848000                      ; $80ED15 |


CODE_JL_80ED19:
  JSL.L CODE_FL_80C213                      ; $80ED19 |
  LDA.W #$0400                              ; $80ED1D |
  STA.W $195E                               ; $80ED20 |
  LDA.W #$F574                              ; $80ED23 |
  JSL.L CODE_FL_80E9EA                      ; $80ED26 |
  JML.L CODE_FL_848000                      ; $80ED2A |


CODE_JL_80ED2E:
  JSL.L CODE_FL_80C213                      ; $80ED2E |
  LDA.W #$0400                              ; $80ED32 |
  STA.W $195E                               ; $80ED35 |
  LDA.W #$F590                              ; $80ED38 |
  JSL.L CODE_FL_80E9EA                      ; $80ED3B |
  JML.L CODE_FL_848000                      ; $80ED3F |


CODE_JL_80ED43:
  JSL.L CODE_FL_80C213                      ; $80ED43 |
  LDA.W #$0200                              ; $80ED47 |
  STA.W $195E                               ; $80ED4A |
  JSL.L CODE_FL_80EC64                      ; $80ED4D |

  LDA.W #$F4CC                              ; $80ED51 |
  JSL.L CODE_FL_80E9EA                      ; $80ED54 |
  JML.L CODE_FL_848000                      ; $80ED58 |


CODE_FL_80ED5C:
  LDA.W #$0000                              ; $80ED5C |
  STA.W $195E                               ; $80ED5F |
  LDA.W #$F4D4                              ; $80ED62 |
  JSL.L CODE_FL_80E9EA                      ; $80ED65 |

  JMP.W CODE_FL_80EB99                      ; $80ED69 |


CODE_JL_80ED6C:
  LDA.W #$0400                              ; $80ED6C |
  STA.W $195E                               ; $80ED6F |
  LDA.W #$F58C                              ; $80ED72 |
  JSL.L CODE_FL_80E9EA                      ; $80ED75 |
  JMP.W CODE_FL_80EB99                      ; $80ED79 |


CODE_JL_80ED7C:
  LDA.W #$0200                              ; $80ED7C |
  STA.W $195E                               ; $80ED7F |
  LDA.W #$F5AC                              ; $80ED82 |
  JSL.L CODE_FL_80E9EA                      ; $80ED85 |
  JMP.W CODE_FL_80EB99                      ; $80ED89 |


CODE_JL_80ED8C:
  TDC                                       ; $80ED8C |
  STA.L $70078A                             ; $80ED8D |
  LDA.W #$0400                              ; $80ED91 |
  STA.W $195E                               ; $80ED94 |
  LDA.W #$F4C8                              ; $80ED97 |
  JSL.L CODE_FL_80E9EA                      ; $80ED9A |
  JMP.W CODE_FL_80EB99                      ; $80ED9E |


CODE_JL_80EDA1:
  LDA.W #$0000                              ; $80EDA1 |
  STA.W $195E                               ; $80EDA4 |
  LDA.W #$F4D0                              ; $80EDA7 |
  JSL.L CODE_FL_80E9EA                      ; $80EDAA |
  JMP.W CODE_FL_80EB99                      ; $80EDAE |


CODE_JL_80EDB1:
  LDA.W #$0100                              ; $80EDB1 |
  STA.W $195E                               ; $80EDB4 |
  LDA.W #$F3A4                              ; $80EDB7 |

  JSL.L CODE_FL_80E9EA                      ; $80EDBA |
  JMP.W CODE_FL_80EB99                      ; $80EDBE |


CODE_JL_80EDC1:
  LDA.W #$0000                              ; $80EDC1 |
  STA.W $195E                               ; $80EDC4 |
  LDA.W #$F4D0                              ; $80EDC7 |
  JSL.L CODE_FL_80E9EA                      ; $80EDCA |
  JML.L CODE_FL_848000                      ; $80EDCE |


CODE_FL_80EDD2:
  LDA.W #$0006                              ; $80EDD2 |
  STA.B !r_room_mode                        ; $80EDD5 |
  LDA.W #$0004                              ; $80EDD7 |
  JML.L CODE_FL_80C876                      ; $80EDDA |


DATA8_80EDDE:
  db $00,$10,$00,$10                        ; $80EDDE |

CODE_JL_80EDE2:
  INC.W $1C02                               ; $80EDE2 |
  RTS                                       ; $80EDE5 |


CODE_80EDE6:
  LDA.B $3C                                 ; $80EDE6 |
  BEQ CODE_80EDEE                           ; $80EDE8 |
  JSR.W CODE_FN_80EDFA                      ; $80EDEA |
  RTL                                       ; $80EDED |


CODE_80EDEE:
  INC.B $3C                                 ; $80EDEE |
  STZ.W $1FA0                               ; $80EDF0 |
  STZ.W $1C00                               ; $80EDF3 |
  STZ.W $1C02                               ; $80EDF6 |
  RTL                                       ; $80EDF9 |


CODE_FN_80EDFA:
  LDA.W $1C00                               ; $80EDFA |
  ASL A                                     ; $80EDFD |
  TAX                                       ; $80EDFE |
  JMP.W (PTR16_80EE02,X)                    ; $80EDFF |

PTR16_80EE02:
  dw CODE_80EE14                            ; $80EE02 |
  dw CODE_80EE25                            ; $80EE04 |
  dw CODE_80EF69                            ; $80EE06 |
  dw CODE_80EE0A                            ; $80EE08 |

CODE_80EE0A:
  LDA.W $1FA0                               ; $80EE0A |
  BNE CODE_80EE13                           ; $80EE0D |
  JSL.L CODE_FL_8085DA                      ; $80EE0F |

CODE_80EE13:
  RTS                                       ; $80EE13 |


CODE_80EE14:
  JSR.W CODE_FN_80F97C                      ; $80EE14 |
  BCC CODE_80EE1E                           ; $80EE17 |
  JSR.W CODE_FN_80FB29                      ; $80EE19 |
  BRA CODE_80EE21                           ; $80EE1C |


CODE_80EE1E:
  JSR.W CODE_FN_80F939                      ; $80EE1E |

CODE_80EE21:
  INC.W $1C00                               ; $80EE21 |
  RTS                                       ; $80EE24 |


CODE_80EE25:
  JSL.L CODE_FL_80BE9F                      ; $80EE25 |
  JSL.L CODE_FL_808302                      ; $80EE29 |
  JSL.L CODE_FL_808BC2                      ; $80EE2D |
  LDA.W #$FFE1                              ; $80EE31 |
  STA.W $1672                               ; $80EE34 |
  LDA.W #$FFFC                              ; $80EE37 |
  STA.W $16B2                               ; $80EE3A |
  REP #$30                                  ; $80EE3D |
  PHB                                       ; $80EE3F |
  LDA.W #$0000                              ; $80EE40 |
  STA.L $001C04                             ; $80EE43 |
  LDA.W #$00F9                              ; $80EE47 |
  LDX.W #$1C05                              ; $80EE4A |
  TXY                                       ; $80EE4D |
  INY                                       ; $80EE4E |
  MVN $00,$00                               ; $80EE4F |
  PLB                                       ; $80EE52 |
  LDX.W #asset_8881F3                       ; $80EE53 |
  JSL.L load_asset                          ; $80EE56 |
  JSL.L CODE_FL_808302                      ; $80EE5A |
  LDX.W #asset_logo_sprites                 ; $80EE5E |
  JSL.L load_asset                          ; $80EE61 |
  JSL.L CODE_FL_808302                      ; $80EE65 |
  LDX.W #asset_888214                       ; $80EE69 |
  JSL.L load_asset                          ; $80EE6C |
  JSL.L CODE_FL_808302                      ; $80EE70 |
  JSL.L CODE_FL_8BFCCA                      ; $80EE74 |
  LDY.W #$8198                              ; $80EE78 |
  JSL.L CODE_FL_808D78                      ; $80EE7B |

  LDY.W #$8205                              ; $80EE7F |
  JSL.L CODE_FL_808DBE                      ; $80EE82 |
  JSL.L CODE_FL_808302                      ; $80EE86 |
  LDA.W #$007F                              ; $80EE8A |
  STA.B $00                                 ; $80EE8D |
  LDA.W #$0000                              ; $80EE8F |
  LDX.W #$1000                              ; $80EE92 |
  LDY.W #$5800                              ; $80EE95 |
  JSL.L CODE_FL_809671                      ; $80EE98 |
  JSL.L CODE_FL_8095B5                      ; $80EE9C |
  LDY.W #$B6CA                              ; $80EEA0 |
  JSL.L CODE_FL_80C27C                      ; $80EEA3 |
  LDY.W #$9EDF                              ; $80EEA7 |
  LDA.W #$00E0                              ; $80EEAA |
  JSL.L CODE_FL_8AAF64                      ; $80EEAD |
  LDY.W #$0400                              ; $80EEB1 |
  LDX.W #$0000                              ; $80EEB4 |
  LDA.L DATA8_81FA0C,X                      ; $80EEB7 |

CODE_80EEBB:
  STA.W $0000,Y                             ; $80EEBB |
  LDA.L DATA8_81FA0E,X                      ; $80EEBE |
  STA.W $0009,Y                             ; $80EEC2 |

  LDA.L DATA8_81FA10,X                      ; $80EEC5 |
  SEC                                       ; $80EEC9 |
  SBC.W #$FFE6                              ; $80EECA |
  STA.W $000D,Y                             ; $80EECD |
  LDA.L DATA8_81FA12,X                      ; $80EED0 |
  STA.W $0002,Y                             ; $80EED4 |
  LDA.W #$1898                              ; $80EED7 |
  STA.W $0004,Y                             ; $80EEDA |
  TXA                                       ; $80EEDD |
  CLC                                       ; $80EEDE |
  ADC.W #$0008                              ; $80EEDF |
  TAX                                       ; $80EEE2 |
  LDA.W $0016,Y                             ; $80EEE3 |
  TAY                                       ; $80EEE6 |
  LDA.L DATA8_81FA0C,X                      ; $80EEE7 |
  BNE CODE_80EEBB                           ; $80EEEB |
  JSL.L CODE_FL_84A1ED                      ; $80EEED |
  LDA.W #$0000                              ; $80EEF1 |
  JSR.W CODE_FN_80F403                      ; $80EEF4 |
  LDA.W #$0000                              ; $80EEF7 |

  JSR.W CODE_FN_80F444                      ; $80EEFA |
  LDA.W #$0000                              ; $80EEFD |
  JSR.W CODE_FN_80F485                      ; $80EF00 |
  LDA.W #$0000                              ; $80EF03 |
  JSR.W CODE_FN_80F4CE                      ; $80EF06 |
  LDA.W #$0000                              ; $80EF09 |
  JSR.W CODE_FN_80F4E7                      ; $80EF0C |
  JSL.L CODE_FL_8095B5                      ; $80EF0F |
  LDA.W #$0001                              ; $80EF13 |
  JSR.W CODE_FN_80F403                      ; $80EF16 |
  LDA.W #$0001                              ; $80EF19 |
  JSR.W CODE_FN_80F444                      ; $80EF1C |
  LDA.W #$0001                              ; $80EF1F |
  JSR.W CODE_FN_80F485                      ; $80EF22 |
  LDA.W #$0001                              ; $80EF25 |
  JSR.W CODE_FN_80F4CE                      ; $80EF28 |
  LDA.W #$0001                              ; $80EF2B |
  JSR.W CODE_FN_80F4E7                      ; $80EF2E |
  JSL.L CODE_FL_8095B5                      ; $80EF31 |
  LDA.W #$0002                              ; $80EF35 |
  JSR.W CODE_FN_80F403                      ; $80EF38 |
  LDA.W #$0002                              ; $80EF3B |
  JSR.W CODE_FN_80F444                      ; $80EF3E |
  LDA.W #$0002                              ; $80EF41 |
  JSR.W CODE_FN_80F485                      ; $80EF44 |
  LDA.W #$0002                              ; $80EF47 |
  JSR.W CODE_FN_80F4CE                      ; $80EF4A |
  LDA.W #$0002                              ; $80EF4D |
  JSR.W CODE_FN_80F4E7                      ; $80EF50 |
  JSL.L CODE_FL_8095B5                      ; $80EF53 |
  LDA.L $7008F4                             ; $80EF57 |
  STA.W $1C08                               ; $80EF5B |
  JSL.L CODE_FL_808230                      ; $80EF5E |
  STZ.W $1FA0                               ; $80EF62 |
  INC.W $1C00                               ; $80EF65 |
  RTS                                       ; $80EF68 |


CODE_80EF69:
  LDA.W $1C02                               ; $80EF69 |
  ASL A                                     ; $80EF6C |
  TAX                                       ; $80EF6D |
  JMP.W (PTR16_80EF71,X)                    ; $80EF6E |

PTR16_80EF71:
  dw CODE_80EF77                            ; $80EF71 |
  dw CODE_80EF9B                            ; $80EF73 |
  dw CODE_80EFB5                            ; $80EF75 |

CODE_80EF77:
  JSR.W CODE_FN_80F35C                      ; $80EF77 |

  LDA.W $1C08                               ; $80EF7A |
  JSR.W CODE_FN_80F36B                      ; $80EF7D |
  LDY.W #$5304                              ; $80EF80 |
  LDX.W #$0000                              ; $80EF83 |
  JSR.W CODE_FN_80F3B1                      ; $80EF86 |
  JSR.W CODE_FN_80F580                      ; $80EF89 |
  JSR.W CODE_FN_80F64E                      ; $80EF8C |
  LDA.W $1C08                               ; $80EF8F |
  JSR.W CODE_FN_80F854                      ; $80EF92 |
  JSR.W CODE_FN_80F642                      ; $80EF95 |
  BRL CODE_JL_80EDE2                        ; $80EF98 |


CODE_80EF9B:
  INC.W $1FA0                               ; $80EF9B |
  LDA.W $1FA0                               ; $80EF9E |
  CMP.W #$000F                              ; $80EFA1 |
  BNE CODE_80EFA9                           ; $80EFA4 |
  BRL CODE_JL_80EDE2                        ; $80EFA6 |


CODE_80EFA9:
  RTS                                       ; $80EFA9 |


CODE_JL_80EFAA:
  STA.W $1C04                               ; $80EFAA |
  STZ.W $1C06                               ; $80EFAD |
  RTS                                       ; $80EFB0 |


CODE_JL_80EFB1:
  INC.W $1C06                               ; $80EFB1 |
  RTS                                       ; $80EFB4 |


CODE_80EFB5:
  LDA.W $1C04                               ; $80EFB5 |
  JSR.W CODE_FN_80EFBC                      ; $80EFB8 |
  RTS                                       ; $80EFBB |


CODE_FN_80EFBC:
  ASL A                                     ; $80EFBC |
  TAX                                       ; $80EFBD |
  JMP.W (PTR16_80EFC1,X)                    ; $80EFBE |

PTR16_80EFC1:
  dw CODE_80EFC9                            ; $80EFC1 |
  dw CODE_80F0A7                            ; $80EFC3 |
  dw CODE_80F14F                            ; $80EFC5 |
  dw CODE_80F26F                            ; $80EFC7 |

CODE_80EFC9:
  JSR.W CODE_FN_80EFDE                      ; $80EFC9 |
  JSR.W CODE_FN_80F580                      ; $80EFCC |
  LDA.W $1C08                               ; $80EFCF |
  JSR.W CODE_FN_80F854                      ; $80EFD2 |
  LDA.W #$0020                              ; $80EFD5 |
  STA.W $1FB8                               ; $80EFD8 |
  BRL CODE_FN_80F642                        ; $80EFDB |


CODE_FN_80EFDE:
  LDA.W $1C06                               ; $80EFDE |
  ASL A                                     ; $80EFE1 |
  TAX                                       ; $80EFE2 |
  JMP.W (PTR16_80EFE6,X)                    ; $80EFE3 |

PTR16_80EFE6:
  dw CODE_80EFEA                            ; $80EFE6 |
  dw CODE_80EFFE                            ; $80EFE8 |

CODE_80EFEA:
  JSR.W CODE_FN_80F35C                      ; $80EFEA |
  LDA.W $1C08                               ; $80EFED |
  JSR.W CODE_FN_80F36B                      ; $80EFF0 |
  LDY.W #$5304                              ; $80EFF3 |
  LDX.W #$0000                              ; $80EFF6 |
  JSR.W CODE_FN_80F3B1                      ; $80EFF9 |
  BRA CODE_JL_80EFB1                        ; $80EFFC |


CODE_80EFFE:
  LDA.B $30                                 ; $80EFFE |
  BIT.W #$0800                              ; $80F000 |
  BEQ CODE_80F018                           ; $80F003 |
  LDA.W $1C08                               ; $80F005 |
  DEC A                                     ; $80F008 |
  BMI CODE_80F013                           ; $80F009 |

  CMP.W #$0003                              ; $80F00B |
  BNE CODE_80F03C                           ; $80F00E |
  DEC A                                     ; $80F010 |
  BRA CODE_80F03C                           ; $80F011 |


CODE_80F013:
  LDA.W #$0003                              ; $80F013 |
  BRA CODE_80F03C                           ; $80F016 |


CODE_80F018:
  BIT.W #$0400                              ; $80F018 |
  BEQ CODE_80F029                           ; $80F01B |
  LDA.W $1C08                               ; $80F01D |
  INC A                                     ; $80F020 |
  CMP.W #$0004                              ; $80F021 |
  BCC CODE_80F03C                           ; $80F024 |
  TDC                                       ; $80F026 |
  BRA CODE_80F03C                           ; $80F027 |


CODE_80F029:
  LDY.W $1C08                               ; $80F029 |
  CPY.W #$0003                              ; $80F02C |
  BCC CODE_80F051                           ; $80F02F |
  BIT.W #$0300                              ; $80F031 |
  BEQ CODE_80F051                           ; $80F034 |

  TYA                                       ; $80F036 |
  EOR.W #$0007                              ; $80F037 |
  BRA CODE_80F03C                           ; $80F03A |


CODE_80F03C:
  PHA                                       ; $80F03C |
  LDA.W $1C08                               ; $80F03D |
  JSR.W CODE_FN_80F379                      ; $80F040 |
  PLA                                       ; $80F043 |
  STA.W $1C08                               ; $80F044 |
  JSR.W CODE_FN_80F36B                      ; $80F047 |
  LDA.W #$0046                              ; $80F04A |
  JSL.L push_sound_queue                    ; $80F04D |

CODE_80F051:
  LDA.B $30                                 ; $80F051 |
  BIT.W #$D0C0                              ; $80F053 |
  BEQ CODE_80F0A6                           ; $80F056 |
  LDA.W #$0047                              ; $80F058 |
  JSL.L push_sound_queue                    ; $80F05B |
  LDA.W $1C08                               ; $80F05F |
  ASL A                                     ; $80F062 |
  TAX                                       ; $80F063 |
  JMP.W (PTR16_80F067,X)                    ; $80F064 |

PTR16_80F067:
  dw CODE_80F071                            ; $80F067 |
  dw CODE_80F071                            ; $80F069 |
  dw CODE_80F071                            ; $80F06B |
  dw CODE_80F088                            ; $80F06D |
  dw CODE_80F097                            ; $80F06F |

CODE_80F071:
  LDA.W $1C08                               ; $80F071 |
  STA.L $7008F4                             ; $80F074 |
  STA.B $C2                                 ; $80F078 |
  JSR.W CODE_FN_80FB14                      ; $80F07A |
  LDA.W #$0003                              ; $80F07D |
  STA.W $1C00                               ; $80F080 |
  JSL.L CODE_FL_80C213                      ; $80F083 |
  RTS                                       ; $80F087 |


CODE_80F088:
  LDA.W $1C08                               ; $80F088 |
  JSR.W CODE_FN_80F379                      ; $80F08B |
  STZ.W $1C08                               ; $80F08E |
  LDA.W #$0001                              ; $80F091 |
  BRL CODE_JL_80EFAA                        ; $80F094 |


CODE_80F097:
  LDA.W $1C08                               ; $80F097 |
  JSR.W CODE_FN_80F379                      ; $80F09A |
  STZ.W $1C08                               ; $80F09D |
  LDA.W #$0003                              ; $80F0A0 |
  BRL CODE_JL_80EFAA                        ; $80F0A3 |


CODE_80F0A6:
  RTS                                       ; $80F0A6 |


CODE_80F0A7:
  JSR.W CODE_FN_80F0C2                      ; $80F0A7 |
  LDA.W $1C08                               ; $80F0AA |
  LDY.W $1C08                               ; $80F0AD |
  JSR.W CODE_FN_80F601                      ; $80F0B0 |
  LDA.W $1C08                               ; $80F0B3 |
  JSR.W CODE_FN_80F854                      ; $80F0B6 |
  LDA.W #$0020                              ; $80F0B9 |
  STA.W $1FB8                               ; $80F0BC |
  BRL CODE_FN_80F642                        ; $80F0BF |


CODE_FN_80F0C2:
  LDA.W $1C06                               ; $80F0C2 |
  ASL A                                     ; $80F0C5 |
  TAX                                       ; $80F0C6 |

  JMP.W (PTR16_80F0CA,X)                    ; $80F0C7 |

PTR16_80F0CA:
  dw CODE_80F0CE                            ; $80F0CA |
  dw CODE_80F0E7                            ; $80F0CC |

CODE_80F0CE:
  LDY.W #$5304                              ; $80F0CE |
  LDX.W #$0018                              ; $80F0D1 |
  JSR.W CODE_FN_80F3B1                      ; $80F0D4 |
  JSR.W CODE_FN_80F35C                      ; $80F0D7 |
  TDC                                       ; $80F0DA |
  STA.W $1C08                               ; $80F0DB |
  STA.W $1C0A                               ; $80F0DE |
  JSR.W CODE_FN_80F387                      ; $80F0E1 |
  BRL CODE_JL_80EFB1                        ; $80F0E4 |


CODE_80F0E7:
  LDA.W $1C08                               ; $80F0E7 |
  STA.W $1C0C                               ; $80F0EA |
  LDA.B $30                                 ; $80F0ED |
  BIT.W #$0800                              ; $80F0EF |
  BEQ CODE_80F0FF                           ; $80F0F2 |
  LDA.W $1C08                               ; $80F0F4 |
  DEC A                                     ; $80F0F7 |
  BPL CODE_80F110                           ; $80F0F8 |
  LDA.W #$0003                              ; $80F0FA |
  BRA CODE_80F110                           ; $80F0FD |


CODE_80F0FF:
  BIT.W #$0400                              ; $80F0FF |
  BEQ CODE_80F126                           ; $80F102 |
  LDA.W $1C08                               ; $80F104 |
  INC A                                     ; $80F107 |
  CMP.W #$0004                              ; $80F108 |
  BCC CODE_80F110                           ; $80F10B |
  TDC                                       ; $80F10D |
  BRA CODE_80F110                           ; $80F10E |


CODE_80F110:
  STA.W $1C08                               ; $80F110 |
  LDA.W $1C0C                               ; $80F113 |
  JSR.W CODE_FN_80F395                      ; $80F116 |
  LDA.W $1C08                               ; $80F119 |
  JSR.W CODE_FN_80F387                      ; $80F11C |
  LDA.W #$0046                              ; $80F11F |
  JSL.L push_sound_queue                    ; $80F122 |

CODE_80F126:
  LDA.B $30                                 ; $80F126 |
  BIT.W #$C0C0                              ; $80F128 |
  BEQ CODE_80F14E                           ; $80F12B |
  LDA.W #$0047                              ; $80F12D |
  JSL.L push_sound_queue                    ; $80F130 |
  LDA.W $1C08                               ; $80F134 |
  CMP.W #$0003                              ; $80F137 |
  BNE CODE_80F148                           ; $80F13A |
  LDA.W $1C08                               ; $80F13C |
  JSR.W CODE_FN_80F395                      ; $80F13F |
  LDA.W #$0000                              ; $80F142 |

  BRL CODE_JL_80EFAA                        ; $80F145 |


CODE_80F148:
  LDA.W #$0002                              ; $80F148 |
  BRL CODE_JL_80EFAA                        ; $80F14B |


CODE_80F14E:
  RTS                                       ; $80F14E |


CODE_80F14F:
  JSR.W CODE_FN_80F177                      ; $80F14F |
  LDA.W $1C08                               ; $80F152 |
  LDY.W $1C0A                               ; $80F155 |
  JSR.W CODE_FN_80F601                      ; $80F158 |
  LDA.W $1C0A                               ; $80F15B |
  CMP.W $1C08                               ; $80F15E |
  BEQ CODE_80F168                           ; $80F161 |
  JSR.W CODE_FN_80F8A3                      ; $80F163 |
  BRA CODE_80F16E                           ; $80F166 |


CODE_80F168:
  LDA.W $1C08                               ; $80F168 |
  JSR.W CODE_FN_80F854                      ; $80F16B |

CODE_80F16E:
  LDA.W #$00A0                              ; $80F16E |
  STA.W $1FB8                               ; $80F171 |
  BRL CODE_FN_80F642                        ; $80F174 |


CODE_FN_80F177:
  LDA.W $1C06                               ; $80F177 |
  ASL A                                     ; $80F17A |
  TAX                                       ; $80F17B |
  JMP.W (PTR16_80F17F,X)                    ; $80F17C |

PTR16_80F17F:
  dw CODE_80F189                            ; $80F17F |
  dw CODE_80F19E                            ; $80F181 |
  dw CODE_80F214                            ; $80F183 |
  dw CODE_80F23C                            ; $80F185 |
  dw CODE_80F251                            ; $80F187 |

CODE_80F189:
  JSR.W CODE_FN_80F35C                      ; $80F189 |
  LDA.W $1C0A                               ; $80F18C |
  CMP.W $1C08                               ; $80F18F |
  BNE CODE_80F198                           ; $80F192 |
  INC A                                     ; $80F194 |
  STA.W $1C0A                               ; $80F195 |

CODE_80F198:
  JSR.W CODE_FN_80F3A3                      ; $80F198 |
  BRL CODE_JL_80EFB1                        ; $80F19B |


CODE_80F19E:
  LDA.W $1C0A                               ; $80F19E |
  STA.W $1C0C                               ; $80F1A1 |

CODE_80F1A4:
  LDA.B $30                                 ; $80F1A4 |
  BIT.W #$0800                              ; $80F1A6 |
  BEQ CODE_80F1B6                           ; $80F1A9 |
  LDA.W $1C0A                               ; $80F1AB |
  DEC A                                     ; $80F1AE |
  BPL CODE_80F1C7                           ; $80F1AF |
  LDA.W #$0003                              ; $80F1B1 |
  BRA CODE_80F1C7                           ; $80F1B4 |


CODE_80F1B6:
  BIT.W #$0400                              ; $80F1B6 |
  BEQ CODE_80F1E2                           ; $80F1B9 |
  LDA.W $1C0A                               ; $80F1BB |
  INC A                                     ; $80F1BE |
  CMP.W #$0004                              ; $80F1BF |
  BCC CODE_80F1C7                           ; $80F1C2 |
  TDC                                       ; $80F1C4 |

  BRA CODE_80F1C7                           ; $80F1C5 |


CODE_80F1C7:
  STA.W $1C0A                               ; $80F1C7 |
  CMP.W $1C08                               ; $80F1CA |
  BEQ CODE_80F1A4                           ; $80F1CD |
  LDA.W $1C0C                               ; $80F1CF |
  JSR.W CODE_FN_80F395                      ; $80F1D2 |
  LDA.W $1C0A                               ; $80F1D5 |
  JSR.W CODE_FN_80F3A3                      ; $80F1D8 |
  LDA.W #$0046                              ; $80F1DB |
  JSL.L push_sound_queue                    ; $80F1DE |

CODE_80F1E2:
  LDA.B $30                                 ; $80F1E2 |
  BIT.W #$C0C0                              ; $80F1E4 |
  BEQ CODE_80F213                           ; $80F1E7 |
  LDA.W #$0047                              ; $80F1E9 |
  JSL.L push_sound_queue                    ; $80F1EC |
  LDA.W $1C0A                               ; $80F1F0 |
  CMP.W #$0003                              ; $80F1F3 |
  BNE CODE_80F210                           ; $80F1F6 |
  LDA.W $1C08                               ; $80F1F8 |
  JSR.W CODE_FN_80F395                      ; $80F1FB |
  LDA.W $1C0A                               ; $80F1FE |
  JSR.W CODE_FN_80F395                      ; $80F201 |
  LDA.W #$0020                              ; $80F204 |
  STA.W $1FB8                               ; $80F207 |
  LDA.W #$0000                              ; $80F20A |
  BRL CODE_JL_80EFAA                        ; $80F20D |


CODE_80F210:
  BRL CODE_JL_80EFB1                        ; $80F210 |


CODE_80F213:
  RTS                                       ; $80F213 |


CODE_80F214:
  LDA.W $1C0A                               ; $80F214 |
  ASL A                                     ; $80F217 |
  TAX                                       ; $80F218 |
  LDA.L DATA8_81D1E0,X                      ; $80F219 |
  STA.B $00                                 ; $80F21D |
  LDA.W $1C08                               ; $80F21F |
  ASL A                                     ; $80F222 |

  TAX                                       ; $80F223 |
  LDA.L DATA8_81D1E0,X                      ; $80F224 |
  TAX                                       ; $80F228 |
  LDY.B $00                                 ; $80F229 |
  LDA.W #$06F5                              ; $80F22B |
  PHB                                       ; $80F22E |
  MVN $70,$70                               ; $80F22F |
  PLB                                       ; $80F232 |
  LDA.W $1C0A                               ; $80F233 |
  JSR.W CODE_FN_80FA13                      ; $80F236 |
  BRL CODE_JL_80EFB1                        ; $80F239 |


CODE_80F23C:
  LDA.W $1C0A                               ; $80F23C |
  JSR.W CODE_FN_80F403                      ; $80F23F |
  LDA.W $1C0A                               ; $80F242 |
  JSR.W CODE_FN_80F444                      ; $80F245 |
  LDA.W $1C0A                               ; $80F248 |
  JSR.W CODE_FN_80F485                      ; $80F24B |
  BRL CODE_JL_80EFB1                        ; $80F24E |


CODE_80F251:
  LDA.W $1C0A                               ; $80F251 |
  JSR.W CODE_FN_80F4CE                      ; $80F254 |
  LDA.W $1C0A                               ; $80F257 |
  JSR.W CODE_FN_80F4E7                      ; $80F25A |
  LDA.W $1C08                               ; $80F25D |
  JSR.W CODE_FN_80F395                      ; $80F260 |
  LDA.W $1C0A                               ; $80F263 |
  JSR.W CODE_FN_80F395                      ; $80F266 |
  LDA.W #$0000                              ; $80F269 |
  BRL CODE_JL_80EFAA                        ; $80F26C |


CODE_80F26F:
  JSR.W CODE_FN_80F28A                      ; $80F26F |
  LDA.W $1C08                               ; $80F272 |
  LDY.W $1C08                               ; $80F275 |
  JSR.W CODE_FN_80F601                      ; $80F278 |
  LDA.W $1C08                               ; $80F27B |
  JSR.W CODE_FN_80F854                      ; $80F27E |
  LDA.W #$0020                              ; $80F281 |
  STA.W $1FB8                               ; $80F284 |
  BRL CODE_FN_80F642                        ; $80F287 |


CODE_FN_80F28A:
  LDA.W $1C06                               ; $80F28A |
  ASL A                                     ; $80F28D |
  TAX                                       ; $80F28E |
  JMP.W (PTR16_80F292,X)                    ; $80F28F |

PTR16_80F292:
  dw CODE_80F29C                            ; $80F292 |
  dw CODE_80F2B5                            ; $80F294 |
  dw CODE_80F31A                            ; $80F296 |
  dw CODE_80F32F                            ; $80F298 |
  dw CODE_80F344                            ; $80F29A |

CODE_80F29C:
  LDY.W #$5304                              ; $80F29C |
  LDX.W #$0018                              ; $80F29F |
  JSR.W CODE_FN_80F3B1                      ; $80F2A2 |
  JSR.W CODE_FN_80F35C                      ; $80F2A5 |
  TDC                                       ; $80F2A8 |
  STA.W $1C08                               ; $80F2A9 |
  STA.W $1C0A                               ; $80F2AC |

  JSR.W CODE_FN_80F387                      ; $80F2AF |
  BRL CODE_JL_80EFB1                        ; $80F2B2 |


CODE_80F2B5:
  LDA.W $1C08                               ; $80F2B5 |
  STA.W $1C0C                               ; $80F2B8 |
  LDA.B $30                                 ; $80F2BB |
  BIT.W #$0800                              ; $80F2BD |
  BEQ CODE_80F2CD                           ; $80F2C0 |
  LDA.W $1C08                               ; $80F2C2 |

  DEC A                                     ; $80F2C5 |
  BPL CODE_80F2DE                           ; $80F2C6 |
  LDA.W #$0003                              ; $80F2C8 |
  BRA CODE_80F2DE                           ; $80F2CB |


CODE_80F2CD:
  BIT.W #$0400                              ; $80F2CD |
  BEQ CODE_80F2F4                           ; $80F2D0 |
  LDA.W $1C08                               ; $80F2D2 |
  INC A                                     ; $80F2D5 |
  CMP.W #$0004                              ; $80F2D6 |

  BCC CODE_80F2DE                           ; $80F2D9 |

  TDC                                       ; $80F2DB |
  BRA CODE_80F2DE                           ; $80F2DC |


CODE_80F2DE:
  STA.W $1C08                               ; $80F2DE |
  LDA.W $1C0C                               ; $80F2E1 |
  JSR.W CODE_FN_80F395                      ; $80F2E4 |
  LDA.W $1C08                               ; $80F2E7 |
  JSR.W CODE_FN_80F387                      ; $80F2EA |
  LDA.W #$0046                              ; $80F2ED |
  JSL.L push_sound_queue                    ; $80F2F0 |

CODE_80F2F4:
  LDA.B $30                                 ; $80F2F4 |
  BIT.W #$C0C0                              ; $80F2F6 |
  BEQ CODE_80F319                           ; $80F2F9 |
  LDA.W #$0047                              ; $80F2FB |
  JSL.L push_sound_queue                    ; $80F2FE |
  LDA.W $1C08                               ; $80F302 |
  CMP.W #$0003                              ; $80F305 |
  BNE CODE_80F316                           ; $80F308 |
  LDA.W $1C08                               ; $80F30A |

  JSR.W CODE_FN_80F395                      ; $80F30D |
  LDA.W #$0000                              ; $80F310 |
  BRL CODE_JL_80EFAA                        ; $80F313 |


CODE_80F316:
  INC.W $1C06                               ; $80F316 |

CODE_80F319:
  RTS                                       ; $80F319 |


CODE_80F31A:
  LDA.W $1C08                               ; $80F31A |

  PHA                                       ; $80F31D |
  JSL.L CODE_FL_96FC49                      ; $80F31E |
  PLA                                       ; $80F322 |
  JSR.W CODE_FN_80FA13                      ; $80F323 |
  LDA.W $1C08                               ; $80F326 |
  JSR.W CODE_FN_80F395                      ; $80F329 |
  BRL CODE_JL_80EFB1                        ; $80F32C |


CODE_80F32F:
  LDA.W $1C08                               ; $80F32F |
  JSR.W CODE_FN_80F403                      ; $80F332 |
  LDA.W $1C08                               ; $80F335 |
  JSR.W CODE_FN_80F444                      ; $80F338 |
  LDA.W $1C08                               ; $80F33B |
  JSR.W CODE_FN_80F485                      ; $80F33E |
  BRL CODE_JL_80EFB1                        ; $80F341 |


CODE_80F344:
  LDA.W $1C08                               ; $80F344 |
  JSR.W CODE_FN_80F4CE                      ; $80F347 |
  LDA.W $1C08                               ; $80F34A |
  JSR.W CODE_FN_80F4E7                      ; $80F34D |
  LDA.W $1C08                               ; $80F350 |
  JSR.W CODE_FN_80F395                      ; $80F353 |
  LDA.W #$0000                              ; $80F356 |
  BRL CODE_JL_80EFAA                        ; $80F359 |


CODE_FN_80F35C:
  LDA.W $1C04                               ; $80F35C |
  ASL A                                     ; $80F35F |
  TAX                                       ; $80F360 |
  LDA.L DATA8_81D1E6,X                      ; $80F361 |
  TAX                                       ; $80F365 |
  LDY.W #$5009                              ; $80F366 |
  BRA CODE_FN_80F3B1                        ; $80F369 |


CODE_FN_80F36B:
  ASL A                                     ; $80F36B |
  TAX                                       ; $80F36C |

  LDA.L DATA8_81D1F8,X                      ; $80F36D |
  TAY                                       ; $80F371 |
  LDA.L DATA8_81D1EE,X                      ; $80F372 |
  TAX                                       ; $80F376 |
  BRA CODE_FN_80F3B1                        ; $80F377 |


CODE_FN_80F379:
  ASL A                                     ; $80F379 |
  TAX                                       ; $80F37A |

  LDA.L DATA8_81D1F8,X                      ; $80F37B |
  TAY                                       ; $80F37F |
  LDA.L DATA8_81D202,X                      ; $80F380 |
  TAX                                       ; $80F384 |
  BRA CODE_FN_80F3B1                        ; $80F385 |


CODE_FN_80F387:
  ASL A                                     ; $80F387 |
  TAX                                       ; $80F388 |
  LDA.L DATA8_81D214,X                      ; $80F389 |

  TAY                                       ; $80F38D |
  LDA.L DATA8_81D20C,X                      ; $80F38E |
  TAX                                       ; $80F392 |
  BRA CODE_FN_80F3B1                        ; $80F393 |


CODE_FN_80F395:
  ASL A                                     ; $80F395 |
  TAX                                       ; $80F396 |
  LDA.L DATA8_81D214,X                      ; $80F397 |

  TAY                                       ; $80F39B |
  LDA.L DATA8_81D21C,X                      ; $80F39C |
  TAX                                       ; $80F3A0 |
  BRA CODE_FN_80F3B1                        ; $80F3A1 |


CODE_FN_80F3A3:
  ASL A                                     ; $80F3A3 |
  TAX                                       ; $80F3A4 |
  LDA.L DATA8_81D214,X                      ; $80F3A5 |
  TAY                                       ; $80F3A9 |
  LDA.L DATA8_81D224,X                      ; $80F3AA |
  TAX                                       ; $80F3AE |
  BRA CODE_FN_80F3B1                        ; $80F3AF |


CODE_FN_80F3B1:
  LDA.W #$3300                              ; $80F3B1 |
  STA.B $00                                 ; $80F3B4 |
  STY.B $02                                 ; $80F3B6 |

CODE_80F3B8:
  PHX                                       ; $80F3B8 |
  JSL.L CODE_FL_809622                      ; $80F3B9 |

  PLX                                       ; $80F3BD |

CODE_80F3BE:
  LDA.L DATA8_81D29E,X                      ; $80F3BE |
  INX                                       ; $80F3C2 |
  AND.W #$00FF                              ; $80F3C3 |
  CMP.W #$00FF                              ; $80F3C6 |
  BEQ CODE_80F3FE                           ; $80F3C9 |

  CMP.W #$00FE                              ; $80F3CB |
  BNE CODE_80F3E2                           ; $80F3CE |
  PHX                                       ; $80F3D0 |
  JSL.L CODE_FL_809663                      ; $80F3D1 |
  PLX                                       ; $80F3D5 |
  LDA.L DATA8_81D29E,X                      ; $80F3D6 |
  INX                                       ; $80F3DA |

  INX                                       ; $80F3DB |
  CLC                                       ; $80F3DC |

  ADC.B $02                                 ; $80F3DD |
  TAY                                       ; $80F3DF |
  BRA CODE_80F3B8                           ; $80F3E0 |


CODE_80F3E2:
  CMP.W #$00FD                              ; $80F3E2 |
  BNE CODE_80F3F4                           ; $80F3E5 |
  LDA.L DATA8_81D29E,X                      ; $80F3E7 |
  INX                                       ; $80F3EB |
  AND.W #$00FF                              ; $80F3EC |
  XBA                                       ; $80F3EF |
  STA.B $00                                 ; $80F3F0 |
  BRA CODE_80F3BE                           ; $80F3F2 |


CODE_80F3F4:
  ORA.B $00                                 ; $80F3F4 |
  PHX                                       ; $80F3F6 |
  JSL.L CODE_FL_809658                      ; $80F3F7 |

  PLX                                       ; $80F3FB |
  BRA CODE_80F3BE                           ; $80F3FC |


CODE_80F3FE:
  JSL.L CODE_FL_809663                      ; $80F3FE |
  RTS                                       ; $80F402 |


CODE_FN_80F403:
  ASL A                                     ; $80F403 |
  TAX                                       ; $80F404 |
  LDA.L DATA8_81D232,X                      ; $80F405 |
  TAY                                       ; $80F409 |
  LDA.L DATA8_81D22C,X                      ; $80F40A |
  TAX                                       ; $80F40E |
  LDA.L $700000,X                           ; $80F40F |
  STA.B $BE                                 ; $80F413 |
  PHY                                       ; $80F415 |
  PHD                                       ; $80F416 |
  JSL.L CODE_FL_84A5B0                      ; $80F417 |

  REP #$20                                  ; $80F41B |

  PLD                                       ; $80F41D |
  PLY                                       ; $80F41E |
  LDA.W #$0000                              ; $80F41F |
  STA.B $00                                 ; $80F422 |
  LDA.W #$182A                              ; $80F424 |
  LDX.W #$0008                              ; $80F427 |
  JSL.L CODE_FL_809671                      ; $80F42A |
  TYA                                       ; $80F42E |
  CLC                                       ; $80F42F |
  ADC.W #$0020                              ; $80F430 |
  TAY                                       ; $80F433 |
  LDA.W #$0000                              ; $80F434 |
  STA.B $00                                 ; $80F437 |
  LDA.W #$186A                              ; $80F439 |
  LDX.W #$0008                              ; $80F43C |
  JSL.L CODE_FL_809671                      ; $80F43F |
  RTS                                       ; $80F443 |


CODE_FN_80F444:
  ASL A                                     ; $80F444 |
  TAX                                       ; $80F445 |
  LDA.L DATA8_81D23E,X                      ; $80F446 |
  TAY                                       ; $80F44A |
  LDA.L DATA8_81D238,X                      ; $80F44B |
  TAX                                       ; $80F44F |
  LDA.L $700000,X                           ; $80F450 |
  STA.L $7002E2                             ; $80F454 |
  LDA.L $700002,X                           ; $80F458 |
  STA.L $7002E4                             ; $80F45C |
  PHY                                       ; $80F460 |
  PHD                                       ; $80F461 |
  LDA.W #$1820                              ; $80F462 |
  TCD                                       ; $80F465 |
  SEP #$20                                  ; $80F466 |
  JSL.L CODE_FL_84A69A                      ; $80F468 |
  REP #$20                                  ; $80F46C |
  LDA.W #$23AB                              ; $80F46E |

  STA.B $DC                                 ; $80F471 |
  PLD                                       ; $80F473 |
  PLY                                       ; $80F474 |
  LDA.W #$0000                              ; $80F475 |
  STA.B $00                                 ; $80F478 |
  LDA.W #$18F6                              ; $80F47A |
  LDX.W #$000E                              ; $80F47D |
  JSL.L CODE_FL_809671                      ; $80F480 |
  RTS                                       ; $80F484 |


CODE_FN_80F485:
  ASL A                                     ; $80F485 |
  TAX                                       ; $80F486 |
  LDA.L DATA8_81D24A,X                      ; $80F487 |
  TAY                                       ; $80F48B |
  LDA.L DATA8_81D244,X                      ; $80F48C |
  TAX                                       ; $80F490 |
  LDA.L $700000,X                           ; $80F491 |
  STA.B $BA                                 ; $80F495 |
  LDA.L $700002,X                           ; $80F497 |
  STA.B $BC                                 ; $80F49B |
  PHY                                       ; $80F49D |
  PHD                                       ; $80F49E |

  LDA.W #$1820                              ; $80F49F |
  TCD                                       ; $80F4A2 |
  JSL.L CODE_FL_84A575                      ; $80F4A3 |
  PLD                                       ; $80F4A7 |
  PLY                                       ; $80F4A8 |
  LDA.W #$0000                              ; $80F4A9 |
  STA.B $00                                 ; $80F4AC |
  LDA.W #$1834                              ; $80F4AE |
  LDX.W #$0010                              ; $80F4B1 |
  JSL.L CODE_FL_809671                      ; $80F4B4 |
  TYA                                       ; $80F4B8 |
  CLC                                       ; $80F4B9 |
  ADC.W #$0020                              ; $80F4BA |

  TAY                                       ; $80F4BD |
  LDA.W #$0000                              ; $80F4BE |

  STA.B $00                                 ; $80F4C1 |

  LDA.W #$1874                              ; $80F4C3 |
  LDX.W #$0010                              ; $80F4C6 |
  JSL.L CODE_FL_809671                      ; $80F4C9 |
  RTS                                       ; $80F4CD |


CODE_FN_80F4CE:
  ASL A                                     ; $80F4CE |

  TAX                                       ; $80F4CF |
  LDA.L DATA8_81D250,X                      ; $80F4D0 |
  TAY                                       ; $80F4D4 |
  LDA.L DATA8_81D256,X                      ; $80F4D5 |
  TAX                                       ; $80F4D9 |
  LDA.L $700000,X                           ; $80F4DA |
  TAX                                       ; $80F4DE |

  LDA.L DATA8_81D25C,X                      ; $80F4DF |
  TAX                                       ; $80F4E3 |
  BRL CODE_FN_80F3B1                        ; $80F4E4 |


CODE_FN_80F4E7:
  ASL A                                     ; $80F4E7 |
  TAX                                       ; $80F4E8 |
  LDA.L DATA8_81D292,X                      ; $80F4E9 |
  TAY                                       ; $80F4ED |
  LDA.L DATA8_81D298,X                      ; $80F4EE |
  TAX                                       ; $80F4F2 |
  LDA.L $700004,X                           ; $80F4F3 |
  STA.B $08                                 ; $80F4F7 |
  SEP #$20                                  ; $80F4F9 |
  LDA.L $700001,X                           ; $80F4FB |

  LSR A                                     ; $80F4FF |
  LSR A                                     ; $80F500 |

  LSR A                                     ; $80F501 |
  LSR A                                     ; $80F502 |
  STA.B $01                                 ; $80F503 |
  LDA.L $700001,X                           ; $80F505 |
  STA.B $02                                 ; $80F509 |
  LDA.L $700000,X                           ; $80F50B |

  LSR A                                     ; $80F50F |
  LSR A                                     ; $80F510 |

  LSR A                                     ; $80F511 |
  LSR A                                     ; $80F512 |
  STA.B $03                                 ; $80F513 |
  LDA.L $700000,X                           ; $80F515 |
  STA.B $04                                 ; $80F519 |
  REP #$20                                  ; $80F51B |
  JSL.L CODE_FL_809622                      ; $80F51D |
  LDA.W #$2300                              ; $80F521 |
  STA.B $06                                 ; $80F524 |
  LDA.B $08                                 ; $80F526 |
  BEQ CODE_80F536                           ; $80F528 |
  PHA                                       ; $80F52A |
  CMP.W #$2FB7                              ; $80F52B |
  BNE CODE_80F535                           ; $80F52E |
  LDA.W #$2700                              ; $80F530 |
  STA.B $06                                 ; $80F533 |

CODE_80F535:
  PLA                                       ; $80F535 |

CODE_80F536:
  JSL.L CODE_FL_809658                      ; $80F536 |
  LDA.B $01                                 ; $80F53A |
  AND.W #$000F                              ; $80F53C |
  ORA.W #$00A0                              ; $80F53F |
  ORA.B $06                                 ; $80F542 |
  JSL.L CODE_FL_809658                      ; $80F544 |

  LDA.B $02                                 ; $80F548 |
  AND.W #$000F                              ; $80F54A |
  ORA.W #$00A0                              ; $80F54D |
  ORA.B $06                                 ; $80F550 |
  JSL.L CODE_FL_809658                      ; $80F552 |
  LDA.W #$00F3                              ; $80F556 |
  ORA.B $06                                 ; $80F559 |
  JSL.L CODE_FL_809658                      ; $80F55B |
  LDA.B $03                                 ; $80F55F |
  AND.W #$000F                              ; $80F561 |
  ORA.W #$00A0                              ; $80F564 |
  ORA.B $06                                 ; $80F567 |
  JSL.L CODE_FL_809658                      ; $80F569 |
  LDA.B $04                                 ; $80F56D |
  AND.W #$000F                              ; $80F56F |
  ORA.W #$00A0                              ; $80F572 |
  ORA.B $06                                 ; $80F575 |
  JSL.L CODE_FL_809658                      ; $80F577 |
  JSL.L CODE_FL_809663                      ; $80F57B |
  RTS                                       ; $80F57F |


CODE_FN_80F580:
  SEP #$20                                  ; $80F580 |
  LDA.B #$20                                ; $80F582 |
  SEC                                       ; $80F584 |
  SBC.W $16B2                               ; $80F585 |
  STA.L $7EDAC4                             ; $80F588 |
  STA.L $7EDEC4                             ; $80F58C |
  LDA.B #$30                                ; $80F590 |
  STA.L $7EDAC7                             ; $80F592 |
  STA.L $7EDEC7                             ; $80F596 |
  STA.L $7EDACA                             ; $80F59A |
  STA.L $7EDECA                             ; $80F59E |
  STA.L $7EDACD                             ; $80F5A2 |
  STA.L $7EDECD                             ; $80F5A6 |
  LDA.B #$01                                ; $80F5AA |
  STA.L $7EDAD0                             ; $80F5AC |
  STA.L $7EDED0                             ; $80F5B0 |
  TDC                                       ; $80F5B4 |
  STA.L $7EDAD3                             ; $80F5B5 |
  STA.L $7EDED3                             ; $80F5B9 |
  REP #$20                                  ; $80F5BD |
  LDY.W #$0001                              ; $80F5BF |
  JSL.L CODE_FL_80972B                      ; $80F5C2 |
  JSR.W CODE_FN_80F5E5                      ; $80F5C6 |

CODE_FN_80F5C9:
  LDA.W $16A2                               ; $80F5C9 |
  STA.L $7EDAC5                             ; $80F5CC |
  STA.L $7EDAD1                             ; $80F5D0 |
  CLC                                       ; $80F5D4 |
  ADC.W #$0008                              ; $80F5D5 |
  STA.L $7EDAC8                             ; $80F5D8 |
  STA.L $7EDACB                             ; $80F5DC |
  STA.L $7EDACE                             ; $80F5E0 |
  RTS                                       ; $80F5E4 |


CODE_FN_80F5E5:
  LDA.W $16A2                               ; $80F5E5 |
  STA.L $7EDEC5                             ; $80F5E8 |
  STA.L $7EDED1                             ; $80F5EC |
  CLC                                       ; $80F5F0 |
  ADC.W #$0008                              ; $80F5F1 |
  STA.L $7EDEC8                             ; $80F5F4 |
  STA.L $7EDECB                             ; $80F5F8 |
  STA.L $7EDECE                             ; $80F5FC |
  RTS                                       ; $80F600 |


CODE_FN_80F601:
  PHA                                       ; $80F601 |
  PHY                                       ; $80F602 |
  LDA.L $7EDAC0                             ; $80F603 |
  LSR A                                     ; $80F607 |
  BCC CODE_80F612                           ; $80F608 |
  JSR.W CODE_FN_80F5C9                      ; $80F60A |
  LDA.W #$DAC8                              ; $80F60D |
  BRA CODE_80F618                           ; $80F610 |


CODE_80F612:
  JSR.W CODE_FN_80F5E5                      ; $80F612 |
  LDA.W #$DEC8                              ; $80F615 |

CODE_80F618:
  STA.B $00                                 ; $80F618 |
  LDA.W #$007E                              ; $80F61A |
  STA.B $02                                 ; $80F61D |
  PLA                                       ; $80F61F |
  CMP.W #$0003                              ; $80F620 |
  BCS CODE_80F628                           ; $80F623 |
  JSR.W CODE_FN_80F632                      ; $80F625 |

CODE_80F628:
  PLA                                       ; $80F628 |
  CMP.W #$0003                              ; $80F629 |
  BCS CODE_80F631                           ; $80F62C |
  JSR.W CODE_FN_80F632                      ; $80F62E |

CODE_80F631:
  RTS                                       ; $80F631 |


CODE_FN_80F632:
  STA.B $04                                 ; $80F632 |
  ASL A                                     ; $80F634 |
  ADC.B $04                                 ; $80F635 |
  TAY                                       ; $80F637 |
  LDA.W $16A2                               ; $80F638 |
  SEC                                       ; $80F63B |
  SBC.W #$0004                              ; $80F63C |
  STA.B [$00],Y                             ; $80F63F |
  RTS                                       ; $80F641 |


CODE_FN_80F642:
  LDA.L $7EDAC0                             ; $80F642 |
  EOR.W #$0001                              ; $80F646 |
  STA.L $7EDAC0                             ; $80F649 |
  RTS                                       ; $80F64D |


CODE_FN_80F64E:
  SEP #$20                                  ; $80F64E |
  LDA.B #$24                                ; $80F650 |
  SEC                                       ; $80F652 |
  SBC.W $16B2                               ; $80F653 |
  STA.L $7EE2C4                             ; $80F656 |
  STA.L $7EE6C4                             ; $80F65A |
  STA.L $7EE304                             ; $80F65E |
  STA.L $7EE704                             ; $80F662 |
  STA.L $7EEAC4                             ; $80F666 |
  STA.L $7EECC4                             ; $80F66A |
  LDA.B #$28                                ; $80F66E |
  STA.L $7EE2C7                             ; $80F670 |
  STA.L $7EE6C7                             ; $80F674 |
  STA.L $7EE2CD                             ; $80F678 |
  STA.L $7EE6CD                             ; $80F67C |
  STA.L $7EE2D3                             ; $80F680 |
  STA.L $7EE6D3                             ; $80F684 |
  STA.L $7EE307                             ; $80F688 |
  STA.L $7EE707                             ; $80F68C |
  STA.L $7EE30D                             ; $80F690 |
  STA.L $7EE70D                             ; $80F694 |
  STA.L $7EE313                             ; $80F698 |
  STA.L $7EE713                             ; $80F69C |
  STA.L $7EEAC6                             ; $80F6A0 |
  STA.L $7EECC6                             ; $80F6A4 |
  STA.L $7EEACA                             ; $80F6A8 |
  STA.L $7EECCA                             ; $80F6AC |
  STA.L $7EEACE                             ; $80F6B0 |
  STA.L $7EECCE                             ; $80F6B4 |
  LDA.B #$08                                ; $80F6B8 |
  STA.L $7EE2CA                             ; $80F6BA |
  STA.L $7EE6CA                             ; $80F6BE |
  STA.L $7EE2D0                             ; $80F6C2 |
  STA.L $7EE6D0                             ; $80F6C6 |
  STA.L $7EE30A                             ; $80F6CA |
  STA.L $7EE70A                             ; $80F6CE |
  STA.L $7EE310                             ; $80F6D2 |
  STA.L $7EE710                             ; $80F6D6 |
  STA.L $7EEAC8                             ; $80F6DA |
  STA.L $7EECC8                             ; $80F6DE |
  STA.L $7EEACC                             ; $80F6E2 |
  STA.L $7EECCC                             ; $80F6E6 |
  LDA.B #$10                                ; $80F6EA |
  STA.L $7EE2D6                             ; $80F6EC |
  STA.L $7EE6D6                             ; $80F6F0 |
  STA.L $7EE316                             ; $80F6F4 |
  STA.L $7EE716                             ; $80F6F8 |
  STA.L $7EEAD0                             ; $80F6FC |
  STA.L $7EECD0                             ; $80F700 |
  LDA.B #$18                                ; $80F704 |
  STA.L $7EE2D9                             ; $80F706 |
  STA.L $7EE6D9                             ; $80F70A |
  STA.L $7EE319                             ; $80F70E |
  STA.L $7EE719                             ; $80F712 |
  STA.L $7EEAD2                             ; $80F716 |
  STA.L $7EECD2                             ; $80F71A |
  LDA.B #$01                                ; $80F71E |
  STA.L $7EE2DC                             ; $80F720 |
  STA.L $7EE6DC                             ; $80F724 |
  STA.L $7EE31C                             ; $80F728 |
  STA.L $7EE71C                             ; $80F72C |
  STA.L $7EEAD4                             ; $80F730 |
  STA.L $7EECD4                             ; $80F734 |
  TDC                                       ; $80F738 |
  STA.L $7EE2DF                             ; $80F739 |
  STA.L $7EE6DF                             ; $80F73D |
  STA.L $7EE31F                             ; $80F741 |
  STA.L $7EE71F                             ; $80F745 |
  STA.L $7EEAD6                             ; $80F749 |
  STA.L $7EECD6                             ; $80F74D |

  REP #$20                                  ; $80F751 |

  JSR.W CODE_FN_80F75C                      ; $80F753 |
  JSR.W CODE_FN_80F7B0                      ; $80F756 |
  JSR.W CODE_FN_80F804                      ; $80F759 |

CODE_FN_80F75C:
  LDA.W #$00FF                              ; $80F75C |
  STA.L $7EE2C5                             ; $80F75F |
  STA.L $7EE2C8                             ; $80F763 |
  STA.L $7EE2CB                             ; $80F767 |

  STA.L $7EE2CE                             ; $80F76B |

  STA.L $7EE2D1                             ; $80F76F |
  STA.L $7EE2D4                             ; $80F773 |
  STA.L $7EE2D7                             ; $80F777 |
  STA.L $7EE2DA                             ; $80F77B |
  STA.L $7EE2DD                             ; $80F77F |
  SEP #$20                                  ; $80F783 |
  LDA.B #$E0                                ; $80F785 |
  STA.L $7EEAC5                             ; $80F787 |
  STA.L $7EEAC9                             ; $80F78B |
  STA.L $7EEACD                             ; $80F78F |
  STA.L $7EEAD1                             ; $80F793 |
  STA.L $7EEAD5                             ; $80F797 |
  LDA.B #$E0                                ; $80F79B |
  STA.L $7EEAC7                             ; $80F79D |
  STA.L $7EEACB                             ; $80F7A1 |
  STA.L $7EEACF                             ; $80F7A5 |
  STA.L $7EEAD3                             ; $80F7A9 |
  REP #$20                                  ; $80F7AD |
  RTS                                       ; $80F7AF |


CODE_FN_80F7B0:
  LDA.W #$00FF                              ; $80F7B0 |
  STA.L $7EE6C5                             ; $80F7B3 |
  STA.L $7EE6C8                             ; $80F7B7 |
  STA.L $7EE6CB                             ; $80F7BB |
  STA.L $7EE6CE                             ; $80F7BF |
  STA.L $7EE6D1                             ; $80F7C3 |
  STA.L $7EE6D4                             ; $80F7C7 |
  STA.L $7EE6D7                             ; $80F7CB |
  STA.L $7EE6DA                             ; $80F7CF |
  STA.L $7EE6DD                             ; $80F7D3 |
  SEP #$20                                  ; $80F7D7 |
  LDA.B #$E0                                ; $80F7D9 |
  STA.L $7EECC5                             ; $80F7DB |
  STA.L $7EECC9                             ; $80F7DF |
  STA.L $7EECCD                             ; $80F7E3 |
  STA.L $7EECD1                             ; $80F7E7 |
  STA.L $7EECD5                             ; $80F7EB |
  LDA.B #$E0                                ; $80F7EF |

  STA.L $7EECC7                             ; $80F7F1 |

  STA.L $7EECCB                             ; $80F7F5 |
  STA.L $7EECCF                             ; $80F7F9 |
  STA.L $7EECD3                             ; $80F7FD |
  REP #$20                                  ; $80F801 |
  RTS                                       ; $80F803 |


CODE_FN_80F804:
  LDA.W #$00FF                              ; $80F804 |
  STA.L $7EE305                             ; $80F807 |
  STA.L $7EE308                             ; $80F80B |
  STA.L $7EE30B                             ; $80F80F |
  STA.L $7EE30E                             ; $80F813 |

  STA.L $7EE311                             ; $80F817 |
  STA.L $7EE314                             ; $80F81B |
  STA.L $7EE317                             ; $80F81F |
  STA.L $7EE31A                             ; $80F823 |
  STA.L $7EE31D                             ; $80F827 |
  RTS                                       ; $80F82B |


CODE_FN_80F82C:
  LDA.W #$00FF                              ; $80F82C |
  STA.L $7EE705                             ; $80F82F |
  STA.L $7EE708                             ; $80F833 |
  STA.L $7EE70B                             ; $80F837 |
  STA.L $7EE70E                             ; $80F83B |
  STA.L $7EE711                             ; $80F83F |
  STA.L $7EE714                             ; $80F843 |
  STA.L $7EE717                             ; $80F847 |
  STA.L $7EE71A                             ; $80F84B |
  STA.L $7EE71D                             ; $80F84F |
  RTS                                       ; $80F853 |


CODE_FN_80F854:
  PHA                                       ; $80F854 |
  LDA.L $7EDAC0                             ; $80F855 |
  LSR A                                     ; $80F859 |
  BCC CODE_80F867                           ; $80F85A |
  JSR.W CODE_FN_80F75C                      ; $80F85C |
  LDA.W #$E2C4                              ; $80F85F |
  LDY.W #$EAC4                              ; $80F862 |
  BRA CODE_80F870                           ; $80F865 |


CODE_80F867:
  JSR.W CODE_FN_80F7B0                      ; $80F867 |
  LDA.W #$E6C4                              ; $80F86A |
  LDY.W #$ECC4                              ; $80F86D |

CODE_80F870:
  STA.B $08                                 ; $80F870 |
  STY.B $0C                                 ; $80F872 |
  LDA.W #$007E                              ; $80F874 |
  STA.B $0A                                 ; $80F877 |
  PLA                                       ; $80F879 |
  PHA                                       ; $80F87A |
  ASL A                                     ; $80F87B |
  TAY                                       ; $80F87C |
  LDA.W LOOSE_OP_00D1D6,Y                   ; $80F87D |
  CLC                                       ; $80F880 |
  ADC.B $0C                                 ; $80F881 |

  TAX                                       ; $80F883 |
  SEP #$20                                  ; $80F884 |
  LDA.B $42                                 ; $80F886 |
  LSR A                                     ; $80F888 |

  LSR A                                     ; $80F889 |
  LSR A                                     ; $80F88A |
  AND.B #$0F                                ; $80F88B |
  EOR.B #$FF                                ; $80F88D |
  SEC                                       ; $80F88F |
  ADC.B #$08                                ; $80F890 |
  BPL CODE_80F897                           ; $80F892 |
  EOR.B #$FF                                ; $80F894 |
  INC A                                     ; $80F896 |

CODE_80F897:
  CLC                                       ; $80F897 |
  ADC.B #$84                                ; $80F898 |
  STA.L $7E0000,X                           ; $80F89A |
  REP #$20                                  ; $80F89E |
  PLA                                       ; $80F8A0 |
  BRA CODE_80F8F4                           ; $80F8A1 |


CODE_FN_80F8A3:
  PHA                                       ; $80F8A3 |
  LDA.L $7EDAC0                             ; $80F8A4 |
  LSR A                                     ; $80F8A8 |

  BCC CODE_80F8B6                           ; $80F8A9 |
  JSR.W CODE_FN_80F804                      ; $80F8AB |
  LDA.W #$E304                              ; $80F8AE |
  LDY.W #$EAC4                              ; $80F8B1 |
  BRA CODE_80F8BF                           ; $80F8B4 |


CODE_80F8B6:
  JSR.W CODE_FN_80F82C                      ; $80F8B6 |
  LDA.W #$E704                              ; $80F8B9 |
  LDY.W #$ECC4                              ; $80F8BC |

CODE_80F8BF:
  STA.B $08                                 ; $80F8BF |
  STY.B $0C                                 ; $80F8C1 |

  LDA.W #$007E                              ; $80F8C3 |
  STA.B $0A                                 ; $80F8C6 |
  PLA                                       ; $80F8C8 |

  PHA                                       ; $80F8C9 |
  ASL A                                     ; $80F8CA |
  TAY                                       ; $80F8CB |
  LDA.W LOOSE_OP_00D1D6,Y                   ; $80F8CC |
  CLC                                       ; $80F8CF |
  ADC.B $0C                                 ; $80F8D0 |
  TAX                                       ; $80F8D2 |
  SEP #$20                                  ; $80F8D3 |
  LDA.B $42                                 ; $80F8D5 |
  LSR A                                     ; $80F8D7 |
  LSR A                                     ; $80F8D8 |
  LSR A                                     ; $80F8D9 |
  AND.B #$0F                                ; $80F8DA |
  EOR.B #$FF                                ; $80F8DC |
  SEC                                       ; $80F8DE |
  ADC.B #$08                                ; $80F8DF |
  BPL CODE_80F8E6                           ; $80F8E1 |
  EOR.B #$FF                                ; $80F8E3 |
  INC A                                     ; $80F8E5 |

CODE_80F8E6:
  CLC                                       ; $80F8E6 |
  ADC.B #$44                                ; $80F8E7 |
  STA.L $7E0000,X                           ; $80F8E9 |
  REP #$20                                  ; $80F8ED |
  PLA                                       ; $80F8EF |
  CLC                                       ; $80F8F0 |
  ADC.W #$0005                              ; $80F8F1 |

CODE_80F8F4:
  ASL A                                     ; $80F8F4 |
  STA.B $00                                 ; $80F8F5 |
  ASL A                                     ; $80F8F7 |
  CLC                                       ; $80F8F8 |
  ADC.B $00                                 ; $80F8F9 |
  TAX                                       ; $80F8FB |
  LDA.L DATA8_81D19A,X                      ; $80F8FC |
  CLC                                       ; $80F900 |
  ADC.B $08                                 ; $80F901 |
  STA.B $00                                 ; $80F903 |
  LDA.L DATA8_81D19C,X                      ; $80F905 |
  STA.B $02                                 ; $80F909 |
  LDA.L DATA8_81D19E,X                      ; $80F90B |
  STA.B $04                                 ; $80F90F |
  LDX.B $00                                 ; $80F911 |
  SEP #$20                                  ; $80F913 |
  LDA.L $7E0000,X                           ; $80F915 |
  EOR.B #$FF                                ; $80F919 |
  SEC                                       ; $80F91B |
  ADC.B $04                                 ; $80F91C |
  STA.B $06                                 ; $80F91E |
  LDA.L $7E0000,X                           ; $80F920 |
  EOR.B #$FF                                ; $80F924 |
  SEC                                       ; $80F926 |
  ADC.B $05                                 ; $80F927 |
  STA.B $07                                 ; $80F929 |
  LDY.B $02                                 ; $80F92B |
  LDA.B $06                                 ; $80F92D |
  STA.B [$08],Y                             ; $80F92F |
  INY                                       ; $80F931 |
  LDA.B $07                                 ; $80F932 |
  STA.B [$08],Y                             ; $80F934 |
  REP #$20                                  ; $80F936 |
  RTS                                       ; $80F938 |


CODE_FN_80F939:
  LDA.W #$0000                              ; $80F939 |
  JSR.W CODE_FN_80F9FD                      ; $80F93C |
  BCS CODE_80F946                           ; $80F93F |
  JSR.W CODE_FN_80FA39                      ; $80F941 |
  BCC CODE_80F94F                           ; $80F944 |

CODE_80F946:
  PHA                                       ; $80F946 |
  JSL.L CODE_FL_96FC49                      ; $80F947 |
  PLA                                       ; $80F94B |
  JSR.W CODE_FN_80FA13                      ; $80F94C |

CODE_80F94F:
  LDA.W #$0001                              ; $80F94F |
  JSR.W CODE_FN_80F9FD                      ; $80F952 |
  BCS CODE_80F95C                           ; $80F955 |
  JSR.W CODE_FN_80FA39                      ; $80F957 |
  BCC CODE_80F965                           ; $80F95A |

CODE_80F95C:
  PHA                                       ; $80F95C |
  JSL.L CODE_FL_96FC49                      ; $80F95D |
  PLA                                       ; $80F961 |
  JSR.W CODE_FN_80FA13                      ; $80F962 |

CODE_80F965:
  LDA.W #$0002                              ; $80F965 |
  JSR.W CODE_FN_80F9FD                      ; $80F968 |

  BCS CODE_80F972                           ; $80F96B |

  JSR.W CODE_FN_80FA39                      ; $80F96D |
  BCC CODE_80F97B                           ; $80F970 |

CODE_80F972:
  PHA                                       ; $80F972 |
  JSL.L CODE_FL_96FC49                      ; $80F973 |
  PLA                                       ; $80F977 |
  JSR.W CODE_FN_80FA13                      ; $80F978 |

CODE_80F97B:
  RTS                                       ; $80F97B |


CODE_FN_80F97C:
  LDA.W #$0000                              ; $80F97C |
  JSR.W CODE_FN_80F998                      ; $80F97F |
  BCS CODE_80F996                           ; $80F982 |
  LDA.W #$0001                              ; $80F984 |
  JSR.W CODE_FN_80F998                      ; $80F987 |
  BCS CODE_80F996                           ; $80F98A |
  LDA.W #$0002                              ; $80F98C |
  JSR.W CODE_FN_80F998                      ; $80F98F |
  BCS CODE_80F996                           ; $80F992 |
  CLC                                       ; $80F994 |
  RTS                                       ; $80F995 |


CODE_80F996:
  SEC                                       ; $80F996 |
  RTS                                       ; $80F997 |


CODE_FN_80F998:
  PHA                                       ; $80F998 |
  ASL A                                     ; $80F999 |
  TAX                                       ; $80F99A |
  LDA.L DATA8_81D1E0,X                      ; $80F99B |
  TAX                                       ; $80F99F |
  CLC                                       ; $80F9A0 |
  ADC.W #$0573                              ; $80F9A1 |
  CMP.L $7006F6,X                           ; $80F9A4 |
  BNE CODE_80F9BD                           ; $80F9A8 |
  EOR.W #$FFFF                              ; $80F9AA |
  CMP.L $7006F8,X                           ; $80F9AD |
  BNE CODE_80F9BD                           ; $80F9B1 |
  ASL A                                     ; $80F9B3 |
  CMP.L $7006FA,X                           ; $80F9B4 |
  BNE CODE_80F9BD                           ; $80F9B8 |
  PLA                                       ; $80F9BA |
  CLC                                       ; $80F9BB |
  RTS                                       ; $80F9BC |


CODE_80F9BD:
  PLA                                       ; $80F9BD |
  SEC                                       ; $80F9BE |
  RTS                                       ; $80F9BF |

  LDY.W #$000F                              ; $80F9C0 |

CODE_80F9C3:
  TYA                                       ; $80F9C3 |
  STA.L $7008FC                             ; $80F9C4 |
  DEC A                                     ; $80F9C8 |
  STA.L $700FFC                             ; $80F9C9 |
  DEC A                                     ; $80F9CD |
  STA.L $7016FC                             ; $80F9CE |
  DEC A                                     ; $80F9D2 |
  STA.L $701DFC                             ; $80F9D3 |
  TYA                                       ; $80F9D7 |
  CMP.L $7008FC                             ; $80F9D8 |
  BNE CODE_80F9FB                           ; $80F9DC |
  DEC A                                     ; $80F9DE |
  CMP.L $700FFC                             ; $80F9DF |
  BNE CODE_80F9FB                           ; $80F9E3 |
  DEC A                                     ; $80F9E5 |
  CMP.L $7016FC                             ; $80F9E6 |
  BNE CODE_80F9FB                           ; $80F9EA |
  DEC A                                     ; $80F9EC |
  CMP.L $701DFC                             ; $80F9ED |
  BNE CODE_80F9FB                           ; $80F9F1 |
  DEY                                       ; $80F9F3 |
  DEY                                       ; $80F9F4 |
  DEY                                       ; $80F9F5 |
  DEY                                       ; $80F9F6 |
  BNE CODE_80F9C3                           ; $80F9F7 |
  CLC                                       ; $80F9F9 |
  RTS                                       ; $80F9FA |


CODE_80F9FB:
  SEC                                       ; $80F9FB |
  RTS                                       ; $80F9FC |


CODE_FN_80F9FD:
  PHA                                       ; $80F9FD |
  JSR.W CODE_FN_80FA1F                      ; $80F9FE |
  LDX.B $00                                 ; $80FA01 |
  CMP.L $7006FE,X                           ; $80FA03 |
  BEQ CODE_80FA0C                           ; $80FA07 |
  PLA                                       ; $80FA09 |
  SEC                                       ; $80FA0A |
  RTS                                       ; $80FA0B |


CODE_80FA0C:
  PLA                                       ; $80FA0C |
  CLC                                       ; $80FA0D |

  RTS                                       ; $80FA0E |


CODE_FL_80FA0F:
  JSR.W CODE_FN_80FA13                      ; $80FA0F |

  RTL                                       ; $80FA12 |


CODE_FN_80FA13:
  PHA                                       ; $80FA13 |
  JSR.W CODE_FN_80FA1F                      ; $80FA14 |
  LDX.B $00                                 ; $80FA17 |
  STA.L $7006FE,X                           ; $80FA19 |
  PLA                                       ; $80FA1D |
  RTS                                       ; $80FA1E |


CODE_FN_80FA1F:
  ASL A                                     ; $80FA1F |
  TAX                                       ; $80FA20 |
  LDA.L DATA8_81D1E0,X                      ; $80FA21 |
  STA.B $00                                 ; $80FA25 |
  LDA.W #$0070                              ; $80FA27 |
  STA.B $02                                 ; $80FA2A |
  LDA.B $00                                 ; $80FA2C |

  CLC                                       ; $80FA2E |
  LDY.W #$06F4                              ; $80FA2F |

CODE_80FA32:
  ADC.B [$00],Y                             ; $80FA32 |
  DEY                                       ; $80FA34 |
  DEY                                       ; $80FA35 |
  BPL CODE_80FA32                           ; $80FA36 |
  RTS                                       ; $80FA38 |


CODE_FN_80FA39:
  PHA                                       ; $80FA39 |
  ASL A                                     ; $80FA3A |
  TAX                                       ; $80FA3B |
  LDA.L DATA8_81D1E0,X                      ; $80FA3C |
  TAX                                       ; $80FA40 |
  LDA.L $700090,X                           ; $80FA41 |
  STA.B $00                                 ; $80FA45 |
  AND.W #$000F                              ; $80FA47 |

  CMP.W #$000A                              ; $80FA4A |
  BCS CODE_80FACC                           ; $80FA4D |
  LDA.B $00                                 ; $80FA4F |
  AND.W #$00F0                              ; $80FA51 |
  CMP.W #$00A0                              ; $80FA54 |
  BCS CODE_80FACC                           ; $80FA57 |
  LDA.B $00                                 ; $80FA59 |
  AND.W #$0F00                              ; $80FA5B |
  CMP.W #$0A00                              ; $80FA5E |
  BCS CODE_80FACC                           ; $80FA61 |
  LDA.B $00                                 ; $80FA63 |
  AND.W #$F000                              ; $80FA65 |
  CMP.W #$A000                              ; $80FA68 |
  BCS CODE_80FACC                           ; $80FA6B |
  LDA.L $700092,X                           ; $80FA6D |
  AND.W #$00FF                              ; $80FA71 |
  CMP.W #$0021                              ; $80FA74 |
  BCS CODE_80FACC                           ; $80FA77 |
  LDA.L $700094,X                           ; $80FA79 |
  AND.W #$00FF                              ; $80FA7D |
  CMP.W #$0021                              ; $80FA80 |
  BCS CODE_80FACC                           ; $80FA83 |
  LDA.L $7000E2,X                           ; $80FA85 |
  STA.B $00                                 ; $80FA89 |
  AND.W #$000F                              ; $80FA8B |
  CMP.W #$000A                              ; $80FA8E |
  BCS CODE_80FACC                           ; $80FA91 |
  LDA.B $00                                 ; $80FA93 |
  AND.W #$00F0                              ; $80FA95 |
  CMP.W #$00A0                              ; $80FA98 |
  BCS CODE_80FACC                           ; $80FA9B |
  LDA.B $00                                 ; $80FA9D |
  AND.W #$0F00                              ; $80FA9F |
  CMP.W #$0A00                              ; $80FAA2 |
  BCS CODE_80FACC                           ; $80FAA5 |
  LDA.L $7000E4,X                           ; $80FAA7 |
  STA.B $00                                 ; $80FAAB |
  AND.W #$000F                              ; $80FAAD |
  CMP.W #$000A                              ; $80FAB0 |
  BCS CODE_80FACC                           ; $80FAB3 |
  LDA.B $00                                 ; $80FAB5 |
  AND.W #$00F0                              ; $80FAB7 |
  CMP.W #$00A0                              ; $80FABA |
  BCS CODE_80FACC                           ; $80FABD |
  LDA.B $00                                 ; $80FABF |
  AND.W #$0F00                              ; $80FAC1 |
  CMP.W #$0A00                              ; $80FAC4 |
  BCS CODE_80FACC                           ; $80FAC7 |
  PLA                                       ; $80FAC9 |
  CLC                                       ; $80FACA |
  RTS                                       ; $80FACB |


CODE_80FACC:
  PLA                                       ; $80FACC |
  SEC                                       ; $80FACD |
  RTS                                       ; $80FACE |


CODE_FN_80FACF:
  LDA.W #$0E73                              ; $80FACF |
  STA.L $700FF6                             ; $80FAD2 |
  EOR.W #$FFFF                              ; $80FAD6 |
  STA.L $700FF8                             ; $80FAD9 |
  ASL A                                     ; $80FADD |
  STA.L $700FFA                             ; $80FADE |
  LDA.W #$1573                              ; $80FAE2 |
  STA.L $7016F6                             ; $80FAE5 |
  EOR.W #$FFFF                              ; $80FAE9 |
  STA.L $7016F8                             ; $80FAEC |
  ASL A                                     ; $80FAF0 |
  STA.L $7016FA                             ; $80FAF1 |
  LDA.W #$1C73                              ; $80FAF5 |
  STA.L $701DF6                             ; $80FAF8 |
  EOR.W #$FFFF                              ; $80FAFC |
  STA.L $701DF8                             ; $80FAFF |
  ASL A                                     ; $80FB03 |
  STA.L $701DFA                             ; $80FB04 |
  LDA.W #$0000                              ; $80FB08 |
  STA.L $7008F4                             ; $80FB0B |
  RTS                                       ; $80FB0F |


CODE_FL_80FB10:
  JSR.W CODE_FN_80FB14                      ; $80FB10 |
  RTL                                       ; $80FB13 |


CODE_FN_80FB14:
  LDA.B $C2                                 ; $80FB14 |
  ASL A                                     ; $80FB16 |
  TAX                                       ; $80FB17 |
  LDA.L DATA8_81D1E0,X                      ; $80FB18 |
  TAX                                       ; $80FB1C |
  LDY.W #$0200                              ; $80FB1D |
  LDA.W #$06F5                              ; $80FB20 |
  PHB                                       ; $80FB23 |
  MVN $70,$70                               ; $80FB24 |
  PLB                                       ; $80FB27 |
  RTS                                       ; $80FB28 |


CODE_FN_80FB29:
  LDA.W #$0000                              ; $80FB29 |
  PHA                                       ; $80FB2C |
  JSL.L CODE_FL_96FC49                      ; $80FB2D |
  PLA                                       ; $80FB31 |
  JSR.W CODE_FN_80FA13                      ; $80FB32 |
  LDA.W #$0001                              ; $80FB35 |
  PHA                                       ; $80FB38 |
  JSL.L CODE_FL_96FC49                      ; $80FB39 |
  PLA                                       ; $80FB3D |
  JSR.W CODE_FN_80FA13                      ; $80FB3E |

  LDA.W #$0002                              ; $80FB41 |
  PHA                                       ; $80FB44 |
  JSL.L CODE_FL_96FC49                      ; $80FB45 |
  PLA                                       ; $80FB49 |
  JSR.W CODE_FN_80FA13                      ; $80FB4A |
  JSR.W CODE_FN_80FACF                      ; $80FB4D |
  RTS                                       ; $80FB50 |


CODE_FL_80FB51:
  LDA.L $700294                             ; $80FB51 |
  CMP.W #$0020                              ; $80FB55 |
  LDA.W #$37E1                              ; $80FB58 |
  BCC CODE_80FB60                           ; $80FB5B |
  LDA.W #$2FB7                              ; $80FB5D |

CODE_80FB60:
  STA.L $7008F2                             ; $80FB60 |
  LDA.B $C2                                 ; $80FB64 |
  ASL A                                     ; $80FB66 |
  TAX                                       ; $80FB67 |
  LDA.L DATA8_81D1E0,X                      ; $80FB68 |
  TAY                                       ; $80FB6C |
  LDX.W #$0200                              ; $80FB6D |
  LDA.W #$06F5                              ; $80FB70 |
  PHB                                       ; $80FB73 |
  MVN $70,$70                               ; $80FB74 |
  PLB                                       ; $80FB77 |
  LDA.B $C2                                 ; $80FB78 |
  JML.L CODE_FL_80FA0F                      ; $80FB7A |


  db $00,$00,$00,$00,$00,$00                ; $80FB7E |

  padbyte $FF
  pad $80FF90                               ; $80FB84 |


emulation_reset:
  CLC                                       ; $80FF90 |\ Switch to native mode
  XCE                                       ; $80FF91 |/
  SEI                                       ; $80FF92 |  Disable IRQ
  JML.L start                               ; $80FF93 |


native_irq:
  JML.L irq_handler                         ; $80FF97 |


native_nmi:
  JML.L vblank_handler                      ; $80FF9B |


  padbyte $FF
  pad $80FFAC                               ; $80FF9F |

  db $03                                    ; $80FFAC |

region_code:
  db $00                                    ; $80FFAD | NTSC($00) or PAL($10)

  db $00,$00                                ; $80FFAE |

rom_registration:
  db "A4"                                   ; $80FFB0 | Maker code (Konami)
  db "2U  "                                 ; $80FFB2 | Game code
  db $00,$00,$00,$00,$00,$00                ; $80FFB6 | Reserved
  db $00                                    ; $80FFBC | FLASH size
  db $00                                    ; $80FFBD | RAM size
  db $00                                    ; $80FFBE | Not a special version
  db $00                                    ; $80FFBF | Chipset sub-type

rom_specs:
  db "goemon 3             "                ; $80FFC0 | Game Title Registration
  db $30                                    ; $80FFD5 | Fast LoROM
  db $02                                    ; $80FFD6 | ROM + RAM + SRAM
  db $0B                                    ; $80FFD7 | 2MB ROM
  db $03                                    ; $80FFD8 | 8KB SRAM
  db $00                                    ; $80FFD9 | Japan (NTSC)
  db $33                                    ; $80FFDA | Extended header
  db $00                                    ; $80FFDB | Version 1.0
  dw $3CEC                                  ; $80FFDC | Checksum complement
  dw $C313                                  ; $80FFDE | Checksum
  dw $FFFF,$FFFF                            ; $80FFE0 | unused native vectors
  dw native_irq                             ; $80FFE4 | Native COP vector
  dw native_irq                             ; $80FFE6 | Native BRK vector
  dw native_irq                             ; $80FFE8 | Native ABORT vector
  dw native_nmi                             ; $80FFEA | Native NMI vector (v-blank)
  dw emulation_reset                        ; $80FFEC | Native RESET vector
  dw native_irq                             ; $80FFEE | Native IRQ vector
  dw $FFFF,$FFFF                            ; $80FFF0 | unused emulation vectors
  dw native_irq                             ; $80FFF4 | Emulation COP vector
  dw native_irq                             ; $80FFF6 | Emulation BRK vector
  dw native_irq                             ; $80FFF8 | Emulation ABORT vector
  dw native_nmi                             ; $80FFFA | Emulation NMI vector
  dw emulation_reset                        ; $80FFFC | Emulation RESET vector (start game)
  dw native_irq                             ; $80FFFE | Emulation IRQ vector
