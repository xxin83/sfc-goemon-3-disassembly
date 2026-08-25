org $A08000

  incsrc data_bankA0_sources.asm
incbin ../assets/bank_A0.bin:$6F51..$6F80   ; $A0EF51 |

CODE_A0EF80:
  JSR.W CODE_FN_A0EFD6                      ; $A0EF80 |
  JSL.L CODE_FL_86C3F8                      ; $A0EF83 |
  PHX                                       ; $A0EF87 |
  ASL A                                     ; $A0EF88 |
  TAX                                       ; $A0EF89 |
  LDA.L DATA8_A0EF94,X                      ; $A0EF8A |
  PLX                                       ; $A0EF8E |
  STA.B $00                                 ; $A0EF8F |
  JMP.W ($0000)                             ; $A0EF91 |

DATA8_A0EF94:
  db $09,$F0,$52,$F0,$86,$F0,$A8,$F0        ; $A0EF94 |
  db $C9,$F0,$D8,$F0,$E7,$F0,$F6,$F0        ; $A0EF9C |
  db $0F,$F1,$29,$F1,$3D,$F1,$4E,$F1        ; $A0EFA4 |
  db $65,$F1,$7D,$F1,$8C,$F1,$A6,$F1        ; $A0EFAC |
  db $AE,$F1,$C0,$F1,$D7,$F1,$EC,$F1        ; $A0EFB4 |
  db $F9,$F1,$05,$F2,$1E,$F2,$3C,$F2        ; $A0EFBC |
  db $53,$F2,$64,$F2,$74,$F2,$86,$F2        ; $A0EFC4 |
  db $E3,$F2,$01,$F3,$14,$F3,$22,$F3        ; $A0EFCC |
  db $6F,$F3                                ; $A0EFD4 |

CODE_FN_A0EFD6:
  LDA.B $1A,X                               ; $A0EFD6 |
  CMP.W #$001B                              ; $A0EFD8 |
  BCC CODE_A0F000                           ; $A0EFDB |
  LDA.B $3A,X                               ; $A0EFDD |
  CMP.W #$0014                              ; $A0EFDF |
  BCS CODE_A0F000                           ; $A0EFE2 |
  CMP.W #$0013                              ; $A0EFE4 |
  BNE CODE_A0EFF0                           ; $A0EFE7 |
  LDA.W #$0040                              ; $A0EFE9 |
  JSL.L push_sound_queue                    ; $A0EFEC |

CODE_A0EFF0:
  AND.W #$0001                              ; $A0EFF0 |
  BEQ CODE_A0EFF8                           ; $A0EFF3 |
  LDA.W #$2108                              ; $A0EFF5 |

CODE_A0EFF8:
  JSL.L CODE_FL_808D48                      ; $A0EFF8 |
  LDA.B $3A,X                               ; $A0EFFC |
  BEQ CODE_A0F003                           ; $A0EFFE |

CODE_A0F000:
  DEC.B $3A,X                               ; $A0F000 |
  RTS                                       ; $A0F002 |

CODE_A0F003:
  LDA.W #$0100                              ; $A0F003 |
  STA.B $3A,X                               ; $A0F006 |
  RTS                                       ; $A0F008 |

  PHX                                       ; $A0F009 |
  PHB                                       ; $A0F00A |
  PEA.W $8A00                               ; $A0F00B |
  PLB                                       ; $A0F00E |
  PLB                                       ; $A0F00F |
  LDY.W #$9F21                              ; $A0F010 |
  JSL.L CODE_FL_8AAF61                      ; $A0F013 |
  PLB                                       ; $A0F017 |
  PLX                                       ; $A0F018 |
  LDA.W #$8000                              ; $A0F019 |
  STA.B $22,X                               ; $A0F01C |
  LDA.W #$8001                              ; $A0F01E |
  STA.B $E4                                 ; $A0F021 |
  LDA.W #$1090                              ; $A0F023 |
  STA.W $0404                               ; $A0F026 |
  LDA.W #$0002                              ; $A0F029 |
  STA.B $76                                 ; $A0F02C |
  LDA.B $4E,X                               ; $A0F02E |
  BNE CODE_A0F044                           ; $A0F030 |
  INC.B $1A,X                               ; $A0F032 |
  JSL.L CODE_FL_83852F                      ; $A0F034 |
  JSL.L CODE_FL_8B8292                      ; $A0F038 |
  JSL.L CODE_FL_86C225                      ; $A0F03C |
  JML.L CODE_FL_8B803B                      ; $A0F040 |

CODE_A0F044:
  LDA.W #$8001                              ; $A0F044 |
  STA.W $1CB2                               ; $A0F047 |
  LDA.W #$001B                              ; $A0F04A |
  STA.B $1A,X                               ; $A0F04D |
  STZ.B $3C,X                               ; $A0F04F |
  RTL                                       ; $A0F051 |

  LDY.W #$0BC0                              ; $A0F052 |
  LDA.W #$0207                              ; $A0F055 |
  JSL.L CODE_FL_86C9E0                      ; $A0F058 |
  BCS CODE_A0F068                           ; $A0F05C |
  LDA.W #$00D0                              ; $A0F05E |
  STA.W $0009,Y                             ; $A0F061 |
  JSL.L CODE_FL_86C225                      ; $A0F064 |

CODE_A0F068:
  LDY.W #$0C10                              ; $A0F068 |
  LDA.W #$0206                              ; $A0F06B |
  JSL.L CODE_FL_86C9E0                      ; $A0F06E |
  BCS CODE_A0F07E                           ; $A0F072 |
  LDA.W #$00B8                              ; $A0F074 |
  STA.W $0009,Y                             ; $A0F077 |
  JSL.L CODE_FL_86C225                      ; $A0F07A |

CODE_A0F07E:
  LDA.W #$0010                              ; $A0F07E |
  STA.B $2C,X                               ; $A0F081 |
  INC.B $1A,X                               ; $A0F083 |
  RTL                                       ; $A0F085 |

  JSL.L CODE_FL_86C70D                      ; $A0F086 |
  JSL.L CODE_FL_8B8292                      ; $A0F08A |
  JSL.L CODE_FL_86C225                      ; $A0F08E |
  LDA.W #$0040                              ; $A0F092 |
  STA.B $2C,X                               ; $A0F095 |
  LDA.W #$014C                              ; $A0F097 |
  STA.L $7E7C7E                             ; $A0F09A |
  LDA.W #$0001                              ; $A0F09E |
  STA.L $7E7C80                             ; $A0F0A1 |
  INC.B $1A,X                               ; $A0F0A5 |
  RTL                                       ; $A0F0A7 |

  JSL.L CODE_FL_86C70D                      ; $A0F0A8 |
  LDA.W #$1D6E                              ; $A0F0AC |
  JSL.L CODE_FL_809934                      ; $A0F0AF |
  BCC CODE_A0F0BA                           ; $A0F0B3 |
  JSR.W CODE_FN_A0F0BB                      ; $A0F0B5 |
  INC.B $1A,X                               ; $A0F0B8 |

CODE_A0F0BA:
  RTL                                       ; $A0F0BA |

CODE_FN_A0F0BB:
  LDA.W #$0003                              ; $A0F0BB |
  STA.W $0BDA                               ; $A0F0BE |
  RTS                                       ; $A0F0C1 |

CODE_FN_A0F0C2:
  LDA.W #$0001                              ; $A0F0C2 |
  STA.W $0BDA                               ; $A0F0C5 |
  RTS                                       ; $A0F0C8 |

  LDA.W #$1E23                              ; $A0F0C9 |
  JSL.L CODE_FL_809934                      ; $A0F0CC |
  BCC CODE_A0F0D7                           ; $A0F0D0 |
  JSR.W CODE_FN_A0F0C2                      ; $A0F0D2 |
  INC.B $1A,X                               ; $A0F0D5 |

CODE_A0F0D7:
  RTL                                       ; $A0F0D7 |

  LDA.W #$1E46                              ; $A0F0D8 |
  JSL.L CODE_FL_809934                      ; $A0F0DB |
  BCC CODE_A0F0E6                           ; $A0F0DF |
  JSR.W CODE_FN_A0F0BB                      ; $A0F0E1 |
  INC.B $1A,X                               ; $A0F0E4 |

CODE_A0F0E6:
  RTL                                       ; $A0F0E6 |

  LDA.W #$1E72                              ; $A0F0E7 |
  JSL.L CODE_FL_809934                      ; $A0F0EA |
  BCC CODE_A0F0F5                           ; $A0F0EE |
  JSR.W CODE_FN_A0F0C2                      ; $A0F0F0 |
  INC.B $1A,X                               ; $A0F0F3 |

CODE_A0F0F5:
  RTL                                       ; $A0F0F5 |

  LDA.W #$1EA1                              ; $A0F0F6 |
  JSL.L CODE_FL_809934                      ; $A0F0F9 |
  BCC CODE_A0F10E                           ; $A0F0FD |
  JSR.W CODE_FN_A0F0BB                      ; $A0F0FF |
  LDY.W #$0C60                              ; $A0F102 |
  LDA.W #$0209                              ; $A0F105 |
  JSL.L CODE_FL_86C9E0                      ; $A0F108 |
  INC.B $1A,X                               ; $A0F10C |

CODE_A0F10E:
  RTL                                       ; $A0F10E |

  LDA.W #$1F00                              ; $A0F10F |
  JSL.L CODE_FL_809934                      ; $A0F112 |
  BCC CODE_A0F128                           ; $A0F116 |
  JSR.W CODE_FN_A0F0C2                      ; $A0F118 |
  LDA.W #$0010                              ; $A0F11B |
  STA.B $2C,X                               ; $A0F11E |
  LDA.W #$0024                              ; $A0F120 |
  STA.W $063A                               ; $A0F123 |
  INC.B $1A,X                               ; $A0F126 |

CODE_A0F128:
  RTL                                       ; $A0F128 |

  JSL.L CODE_FL_86C70D                      ; $A0F129 |
  LDA.W #$0002                              ; $A0F12D |
  STA.W $0C7A                               ; $A0F130 |
  LDA.W #$0002                              ; $A0F133 |
  JSL.L push_sound_queue                    ; $A0F136 |
  INC.B $1A,X                               ; $A0F13A |
  RTL                                       ; $A0F13C |

  LDA.W $0C69                               ; $A0F13D |
  CMP.W #$00AC                              ; $A0F140 |
  BCC CODE_A0F14D                           ; $A0F143 |
  LDA.W #$0005                              ; $A0F145 |
  STA.W $0BDA                               ; $A0F148 |
  INC.B $1A,X                               ; $A0F14B |

CODE_A0F14D:
  RTL                                       ; $A0F14D |

  LDA.W $0C69                               ; $A0F14E |
  CMP.W #$00BC                              ; $A0F151 |
  BCC CODE_A0F164                           ; $A0F154 |
  LDA.W #$0003                              ; $A0F156 |
  JSL.L push_sound_queue                    ; $A0F159 |
  LDA.W #$0020                              ; $A0F15D |
  STA.B $2C,X                               ; $A0F160 |
  INC.B $1A,X                               ; $A0F162 |

CODE_A0F164:
  RTL                                       ; $A0F164 |

  JSL.L CODE_FL_86C70D                      ; $A0F165 |
  LDA.W #$0005                              ; $A0F169 |
  STA.W $0C7A                               ; $A0F16C |
  LDA.W #$0004                              ; $A0F16F |
  STA.W $0BDA                               ; $A0F172 |
  LDA.W #$0040                              ; $A0F175 |
  STA.B $2C,X                               ; $A0F178 |
  INC.B $1A,X                               ; $A0F17A |
  RTL                                       ; $A0F17C |

  JSL.L CODE_FL_86C70D                      ; $A0F17D |
  JSR.W CODE_FN_A0F0C2                      ; $A0F181 |
  LDA.W #$0010                              ; $A0F184 |
  STA.B $2C,X                               ; $A0F187 |
  INC.B $1A,X                               ; $A0F189 |
  RTL                                       ; $A0F18B |

  JSL.L CODE_FL_86C70D                      ; $A0F18C |
  LDA.W #$0006                              ; $A0F190 |
  STA.W $0BDA                               ; $A0F193 |
  LDA.W #$00B8                              ; $A0F196 |
  JSL.L CODE_FL_8089BD                      ; $A0F199 |
  LDA.W #$0002                              ; $A0F19D |
  STA.W $0C2A                               ; $A0F1A0 |
  INC.B $1A,X                               ; $A0F1A3 |
  RTL                                       ; $A0F1A5 |

  LDA.W $0BD8                               ; $A0F1A6 |
  BNE CODE_A0F1AD                           ; $A0F1A9 |
  INC.B $1A,X                               ; $A0F1AB |

CODE_A0F1AD:
  RTL                                       ; $A0F1AD |

  LDA.W #$1F46                              ; $A0F1AE |
  JSL.L CODE_FL_809934                      ; $A0F1B1 |
  BCC CODE_A0F1BF                           ; $A0F1B5 |
  LDA.W #$FFE0                              ; $A0F1B7 |
  STA.W $0C36                               ; $A0F1BA |
  INC.B $1A,X                               ; $A0F1BD |

CODE_A0F1BF:
  RTL                                       ; $A0F1BF |

  LDA.W $0C2A                               ; $A0F1C0 |
  CMP.W #$0004                              ; $A0F1C3 |
  BNE CODE_A0F1D6                           ; $A0F1C6 |
  LDA.W #$00AC                              ; $A0F1C8 |
  JSL.L CODE_FL_8089BD                      ; $A0F1CB |
  LDA.W #$0018                              ; $A0F1CF |
  STA.B $2C,X                               ; $A0F1D2 |
  INC.B $1A,X                               ; $A0F1D4 |

CODE_A0F1D6:
  RTL                                       ; $A0F1D6 |

  JSL.L CODE_FL_86C70D                      ; $A0F1D7 |
  LDA.W #$1F71                              ; $A0F1DB |
  JSL.L CODE_FL_809934                      ; $A0F1DE |
  BCC CODE_A0F1EB                           ; $A0F1E2 |
  LDA.W #$0020                              ; $A0F1E4 |
  STA.B $2C,X                               ; $A0F1E7 |
  INC.B $1A,X                               ; $A0F1E9 |

CODE_A0F1EB:
  RTL                                       ; $A0F1EB |

  JSL.L CODE_FL_86C70D                      ; $A0F1EC |
  LDA.W #$0005                              ; $A0F1F0 |
  STA.W $0C2A                               ; $A0F1F3 |
  INC.B $1A,X                               ; $A0F1F6 |
  RTL                                       ; $A0F1F8 |

  LDA.W #$1F88                              ; $A0F1F9 |
  JSL.L CODE_FL_809934                      ; $A0F1FC |
  BCC CODE_A0F204                           ; $A0F200 |
  INC.B $1A,X                               ; $A0F202 |

CODE_A0F204:
  RTL                                       ; $A0F204 |

  LDA.W $0C2A                               ; $A0F205 |
  CMP.W #$0007                              ; $A0F208 |
  BNE CODE_A0F21D                           ; $A0F20B |
  LDA.W #$1FB0                              ; $A0F20D |
  JSL.L CODE_FL_809934                      ; $A0F210 |
  BCC CODE_A0F21D                           ; $A0F214 |
  LDA.W #$0020                              ; $A0F216 |
  STA.B $2C,X                               ; $A0F219 |
  INC.B $1A,X                               ; $A0F21B |

CODE_A0F21D:
  RTL                                       ; $A0F21D |

  JSL.L CODE_FL_86C70D                      ; $A0F21E |
  LDA.W #$0022                              ; $A0F222 |
  STA.W $063A                               ; $A0F225 |
  LDA.W #$0008                              ; $A0F228 |
  STA.W $0C2A                               ; $A0F22B |
  INC.B $1A,X                               ; $A0F22E |
  LDA.W #$0010                              ; $A0F230 |
  STA.B $3C,X                               ; $A0F233 |
  LDA.W #$0100                              ; $A0F235 |
  JML.L CODE_FL_8089BD                      ; $A0F238 |

  LDA.B $3C,X                               ; $A0F23C |
  BEQ CODE_A0F24B                           ; $A0F23E |
  DEC.B $3C,X                               ; $A0F240 |
  BNE CODE_A0F252                           ; $A0F242 |
  LDA.W #$002D                              ; $A0F244 |
  JML.L push_sound_queue                    ; $A0F247 |

CODE_A0F24B:
  LDA.W $0C28                               ; $A0F24B |
  BNE CODE_A0F252                           ; $A0F24E |
  INC.B $1A,X                               ; $A0F250 |

CODE_A0F252:
  RTL                                       ; $A0F252 |

  LDA.W #$1FCC                              ; $A0F253 |
  JSL.L CODE_FL_809934                      ; $A0F256 |
  BCC CODE_A0F263                           ; $A0F25A |
  LDA.W #$0020                              ; $A0F25C |
  STA.B $2C,X                               ; $A0F25F |
  INC.B $1A,X                               ; $A0F261 |

CODE_A0F263:
  RTL                                       ; $A0F263 |

  LDA.W #$205A                              ; $A0F264 |
  JSL.L CODE_FL_809934                      ; $A0F267 |
  BCC CODE_A0F273                           ; $A0F26B |
  INC.B $1A,X                               ; $A0F26D |
  JSL.L CODE_FL_80C213                      ; $A0F26F |

CODE_A0F273:
  RTL                                       ; $A0F273 |

  LDA.W $1F30                               ; $A0F274 |
  BNE CODE_A0F285                           ; $A0F277 |
  JSL.L CODE_FL_84836B                      ; $A0F279 |
  JSL.L CODE_FL_86CA36                      ; $A0F27D |
  JSL.L CODE_FL_80977D                      ; $A0F281 |

CODE_A0F285:
  RTL                                       ; $A0F285 |

  LDA.B $3C,X                               ; $A0F286 |
  BNE CODE_A0F2A7                           ; $A0F288 |
  LDA.W #$003F                              ; $A0F28A |
  STA.W $1FDE                               ; $A0F28D |
  LDA.W #$0000                              ; $A0F290 |
  STA.W $1FDC                               ; $A0F293 |
  LDA.W #$0060                              ; $A0F296 |
  STA.B $3A,X                               ; $A0F299 |
  LDY.W #$0BC0                              ; $A0F29B |
  LDA.W #$0000                              ; $A0F29E |
  JSR.W CODE_FN_A0F2BA                      ; $A0F2A1 |
  INC.B $3C,X                               ; $A0F2A4 |
  RTL                                       ; $A0F2A6 |

CODE_A0F2A7:
  LDY.W #$0C10                              ; $A0F2A7 |
  LDA.W #$0002                              ; $A0F2AA |
  JSR.W CODE_FN_A0F2BA                      ; $A0F2AD |
  LDA.W #$0080                              ; $A0F2B0 |
  STA.B $2C,X                               ; $A0F2B3 |
  STZ.B $3C,X                               ; $A0F2B5 |
  INC.B $1A,X                               ; $A0F2B7 |
  RTL                                       ; $A0F2B9 |

CODE_FN_A0F2BA:
  PHA                                       ; $A0F2BA |
  LDA.W #$0176                              ; $A0F2BB |
  JSL.L CODE_FL_86C9E0                      ; $A0F2BE |
  PLA                                       ; $A0F2C2 |
  STA.W $003A,Y                             ; $A0F2C3 |
  PHY                                       ; $A0F2C6 |
  TAY                                       ; $A0F2C7 |
  LDA.W CODE_00DB39,Y                       ; $A0F2C8 |
  PLY                                       ; $A0F2CB |
  STA.W $0009,Y                             ; $A0F2CC |
  LDA.W #$00A0                              ; $A0F2CF |
  STA.W $000D,Y                             ; $A0F2D2 |
  JSL.L CODE_FL_86C225                      ; $A0F2D5 |
  LDA.W $0004,Y                             ; $A0F2D9 |
  ORA.W #$9898                              ; $A0F2DC |
  STA.W $0004,Y                             ; $A0F2DF |
  RTS                                       ; $A0F2E2 |

  JSL.L CODE_FL_86C70D                      ; $A0F2E3 |
  LDA.W #$21F5                              ; $A0F2E7 |
  JSL.L CODE_FL_809934                      ; $A0F2EA |
  BCC CODE_A0F300                           ; $A0F2EE |
  LDA.W #$0010                              ; $A0F2F0 |
  STA.B $2C,X                               ; $A0F2F3 |
  LDA.W $0C14                               ; $A0F2F5 |
  EOR.W #$2020                              ; $A0F2F8 |
  STA.W $0C14                               ; $A0F2FB |
  INC.B $1A,X                               ; $A0F2FE |

CODE_A0F300:
  RTL                                       ; $A0F300 |

  JSL.L CODE_FL_86C70D                      ; $A0F301 |
  LDA.W #$0006                              ; $A0F305 |
  STA.W $0BDA                               ; $A0F308 |
  STA.W $0C2A                               ; $A0F30B |
  STZ.W $1CB2                               ; $A0F30E |
  INC.B $1A,X                               ; $A0F311 |
  RTL                                       ; $A0F313 |

  LDA.W $1CAE                               ; $A0F314 |
  BEQ CODE_A0F321                           ; $A0F317 |
  STZ.W $0C0C                               ; $A0F319 |
  STZ.W $0C5C                               ; $A0F31C |
  INC.B $1A,X                               ; $A0F31F |

CODE_A0F321:
  RTL                                       ; $A0F321 |

  LDA.W $1CAE                               ; $A0F322 |
  CMP.W #$0002                              ; $A0F325 |
  BEQ CODE_A0F35E                           ; $A0F328 |
  PHX                                       ; $A0F32A |
  LDY.W #$0710                              ; $A0F32B |
  LDX.W #$0BC0                              ; $A0F32E |
  JSL.L CODE_FL_86C89E                      ; $A0F331 |
  LDA.W #$0004                              ; $A0F335 |
  CLC                                       ; $A0F338 |
  ADC.B $09,X                               ; $A0F339 |
  STA.B $09,X                               ; $A0F33B |
  LDA.W #$FFFC                              ; $A0F33D |
  CLC                                       ; $A0F340 |
  ADC.B $0D,X                               ; $A0F341 |
  STA.B $0D,X                               ; $A0F343 |
  LDX.W #$0C10                              ; $A0F345 |
  JSL.L CODE_FL_86C89E                      ; $A0F348 |
  LDA.W #$FFF8                              ; $A0F34C |
  CLC                                       ; $A0F34F |
  ADC.B $09,X                               ; $A0F350 |
  STA.B $09,X                               ; $A0F352 |
  LDA.W #$FFFC                              ; $A0F354 |
  CLC                                       ; $A0F357 |
  ADC.B $0D,X                               ; $A0F358 |
  STA.B $0D,X                               ; $A0F35A |
  PLX                                       ; $A0F35C |
  RTL                                       ; $A0F35D |

CODE_A0F35E:
  LDA.W #$0300                              ; $A0F35E |
  STA.W $0BE8                               ; $A0F361 |
  STA.W $0C38                               ; $A0F364 |
  LDA.W #$0004                              ; $A0F367 |
  STA.B $2C,X                               ; $A0F36A |
  INC.B $1A,X                               ; $A0F36C |
  RTL                                       ; $A0F36E |

  JSL.L CODE_FL_86C70D                      ; $A0F36F |
  JSL.L CODE_FL_8482E4                      ; $A0F373 |
  LDX.W #$0BC0                              ; $A0F377 |
  JSL.L CODE_FL_86CA57                      ; $A0F37A |
  LDX.W #$0C10                              ; $A0F37E |
  JML.L CODE_FL_86CA57                      ; $A0F381 |

CODE_A0F385:
  JSL.L CODE_FL_86C3F8                      ; $A0F385 |
  PHX                                       ; $A0F389 |
  ASL A                                     ; $A0F38A |
  TAX                                       ; $A0F38B |
  LDA.L PTR16_A0F396,X                      ; $A0F38C |
  PLX                                       ; $A0F390 |
  STA.B $00                                 ; $A0F391 |
  JMP.W ($0000)                             ; $A0F393 |

PTR16_A0F396:
  dw CODE_A0F3AA                            ; $A0F396 |
  dw CODE_A0F3BB                            ; $A0F398 |
  dw CODE_A0F3BC                            ; $A0F39A |
  dw CODE_A0F3C6                            ; $A0F39C |
  dw CODE_A0F3EF                            ; $A0F39E |
  dw CODE_A0F3F0                            ; $A0F3A0 |
  dw CODE_A0F3FF                            ; $A0F3A2 |
  dw CODE_A0F40B                            ; $A0F3A4 |
  dw CODE_A0F40C                            ; $A0F3A6 |
  dw CODE_A0F425                            ; $A0F3A8 |

CODE_A0F3AA:
  LDA.W #$0A00                              ; $A0F3AA |
  STA.B $4E,X                               ; $A0F3AD |
  JSL.L CODE_FL_86C7A5                      ; $A0F3AF |
  LDA.W #$308E                              ; $A0F3B3 |
  STA.B $00,X                               ; $A0F3B6 |
  INC.B $1A,X                               ; $A0F3B8 |
  RTL                                       ; $A0F3BA |

CODE_A0F3BB:
  RTL                                       ; $A0F3BB |

CODE_A0F3BC:
  LDA.W #$305B                              ; $A0F3BC |
  JSL.L CODE_FL_86CAEE                      ; $A0F3BF |
  INC.B $1A,X                               ; $A0F3C3 |
  RTL                                       ; $A0F3C5 |

CODE_A0F3C6:
  LDA.B $09,X                               ; $A0F3C6 |
  CMP.W #$00B0                              ; $A0F3C8 |
  BCS CODE_A0F3EE                           ; $A0F3CB |
  STZ.B $26,X                               ; $A0F3CD |
  STZ.B $1E,X                               ; $A0F3CF |
  LDA.W #$30E2                              ; $A0F3D1 |
  STA.B $00,X                               ; $A0F3D4 |
  LDY.W #$0CB0                              ; $A0F3D6 |
  LDA.W #$0208                              ; $A0F3D9 |
  JSL.L CODE_FL_86C9E0                      ; $A0F3DC |
  BCS CODE_A0F3EC                           ; $A0F3E0 |
  LDA.W $0009,Y                             ; $A0F3E2 |
  CLC                                       ; $A0F3E5 |
  ADC.W #$FFF4                              ; $A0F3E6 |
  STA.W $0009,Y                             ; $A0F3E9 |

CODE_A0F3EC:
  INC.B $1A,X                               ; $A0F3EC |

CODE_A0F3EE:
  RTL                                       ; $A0F3EE |

CODE_A0F3EF:
  RTL                                       ; $A0F3EF |

CODE_A0F3F0:
  LDA.W #$305C                              ; $A0F3F0 |
  JSL.L CODE_FL_86CAEE                      ; $A0F3F3 |
  LDA.W #$FFD0                              ; $A0F3F7 |
  STA.B $26,X                               ; $A0F3FA |
  INC.B $1A,X                               ; $A0F3FC |
  RTL                                       ; $A0F3FE |

CODE_A0F3FF:
  LDA.B $09,X                               ; $A0F3FF |
  CMP.W #$0090                              ; $A0F401 |
  BCS CODE_A0F40A                           ; $A0F404 |
  STZ.B $26,X                               ; $A0F406 |
  INC.B $1A,X                               ; $A0F408 |

CODE_A0F40A:
  RTL                                       ; $A0F40A |

CODE_A0F40B:
  RTL                                       ; $A0F40B |

CODE_A0F40C:
  STZ.B $1E,X                               ; $A0F40C |
  LDA.W #$312C                              ; $A0F40E |
  STA.B $00,X                               ; $A0F411 |
  LDA.W #$0100                              ; $A0F413 |
  STA.B $26,X                               ; $A0F416 |
  LDA.W #$FF00                              ; $A0F418 |
  STA.B $28,X                               ; $A0F41B |
  LDA.W #$0006                              ; $A0F41D |
  STA.B $4C,X                               ; $A0F420 |
  INC.B $1A,X                               ; $A0F422 |
  RTL                                       ; $A0F424 |

CODE_A0F425:
  JSL.L CODE_FL_86C82F                      ; $A0F425 |
  LDA.B $09,X                               ; $A0F429 |
  CMP.W #$0110                              ; $A0F42B |
  BCS CODE_A0F440                           ; $A0F42E |
  LDA.W $1C38                               ; $A0F430 |
  AND.W #$0007                              ; $A0F433 |
  BNE CODE_A0F43F                           ; $A0F436 |
  LDA.B $04,X                               ; $A0F438 |
  EOR.W #$2020                              ; $A0F43A |
  STA.B $04,X                               ; $A0F43D |

CODE_A0F43F:
  RTL                                       ; $A0F43F |

CODE_A0F440:
  JML.L CODE_FL_86CA36                      ; $A0F440 |

CODE_A0F444:
  JSL.L CODE_FL_86C3F8                      ; $A0F444 |
  PHX                                       ; $A0F448 |
  ASL A                                     ; $A0F449 |
  TAX                                       ; $A0F44A |
  LDA.L PTR16_A0F455,X                      ; $A0F44B |
  PLX                                       ; $A0F44F |
  STA.B $00                                 ; $A0F450 |
  JMP.W ($0000)                             ; $A0F452 |

PTR16_A0F455:
  dw CODE_A0F45B                            ; $A0F455 |
  dw CODE_A0F485                            ; $A0F457 |
  dw CODE_A0F4A4                            ; $A0F459 |

CODE_A0F45B:
  LDA.W #$0A00                              ; $A0F45B |
  STA.B $4E,X                               ; $A0F45E |
  JSL.L CODE_FL_86C7A5                      ; $A0F460 |
  LDA.W #$30EC                              ; $A0F464 |
  STA.B $00,X                               ; $A0F467 |
  LDA.W #$003C                              ; $A0F469 |
  STA.B $14,X                               ; $A0F46C |
  LDA.W #$0003                              ; $A0F46E |
  STA.B $3A,X                               ; $A0F471 |
  INC.B $1A,X                               ; $A0F473 |
  LDA.W #$FFE0                              ; $A0F475 |
  STA.B $26,X                               ; $A0F478 |
  LDA.W #$FF20                              ; $A0F47A |
  STA.B $28,X                               ; $A0F47D |
  LDA.W #$0008                              ; $A0F47F |
  STA.B $4C,X                               ; $A0F482 |
  RTL                                       ; $A0F484 |

CODE_A0F485:
  JSL.L CODE_FL_86C82F                      ; $A0F485 |
  LDA.B $28,X                               ; $A0F489 |
  CMP.W #$00E8                              ; $A0F48B |
  BNE CODE_A0F4A0                           ; $A0F48E |
  DEC.B $3A,X                               ; $A0F490 |
  BEQ CODE_A0F4A1                           ; $A0F492 |
  LDA.W #$FF20                              ; $A0F494 |
  STA.B $28,X                               ; $A0F497 |
  LDA.W #$0011                              ; $A0F499 |
  JSL.L push_sound_queue                    ; $A0F49C |

CODE_A0F4A0:
  RTL                                       ; $A0F4A0 |

CODE_A0F4A1:
  INC.B $1A,X                               ; $A0F4A1 |
  RTL                                       ; $A0F4A3 |

CODE_A0F4A4:
  JML.L CODE_FL_86C82F                      ; $A0F4A4 |

CODE_A0F4A8:
  JSL.L CODE_FL_86C3F8                      ; $A0F4A8 |
  PHX                                       ; $A0F4AC |
  ASL A                                     ; $A0F4AD |
  TAX                                       ; $A0F4AE |
  LDA.L PTR16_A0F4B9,X                      ; $A0F4AF |
  PLX                                       ; $A0F4B3 |
  STA.B $00                                 ; $A0F4B4 |
  JMP.W ($0000)                             ; $A0F4B6 |

PTR16_A0F4B9:
  dw CODE_A0F4C9                            ; $A0F4B9 |
  dw CODE_A0F4D5                            ; $A0F4BB |
  dw CODE_A0F4E2                            ; $A0F4BD |
  dw CODE_A0F4E3                            ; $A0F4BF |
  dw CODE_A0F4F0                            ; $A0F4C1 |
  dw CODE_A0F4FD                            ; $A0F4C3 |
  dw CODE_A0F50A                            ; $A0F4C5 |
  dw CODE_A0F517                            ; $A0F4C7 |

CODE_A0F4C9:
  LDA.W #$0800                              ; $A0F4C9 |
  STA.B $4E,X                               ; $A0F4CC |
  JSL.L CODE_FL_86C7A5                      ; $A0F4CE |
  INC.B $1A,X                               ; $A0F4D2 |
  RTL                                       ; $A0F4D4 |

CODE_A0F4D5:
  STZ.B $1E,X                               ; $A0F4D5 |
  LDA.W #$3016                              ; $A0F4D7 |
  STA.B $00,X                               ; $A0F4DA |
  LDA.W #$0002                              ; $A0F4DC |
  STA.B $1A,X                               ; $A0F4DF |
  RTL                                       ; $A0F4E1 |

CODE_A0F4E2:
  RTL                                       ; $A0F4E2 |

CODE_A0F4E3:
  LDA.W #$305D                              ; $A0F4E3 |
  JSL.L CODE_FL_86CAEE                      ; $A0F4E6 |
  LDA.W #$0002                              ; $A0F4EA |
  STA.B $1A,X                               ; $A0F4ED |
  RTL                                       ; $A0F4EF |

CODE_A0F4F0:
  LDA.W #$305E                              ; $A0F4F0 |
  JSL.L CODE_FL_86CAEE                      ; $A0F4F3 |
  LDA.W #$0002                              ; $A0F4F7 |
  STA.B $1A,X                               ; $A0F4FA |
  RTL                                       ; $A0F4FC |

CODE_A0F4FD:
  STZ.B $1E,X                               ; $A0F4FD |
  LDA.W #$305A                              ; $A0F4FF |
  STA.B $00,X                               ; $A0F502 |
  LDA.W #$0002                              ; $A0F504 |
  STA.B $1A,X                               ; $A0F507 |
  RTL                                       ; $A0F509 |

CODE_A0F50A:
  LDA.W #$FA00                              ; $A0F50A |
  STA.B $28,X                               ; $A0F50D |
  LDA.W #$0010                              ; $A0F50F |
  STA.B $4C,X                               ; $A0F512 |
  INC.B $1A,X                               ; $A0F514 |
  RTL                                       ; $A0F516 |

CODE_A0F517:
  JSL.L CODE_FL_86C82F                      ; $A0F517 |
  LDA.B $0D,X                               ; $A0F51B |
  BMI CODE_A0F520                           ; $A0F51D |
  RTL                                       ; $A0F51F |

CODE_A0F520:
  JML.L CODE_FL_86CA36                      ; $A0F520 |

CODE_A0F524:
  JSL.L CODE_FL_86C3F8                      ; $A0F524 |
  PHX                                       ; $A0F528 |
  ASL A                                     ; $A0F529 |
  TAX                                       ; $A0F52A |
  LDA.L PTR16_A0F535,X                      ; $A0F52B |
  PLX                                       ; $A0F52F |
  STA.B $00                                 ; $A0F530 |
  JMP.W ($0000)                             ; $A0F532 |

PTR16_A0F535:
  dw CODE_A0F541                            ; $A0F535 |
  dw CODE_A0F552                            ; $A0F537 |
  dw CODE_A0F56A                            ; $A0F539 |
  dw CODE_A0F57C                            ; $A0F53B |
  dw CODE_A0F591                            ; $A0F53D |
  dw CODE_A0F592                            ; $A0F53F |

CODE_A0F541:
  LDA.W #$0600                              ; $A0F541 |
  STA.B $4E,X                               ; $A0F544 |
  JSL.L CODE_FL_86C7A5                      ; $A0F546 |
  LDA.W #$3086                              ; $A0F54A |
  STA.B $00,X                               ; $A0F54D |
  INC.B $1A,X                               ; $A0F54F |
  RTL                                       ; $A0F551 |

CODE_A0F552:
  LDA.W #$003C                              ; $A0F552 |
  STA.B $14,X                               ; $A0F555 |
  LDA.W $0629                               ; $A0F557 |
  CLC                                       ; $A0F55A |
  ADC.W #$0008                              ; $A0F55B |
  STA.B $09,X                               ; $A0F55E |
  LDA.W $062D                               ; $A0F560 |
  CLC                                       ; $A0F563 |
  ADC.W #$FFF8                              ; $A0F564 |
  STA.B $0D,X                               ; $A0F567 |
  RTL                                       ; $A0F569 |

CODE_A0F56A:
  LDA.W #$00E0                              ; $A0F56A |
  STA.B $26,X                               ; $A0F56D |
  LDA.W #$FCD0                              ; $A0F56F |
  STA.B $28,X                               ; $A0F572 |
  LDA.W #$0018                              ; $A0F574 |
  STA.B $4C,X                               ; $A0F577 |
  INC.B $1A,X                               ; $A0F579 |
  RTL                                       ; $A0F57B |

CODE_A0F57C:
  JSL.L CODE_FL_86C82F                      ; $A0F57C |
  LDA.B $09,X                               ; $A0F580 |
  CMP.W #$00BC                              ; $A0F582 |
  BCC CODE_A0F590                           ; $A0F585 |
  STZ.B $26,X                               ; $A0F587 |
  STZ.B $28,X                               ; $A0F589 |
  LDA.W #$0004                              ; $A0F58B |
  STA.B $1A,X                               ; $A0F58E |

CODE_A0F590:
  RTL                                       ; $A0F590 |

CODE_A0F591:
  RTL                                       ; $A0F591 |

CODE_A0F592:
  JML.L CODE_FL_86CA36                      ; $A0F592 |

CODE_A0F596:
  JSL.L CODE_FL_86C3B0                      ; $A0F596 |
  PHX                                       ; $A0F59A |
  ASL A                                     ; $A0F59B |
  TAX                                       ; $A0F59C |
  LDA.L PTR16_A0F5A7,X                      ; $A0F59D |
  PLX                                       ; $A0F5A1 |
  STA.B $00                                 ; $A0F5A2 |
  JMP.W ($0000)                             ; $A0F5A4 |

PTR16_A0F5A7:
  dw CODE_A0F5B1                            ; $A0F5A7 |
  dw CODE_A0F5D3                            ; $A0F5A9 |
  dw CODE_A0F60F                            ; $A0F5AB |
  dw CODE_A0F620                            ; $A0F5AD |
  dw CODE_A0F65C                            ; $A0F5AF |

CODE_A0F5B1:
  JSL.L CODE_FL_86C7A5                      ; $A0F5B1 |
  LDA.W #$0001                              ; $A0F5B5 |
  STA.L $7E7D90                             ; $A0F5B8 |
  LDA.W #$357A                              ; $A0F5BC |
  STA.B $00,X                               ; $A0F5BF |
  LDA.B $34,X                               ; $A0F5C1 |
  ORA.W #$1880                              ; $A0F5C3 |
  STA.B $34,X                               ; $A0F5C6 |
  LDA.B $22,X                               ; $A0F5C8 |
  ORA.W #$0080                              ; $A0F5CA |
  STA.B $22,X                               ; $A0F5CD |
  JML.L CODE_FL_86C63F                      ; $A0F5CF |

CODE_A0F5D3:
  LDY.W #$0400                              ; $A0F5D3 |
  JSR.W CODE_FN_A0F601                      ; $A0F5D6 |
  BCC CODE_A0F5E3                           ; $A0F5D9 |
  LDY.W #$04C0                              ; $A0F5DB |
  JSR.W CODE_FN_A0F601                      ; $A0F5DE |
  BCS CODE_A0F5E4                           ; $A0F5E1 |

CODE_A0F5E3:
  RTL                                       ; $A0F5E3 |

CODE_A0F5E4:
  LDA.W #$0001                              ; $A0F5E4 |
  STA.B $2C,X                               ; $A0F5E7 |
  INC.B $1A,X                               ; $A0F5E9 |
  LDA.W #$0204                              ; $A0F5EB |
  JSL.L spawn_item_drop                     ; $A0F5EE |
  BCS CODE_A0F600                           ; $A0F5F2 |
  LDA.W #$00B0                              ; $A0F5F4 |
  STA.W $0009,Y                             ; $A0F5F7 |
  LDA.W #$00A0                              ; $A0F5FA |
  STA.W $000D,Y                             ; $A0F5FD |

CODE_A0F600:
  RTL                                       ; $A0F600 |

CODE_FN_A0F601:
  LDA.W $0018,Y                             ; $A0F601 |
  BEQ CODE_A0F60D                           ; $A0F604 |
  LDA.W #$0090                              ; $A0F606 |
  CMP.W $0009,Y                             ; $A0F609 |
  RTS                                       ; $A0F60C |

CODE_A0F60D:
  SEC                                       ; $A0F60D |
  RTS                                       ; $A0F60E |

CODE_A0F60F:
  JSL.L CODE_FL_86C70D                      ; $A0F60F |
  LDA.W #$FFF8                              ; $A0F613 |
  STA.B $4C,X                               ; $A0F616 |
  LDA.W #$000A                              ; $A0F618 |
  STA.B $3A,X                               ; $A0F61B |
  INC.B $1A,X                               ; $A0F61D |
  RTL                                       ; $A0F61F |

CODE_A0F620:
  JSR.W CODE_FN_A0F63C                      ; $A0F620 |
  JSR.W CODE_FN_A0F648                      ; $A0F623 |
  LDA.B $0D,X                               ; $A0F626 |
  CLC                                       ; $A0F628 |
  ADC.W $1672                               ; $A0F629 |
  CMP.W #$0170                              ; $A0F62C |
  BPL CODE_A0F63B                           ; $A0F62F |
  INC.B $1A,X                               ; $A0F631 |
  JSL.L CODE_FL_80C213                      ; $A0F633 |
  JSL.L CODE_FL_80893F                      ; $A0F637 |

CODE_A0F63B:
  RTL                                       ; $A0F63B |

CODE_FN_A0F63C:
  LDA.B $28,X                               ; $A0F63C |
  CMP.W #$FE00                              ; $A0F63E |
  BEQ CODE_A0F647                           ; $A0F641 |
  JSL.L CODE_FL_86C82F                      ; $A0F643 |

CODE_A0F647:
  RTS                                       ; $A0F647 |

CODE_FN_A0F648:
  LDA.B $3A,X                               ; $A0F648 |
  BEQ CODE_A0F64F                           ; $A0F64A |
  DEC.B $3A,X                               ; $A0F64C |
  RTS                                       ; $A0F64E |

CODE_A0F64F:
  LDA.W #$000A                              ; $A0F64F |
  STA.B $3A,X                               ; $A0F652 |
  LDA.W #$0018                              ; $A0F654 |
  JSL.L push_sound_queue                    ; $A0F657 |
  RTS                                       ; $A0F65B |

CODE_A0F65C:
  JSR.W CODE_FN_A0F63C                      ; $A0F65C |
  JSR.W CODE_FN_A0F648                      ; $A0F65F |
  LDA.W $1F30                               ; $A0F662 |
  BNE CODE_A0F66B                           ; $A0F665 |
  JSL.L CODE_FL_80ED5C                      ; $A0F667 |

CODE_A0F66B:
  RTL                                       ; $A0F66B |

CODE_A0F66C:
  LDA.B $1A,X                               ; $A0F66C |
  BEQ CODE_A0F671                           ; $A0F66E |
  RTL                                       ; $A0F670 |

CODE_A0F671:
  LDA.W #$1880                              ; $A0F671 |
  STA.B $34,X                               ; $A0F674 |
  JML.L CODE_FL_86C63F                      ; $A0F676 |

CODE_FL_A0F67A:
  STA.B $0A                                 ; $A0F67A |
  LDA.W #$0002                              ; $A0F67C |
  STA.B $16                                 ; $A0F67F |
  BRA CODE_A0F687                           ; $A0F681 |

  STZ.B $16                                 ; $A0F683 |
  STA.B $0A                                 ; $A0F685 |

CODE_A0F687:
  PHB                                       ; $A0F687 |
  LDA.W #$0087                              ; $A0F688 |
  STA.B $0E                                 ; $A0F68B |
  SEP #$20                                  ; $A0F68D |
  PHA                                       ; $A0F68F |
  PLB                                       ; $A0F690 |
  REP #$20                                  ; $A0F691 |
  PHX                                       ; $A0F693 |
  LDA.W $0000,Y                             ; $A0F694 |
  AND.W #$00FF                              ; $A0F697 |
  STA.B $00                                 ; $A0F69A |
  LDA.W $0001,Y                             ; $A0F69C |
  AND.W #$00FF                              ; $A0F69F |
  STA.B $02                                 ; $A0F6A2 |
  INY                                       ; $A0F6A4 |
  INY                                       ; $A0F6A5 |
  STY.B $08                                 ; $A0F6A6 |
  PEA.W $7E00                               ; $A0F6A8 |
  PLB                                       ; $A0F6AB |
  PLB                                       ; $A0F6AC |

CODE_A0F6AD:
  TDC                                       ; $A0F6AD |

CODE_A0F6AE:
  STA.B $06                                 ; $A0F6AE |
  LDA.B $08                                 ; $A0F6B0 |
  STA.B $0C                                 ; $A0F6B2 |
  LDY.B $0A                                 ; $A0F6B4 |
  JSL.L CODE_FL_809622                      ; $A0F6B6 |
  LDY.B $52                                 ; $A0F6BA |
  LDA.B $00                                 ; $A0F6BC |
  STA.B $04                                 ; $A0F6BE |

CODE_A0F6C0:
  LDA.B [$0C]                               ; $A0F6C0 |
  CLC                                       ; $A0F6C2 |
  ADC.B $06                                 ; $A0F6C3 |
  TAX                                       ; $A0F6C5 |
  JSR.W CODE_FN_A0F821                      ; $A0F6C6 |
  TYA                                       ; $A0F6C9 |
  CLC                                       ; $A0F6CA |
  ADC.W #$0008                              ; $A0F6CB |
  TAY                                       ; $A0F6CE |
  INC.B $0C                                 ; $A0F6CF |
  INC.B $0C                                 ; $A0F6D1 |
  DEC.B $04                                 ; $A0F6D3 |
  BNE CODE_A0F6C0                           ; $A0F6D5 |
  STY.B $52                                 ; $A0F6D7 |
  JSL.L CODE_FL_809663                      ; $A0F6D9 |
  LDA.B $0A                                 ; $A0F6DD |
  CLC                                       ; $A0F6DF |
  ADC.W #$0020                              ; $A0F6E0 |
  TAY                                       ; $A0F6E3 |
  EOR.B $0A                                 ; $A0F6E4 |
  BIT.W #$0400                              ; $A0F6E6 |
  BEQ CODE_A0F6FD                           ; $A0F6E9 |
  LDA.B $0A                                 ; $A0F6EB |
  AND.W #$F000                              ; $A0F6ED |
  STA.B $0A                                 ; $A0F6F0 |
  TYA                                       ; $A0F6F2 |
  CLC                                       ; $A0F6F3 |
  ADC.W #$0400                              ; $A0F6F4 |
  AND.W #$0FFF                              ; $A0F6F7 |
  ORA.B $0A                                 ; $A0F6FA |
  TAY                                       ; $A0F6FC |

CODE_A0F6FD:
  STY.B $0A                                 ; $A0F6FD |
  LDA.B $06                                 ; $A0F6FF |
  CLC                                       ; $A0F701 |
  ADC.W #$0008                              ; $A0F702 |
  CMP.W #$0020                              ; $A0F705 |
  BCC CODE_A0F6AE                           ; $A0F708 |
  LDA.B $00                                 ; $A0F70A |
  ASL A                                     ; $A0F70C |
  ADC.B $08                                 ; $A0F70D |
  STA.B $08                                 ; $A0F70F |
  DEC.B $02                                 ; $A0F711 |
  BNE CODE_A0F6AD                           ; $A0F713 |
  PLX                                       ; $A0F715 |
  PLB                                       ; $A0F716 |
  RTL                                       ; $A0F717 |

CODE_FL_A0F718:
  STA.B $0A                                 ; $A0F718 |
  LDA.W #$0001                              ; $A0F71A |
  STA.B $16                                 ; $A0F71D |
  BRA CODE_A0F725                           ; $A0F71F |

  STA.B $0A                                 ; $A0F721 |
  STZ.B $16                                 ; $A0F723 |

CODE_A0F725:
  PHB                                       ; $A0F725 |
  LDA.W #$0087                              ; $A0F726 |
  STA.B $0E                                 ; $A0F729 |
  SEP #$20                                  ; $A0F72B |
  PHA                                       ; $A0F72D |
  PLB                                       ; $A0F72E |
  REP #$20                                  ; $A0F72F |
  PHX                                       ; $A0F731 |
  LDA.W $0001,Y                             ; $A0F732 |
  AND.W #$00FF                              ; $A0F735 |
  STA.B $02                                 ; $A0F738 |
  LDA.W $0000,Y                             ; $A0F73A |
  AND.W #$00FF                              ; $A0F73D |
  STA.B $00                                 ; $A0F740 |
  INY                                       ; $A0F742 |
  INY                                       ; $A0F743 |
  STY.B $08                                 ; $A0F744 |
  DEC A                                     ; $A0F746 |
  ASL A                                     ; $A0F747 |
  CLC                                       ; $A0F748 |
  ADC.B $08                                 ; $A0F749 |
  STA.B $08                                 ; $A0F74B |
  PEA.W $7E00                               ; $A0F74D |
  PLB                                       ; $A0F750 |
  PLB                                       ; $A0F751 |

CODE_A0F752:
  TDC                                       ; $A0F752 |

CODE_A0F753:
  STA.B $06                                 ; $A0F753 |
  LDA.B $08                                 ; $A0F755 |
  STA.B $0C                                 ; $A0F757 |
  LDY.B $0A                                 ; $A0F759 |
  JSL.L CODE_FL_809622                      ; $A0F75B |
  LDY.B $52                                 ; $A0F75F |
  LDA.B $00                                 ; $A0F761 |
  STA.B $04                                 ; $A0F763 |

CODE_A0F765:
  LDA.B [$0C]                               ; $A0F765 |
  CLC                                       ; $A0F767 |
  ADC.B $06                                 ; $A0F768 |
  TAX                                       ; $A0F76A |
  JSR.W CODE_FN_A0F7A3                      ; $A0F76B |
  TYA                                       ; $A0F76E |
  CLC                                       ; $A0F76F |
  ADC.W #$0008                              ; $A0F770 |
  TAY                                       ; $A0F773 |
  DEC.B $0C                                 ; $A0F774 |
  DEC.B $0C                                 ; $A0F776 |
  DEC.B $04                                 ; $A0F778 |
  BNE CODE_A0F765                           ; $A0F77A |
  STY.B $52                                 ; $A0F77C |
  JSL.L CODE_FL_809663                      ; $A0F77E |
  LDA.B $0A                                 ; $A0F782 |
  CLC                                       ; $A0F784 |
  ADC.W #$0020                              ; $A0F785 |
  STA.B $0A                                 ; $A0F788 |
  LDA.B $06                                 ; $A0F78A |
  CLC                                       ; $A0F78C |
  ADC.W #$0008                              ; $A0F78D |
  CMP.W #$0020                              ; $A0F790 |
  BCC CODE_A0F753                           ; $A0F793 |
  LDA.B $00                                 ; $A0F795 |
  ASL A                                     ; $A0F797 |
  ADC.B $08                                 ; $A0F798 |
  STA.B $08                                 ; $A0F79A |
  DEC.B $02                                 ; $A0F79C |
  BNE CODE_A0F752                           ; $A0F79E |
  PLX                                       ; $A0F7A0 |
  PLB                                       ; $A0F7A1 |
  RTL                                       ; $A0F7A2 |

CODE_FN_A0F7A3:
  LDA.B $16                                 ; $A0F7A3 |
  BNE CODE_A0F7D0                           ; $A0F7A5 |
  LDA.L $7F0006,X                           ; $A0F7A7 |
  EOR.W #$4000                              ; $A0F7AB |
  STA.W $0000,Y                             ; $A0F7AE |
  LDA.L $7F0004,X                           ; $A0F7B1 |
  EOR.W #$4000                              ; $A0F7B5 |
  STA.W $0002,Y                             ; $A0F7B8 |
  LDA.L $7F0002,X                           ; $A0F7BB |
  EOR.W #$4000                              ; $A0F7BF |
  STA.W $0004,Y                             ; $A0F7C2 |
  LDA.L $7F0000,X                           ; $A0F7C5 |
  EOR.W #$4000                              ; $A0F7C9 |
  STA.W $0006,Y                             ; $A0F7CC |
  RTS                                       ; $A0F7CF |

CODE_A0F7D0:
  LDA.L $7F0006,X                           ; $A0F7D0 |
  AND.W #$C0FF                              ; $A0F7D4 |
  BEQ CODE_A0F7E1                           ; $A0F7D7 |
  EOR.W #$4000                              ; $A0F7D9 |
  ORA.B $10                                 ; $A0F7DC |
  CLC                                       ; $A0F7DE |
  ADC.B $12                                 ; $A0F7DF |

CODE_A0F7E1:
  STA.W $0000,Y                             ; $A0F7E1 |
  LDA.L $7F0004,X                           ; $A0F7E4 |
  AND.W #$C0FF                              ; $A0F7E8 |
  BEQ CODE_A0F7F5                           ; $A0F7EB |
  EOR.W #$4000                              ; $A0F7ED |
  ORA.B $10                                 ; $A0F7F0 |
  CLC                                       ; $A0F7F2 |
  ADC.B $12                                 ; $A0F7F3 |

CODE_A0F7F5:
  STA.W $0002,Y                             ; $A0F7F5 |
  LDA.L $7F0002,X                           ; $A0F7F8 |
  AND.W #$C0FF                              ; $A0F7FC |
  BEQ CODE_A0F809                           ; $A0F7FF |
  EOR.W #$4000                              ; $A0F801 |
  ORA.B $10                                 ; $A0F804 |
  CLC                                       ; $A0F806 |
  ADC.B $12                                 ; $A0F807 |

CODE_A0F809:
  STA.W $0004,Y                             ; $A0F809 |
  LDA.L $7F0000,X                           ; $A0F80C |
  AND.W #$C0FF                              ; $A0F810 |
  BEQ CODE_A0F81D                           ; $A0F813 |
  EOR.W #$4000                              ; $A0F815 |
  ORA.B $10                                 ; $A0F818 |
  CLC                                       ; $A0F81A |
  ADC.B $12                                 ; $A0F81B |

CODE_A0F81D:
  STA.W $0006,Y                             ; $A0F81D |
  RTS                                       ; $A0F820 |

CODE_FN_A0F821:
  LDA.B $16                                 ; $A0F821 |
  BNE CODE_A0F842                           ; $A0F823 |
  LDA.L $7F0000,X                           ; $A0F825 |
  STA.W $0000,Y                             ; $A0F829 |
  LDA.L $7F0002,X                           ; $A0F82C |
  STA.W $0002,Y                             ; $A0F830 |
  LDA.L $7F0004,X                           ; $A0F833 |
  STA.W $0004,Y                             ; $A0F837 |
  LDA.L $7F0006,X                           ; $A0F83A |
  STA.W $0006,Y                             ; $A0F83E |
  RTS                                       ; $A0F841 |

CODE_A0F842:
  LDA.L $7F0000,X                           ; $A0F842 |
  AND.W #$C0FF                              ; $A0F846 |
  BEQ CODE_A0F850                           ; $A0F849 |
  ORA.B $10                                 ; $A0F84B |
  CLC                                       ; $A0F84D |
  ADC.B $12                                 ; $A0F84E |

CODE_A0F850:
  STA.W $0000,Y                             ; $A0F850 |
  LDA.L $7F0002,X                           ; $A0F853 |
  AND.W #$C0FF                              ; $A0F857 |
  BEQ CODE_A0F861                           ; $A0F85A |
  ORA.B $10                                 ; $A0F85C |
  CLC                                       ; $A0F85E |
  ADC.B $12                                 ; $A0F85F |

CODE_A0F861:
  STA.W $0002,Y                             ; $A0F861 |
  LDA.L $7F0004,X                           ; $A0F864 |
  AND.W #$C0FF                              ; $A0F868 |
  BEQ CODE_A0F872                           ; $A0F86B |
  ORA.B $10                                 ; $A0F86D |
  CLC                                       ; $A0F86F |
  ADC.B $12                                 ; $A0F870 |

CODE_A0F872:
  STA.W $0004,Y                             ; $A0F872 |
  LDA.L $7F0006,X                           ; $A0F875 |
  AND.W #$C0FF                              ; $A0F879 |
  BEQ CODE_A0F883                           ; $A0F87C |
  ORA.B $10                                 ; $A0F87E |
  CLC                                       ; $A0F880 |
  ADC.B $12                                 ; $A0F881 |

CODE_A0F883:
  STA.W $0006,Y                             ; $A0F883 |
  RTS                                       ; $A0F886 |

CODE_FL_A0F887:
  PHX                                       ; $A0F887 |
  STA.B $0A                                 ; $A0F888 |
  LDA.W $0000,Y                             ; $A0F88A |
  AND.W #$00FF                              ; $A0F88D |
  STA.B $00                                 ; $A0F890 |
  LDA.W $0001,Y                             ; $A0F892 |
  AND.W #$00FF                              ; $A0F895 |
  STA.B $02                                 ; $A0F898 |
  INY                                       ; $A0F89A |
  INY                                       ; $A0F89B |
  STY.B $08                                 ; $A0F89C |
  LDA.W #$008A                              ; $A0F89E |
  STA.B $0E                                 ; $A0F8A1 |
  PHB                                       ; $A0F8A3 |
  PEA.W $7E00                               ; $A0F8A4 |
  PLB                                       ; $A0F8A7 |
  PLB                                       ; $A0F8A8 |

CODE_A0F8A9:
  TDC                                       ; $A0F8A9 |

CODE_A0F8AA:
  STA.B $06                                 ; $A0F8AA |
  LDA.B $08                                 ; $A0F8AC |
  STA.B $0C                                 ; $A0F8AE |
  LDY.B $0A                                 ; $A0F8B0 |
  JSL.L CODE_FL_80960F                      ; $A0F8B2 |
  LDY.B $52                                 ; $A0F8B6 |
  LDA.B $00                                 ; $A0F8B8 |
  STA.B $04                                 ; $A0F8BA |

CODE_A0F8BC:
  LDA.B [$0C]                               ; $A0F8BC |
  CLC                                       ; $A0F8BE |
  ADC.B $06                                 ; $A0F8BF |
  TAX                                       ; $A0F8C1 |
  SEP #$20                                  ; $A0F8C2 |
  LDA.L $7F0000,X                           ; $A0F8C4 |
  STA.W $0000,Y                             ; $A0F8C8 |
  LDA.L $7F0002,X                           ; $A0F8CB |
  STA.W $0001,Y                             ; $A0F8CF |
  LDA.L $7F0004,X                           ; $A0F8D2 |
  STA.W $0002,Y                             ; $A0F8D6 |
  LDA.L $7F0006,X                           ; $A0F8D9 |
  STA.W $0003,Y                             ; $A0F8DD |
  REP #$20                                  ; $A0F8E0 |
  TYA                                       ; $A0F8E2 |
  CLC                                       ; $A0F8E3 |
  ADC.W #$0004                              ; $A0F8E4 |
  TAY                                       ; $A0F8E7 |
  INC.B $0C                                 ; $A0F8E8 |
  INC.B $0C                                 ; $A0F8EA |
  DEC.B $04                                 ; $A0F8EC |
  BNE CODE_A0F8BC                           ; $A0F8EE |
  STY.B $52                                 ; $A0F8F0 |
  JSL.L CODE_FL_809663                      ; $A0F8F2 |
  LDA.B $0A                                 ; $A0F8F6 |
  CLC                                       ; $A0F8F8 |
  ADC.W #$0080                              ; $A0F8F9 |
  STA.B $0A                                 ; $A0F8FC |
  LDA.B $06                                 ; $A0F8FE |
  CLC                                       ; $A0F900 |
  ADC.W #$0008                              ; $A0F901 |
  CMP.W #$0020                              ; $A0F904 |
  BCC CODE_A0F8AA                           ; $A0F907 |
  LDA.B $00                                 ; $A0F909 |
  ASL A                                     ; $A0F90B |
  ADC.B $08                                 ; $A0F90C |
  STA.B $08                                 ; $A0F90E |
  DEC.B $02                                 ; $A0F910 |
  BNE CODE_A0F8A9                           ; $A0F912 |
  PLB                                       ; $A0F914 |
  PLX                                       ; $A0F915 |
  RTL                                       ; $A0F916 |

CODE_JL_A0F917:
  PHX                                       ; $A0F917 |
  STA.B $00                                 ; $A0F918 |
  JSL.L CODE_FL_80960F                      ; $A0F91A |
  LDA.B $00                                 ; $A0F91E |
  SEP #$20                                  ; $A0F920 |
  JSL.L CODE_FL_80964E                      ; $A0F922 |
  REP #$20                                  ; $A0F926 |
  JSL.L CODE_FL_809663                      ; $A0F928 |
  PLX                                       ; $A0F92C |
  RTL                                       ; $A0F92D |

CODE_FL_A0F92E:
  PHX                                       ; $A0F92E |
  STA.B $00                                 ; $A0F92F |
  STY.B $02                                 ; $A0F931 |
  JSL.L CODE_FL_80960F                      ; $A0F933 |
  SEP #$20                                  ; $A0F937 |
  LDY.B $00                                 ; $A0F939 |
  LDA.W $0000,Y                             ; $A0F93B |
  JSL.L CODE_FL_80964E                      ; $A0F93E |
  LDA.W $0001,Y                             ; $A0F942 |
  JSL.L CODE_FL_80964E                      ; $A0F945 |
  REP #$20                                  ; $A0F949 |
  JSL.L CODE_FL_809663                      ; $A0F94B |
  LDA.B $02                                 ; $A0F94F |
  CLC                                       ; $A0F951 |
  ADC.W #$0080                              ; $A0F952 |
  TAY                                       ; $A0F955 |
  JSL.L CODE_FL_80960F                      ; $A0F956 |
  SEP #$20                                  ; $A0F95A |
  LDY.B $00                                 ; $A0F95C |
  LDA.W $0002,Y                             ; $A0F95E |
  JSL.L CODE_FL_80964E                      ; $A0F961 |
  LDA.W $0003,Y                             ; $A0F965 |
  JSL.L CODE_FL_80964E                      ; $A0F968 |
  REP #$20                                  ; $A0F96C |
  JSL.L CODE_FL_809663                      ; $A0F96E |
  PLX                                       ; $A0F972 |
  RTL                                       ; $A0F973 |

  ASL A                                     ; $A0F974 |
  ASL A                                     ; $A0F975 |
  ASL A                                     ; $A0F976 |
  ASL A                                     ; $A0F977 |
  ASL A                                     ; $A0F978 |
  ADC.W #$8000                              ; $A0F979 |
  STA.B $02                                 ; $A0F97C |
  JSL.L CODE_FL_808302                      ; $A0F97E |
  SEP #$20                                  ; $A0F982 |
  LDA.B #$00                                ; $A0F984 |
  STA.W !reg_vmain                          ; $A0F986 |
  STA.W !reg_vmaddl                         ; $A0F989 |
  STA.W !reg_vmaddh                         ; $A0F98C |
  REP #$20                                  ; $A0F98F |
  TDC                                       ; $A0F991 |
  STA.B $00                                 ; $A0F992 |

CODE_A0F994:
  AND.W #$0180                              ; $A0F994 |
  LSR A                                     ; $A0F997 |
  LSR A                                     ; $A0F998 |
  LSR A                                     ; $A0F999 |
  LSR A                                     ; $A0F99A |
  ADC.B $02                                 ; $A0F99B |
  TAX                                       ; $A0F99D |
  SEP #$20                                  ; $A0F99E |
  LDA.L $7F0000,X                           ; $A0F9A0 |
  STA.W !reg_vmdatal                        ; $A0F9A4 |
  LDA.L $7F0002,X                           ; $A0F9A7 |
  STA.W !reg_vmdatal                        ; $A0F9AB |
  LDA.L $7F0004,X                           ; $A0F9AE |
  STA.W !reg_vmdatal                        ; $A0F9B2 |
  LDA.L $7F0006,X                           ; $A0F9B5 |
  STA.W !reg_vmdatal                        ; $A0F9B9 |
  REP #$20                                  ; $A0F9BC |
  INC.B $00                                 ; $A0F9BE |
  LDA.B $00                                 ; $A0F9C0 |
  CMP.W #$4000                              ; $A0F9C2 |
  BNE CODE_A0F994                           ; $A0F9C5 |
  JSL.L CODE_FL_808315                      ; $A0F9C7 |
  RTL                                       ; $A0F9CB |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0F9CC |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0F9D4 |
  db $FF,$FF,$FF,$FF                        ; $A0F9DC |

CODE_JL_A0F9E0:
  LDA.W #$0006                              ; $A0F9E0 |
  JML.L CODE_FL_8085EC                      ; $A0F9E3 |

CODE_FL_A0F9E7:
  PHX                                       ; $A0F9E7 |
  STZ.B $02                                 ; $A0F9E8 |
  LDA.B !r_room_id                          ; $A0F9EA |
  ASL A                                     ; $A0F9EC |
  TAX                                       ; $A0F9ED |
  LDA.L DATA16_81B69C,X                     ; $A0F9EE |
  BPL CODE_A0FA00                           ; $A0F9F2 |
  CMP.W #$FFFE                              ; $A0F9F4 |
  BCS CODE_A0FA00                           ; $A0F9F7 |
  JSR.W CODE_FN_A0FA2A                      ; $A0F9F9 |
  BCC CODE_A0FA00                           ; $A0F9FC |
  DEC.B $02                                 ; $A0F9FE |

CODE_A0FA00:
  TAY                                       ; $A0FA00 |
  STA.B $F8                                 ; $A0FA01 |
  BEQ CODE_A0FA1D                           ; $A0FA03 |
  BPL CODE_A0FA0C                           ; $A0FA05 |
  CMP.W #$FFFE                              ; $A0FA07 |
  BCS CODE_A0FA1F                           ; $A0FA0A |

CODE_A0FA0C:
  STA.B $00                                 ; $A0FA0C |
  LDY.B $EE                                 ; $A0FA0E |
  JSR.W CODE_FN_A0FAB2                      ; $A0FA10 |
  BCC CODE_A0FA1D                           ; $A0FA13 |
  BIT.B $02                                 ; $A0FA15 |
  BMI CODE_A0FA1D                           ; $A0FA17 |

CODE_A0FA19:
  JSL.L CODE_FL_80893F                      ; $A0FA19 |

CODE_A0FA1D:
  PLX                                       ; $A0FA1D |
  RTL                                       ; $A0FA1E |

CODE_A0FA1F:
  CMP.W #$FFFF                              ; $A0FA1F |
  BEQ CODE_A0FA19                           ; $A0FA22 |
  JSL.L CODE_FL_808946                      ; $A0FA24 |
  BRA CODE_A0FA1D                           ; $A0FA28 |

CODE_FN_A0FA2A:
  STA.B $00                                 ; $A0FA2A |
  LDA.W #$0000                              ; $A0FA2C |
  JMP.W ($0000)                             ; $A0FA2F |

CODE_JL_A0FA32:
  CLC                                       ; $A0FA32 |
  RTS                                       ; $A0FA33 |

CODE_JL_A0FA34:
  SEC                                       ; $A0FA34 |
  RTS                                       ; $A0FA35 |

  LDA.W #$0000                              ; $A0FA36 |
  RTS                                       ; $A0FA39 |

  LDA.W #$FFFF                              ; $A0FA3A |
  RTS                                       ; $A0FA3D |

CODE_JL_A0FA3E:
  ORA.W #$0001                              ; $A0FA3E |
  CLC                                       ; $A0FA41 |
  RTS                                       ; $A0FA42 |

CODE_FL_A0FA43:
  PHX                                       ; $A0FA43 |
  JSL.L CODE_FL_808302                      ; $A0FA44 |
  STZ.B $02                                 ; $A0FA48 |
  LDA.B $F8                                 ; $A0FA4A |
  BPL CODE_A0FA5A                           ; $A0FA4C |
  CMP.W #$FFFE                              ; $A0FA4E |
  BCS CODE_A0FA5A                           ; $A0FA51 |
  JSR.W CODE_FN_A0FA96                      ; $A0FA53 |
  BCC CODE_A0FA5A                           ; $A0FA56 |
  DEC.B $02                                 ; $A0FA58 |

CODE_A0FA5A:
  STA.B $F8                                 ; $A0FA5A |
  TAY                                       ; $A0FA5C |
  BEQ CODE_A0FA90                           ; $A0FA5D |
  BPL CODE_A0FA66                           ; $A0FA5F |
  CMP.W #$FFFE                              ; $A0FA61 |
  BCS CODE_A0FA90                           ; $A0FA64 |

CODE_A0FA66:
  LDA.B $EE                                 ; $A0FA66 |
  EOR.B $F8                                 ; $A0FA68 |
  LSR A                                     ; $A0FA6A |
  BCC CODE_A0FA7E                           ; $A0FA6B |
  LDA.B $EE                                 ; $A0FA6D |
  LSR A                                     ; $A0FA6F |
  BCC CODE_A0FA77                           ; $A0FA70 |
  LDA.W #$004B                              ; $A0FA72 |
  BRA CODE_A0FA7A                           ; $A0FA75 |

CODE_A0FA77:
  LDA.W #$004A                              ; $A0FA77 |

CODE_A0FA7A:
  JSL.L push_sound_queue                    ; $A0FA7A |

CODE_A0FA7E:
  LDA.B $F8                                 ; $A0FA7E |
  LDY.B $EE                                 ; $A0FA80 |
  JSR.W CODE_FN_A0FAB2                      ; $A0FA82 |
  BCC CODE_A0FA90                           ; $A0FA85 |
  BIT.B $02                                 ; $A0FA87 |
  BMI CODE_A0FA90                           ; $A0FA89 |
  TAY                                       ; $A0FA8B |
  JSL.L set_music                           ; $A0FA8C |

CODE_A0FA90:
  LDA.B $F8                                 ; $A0FA90 |
  STA.B $EE                                 ; $A0FA92 |
  PLX                                       ; $A0FA94 |
  RTL                                       ; $A0FA95 |

CODE_FN_A0FA96:
  STA.B $00                                 ; $A0FA96 |
  LDA.W #$0001                              ; $A0FA98 |
  JMP.W ($0000)                             ; $A0FA9B |

CODE_JL_A0FA9E:
  CLC                                       ; $A0FA9E |
  RTS                                       ; $A0FA9F |

  LDA.W #$0000                              ; $A0FAA0 |
  RTS                                       ; $A0FAA3 |

CODE_JL_A0FAA4:
  ORA.W #$0001                              ; $A0FAA4 |
  CLC                                       ; $A0FAA7 |
  RTS                                       ; $A0FAA8 |

  LDA.B $EE                                 ; $A0FAA9 |
  ORA.W #$0001                              ; $A0FAAB |
  STA.B $EE                                 ; $A0FAAE |
  CLC                                       ; $A0FAB0 |
  RTS                                       ; $A0FAB1 |

CODE_FN_A0FAB2:
  PHA                                       ; $A0FAB2 |
  PHX                                       ; $A0FAB3 |
  PHY                                       ; $A0FAB4 |
  AND.W #$FFFE                              ; $A0FAB5 |
  TAX                                       ; $A0FAB8 |
  LDA.L music_table-2,X                     ; $A0FAB9 |
  STA.B $08                                 ; $A0FABD |
  PLA                                       ; $A0FABF |
  AND.W #$FFFE                              ; $A0FAC0 |
  TAX                                       ; $A0FAC3 |
  LDA.L music_table-2,X                     ; $A0FAC4 |
  CMP.B $08                                 ; $A0FAC8 |
  BEQ CODE_A0FAD0                           ; $A0FACA |
  PLX                                       ; $A0FACC |
  PLA                                       ; $A0FACD |
  SEC                                       ; $A0FACE |
  RTS                                       ; $A0FACF |

CODE_A0FAD0:
  PLX                                       ; $A0FAD0 |
  PLA                                       ; $A0FAD1 |
  CLC                                       ; $A0FAD2 |
  RTS                                       ; $A0FAD3 |

  BNE CODE_A0FAE8                           ; $A0FAD4 |
  LDA.L $70034C                             ; $A0FAD6 |
  BEQ CODE_A0FAE2                           ; $A0FADA |
  LDA.W #$0034                              ; $A0FADC |
  BRL CODE_JL_A0FA32                        ; $A0FADF |

CODE_A0FAE2:
  LDA.W #$0078                              ; $A0FAE2 |
  BRL CODE_JL_A0FA32                        ; $A0FAE5 |

CODE_A0FAE8:
  BRA CODE_JL_A0FA9E                        ; $A0FAE8 |

  BNE CODE_A0FAE8                           ; $A0FAEA |
  LDA.B $F8                                 ; $A0FAEC |
  CMP.W #$0078                              ; $A0FAEE |
  BNE CODE_A0FAF9                           ; $A0FAF1 |
  LDA.W #$0194                              ; $A0FAF3 |
  BRL CODE_JL_A0FA34                        ; $A0FAF6 |

CODE_A0FAF9:
  LDA.W #$001C                              ; $A0FAF9 |
  BRL CODE_JL_A0FA32                        ; $A0FAFC |

  BNE CODE_A0FAE8                           ; $A0FAFF |
  LDA.L $700758                             ; $A0FB01 |
  CMP.W #$0000                              ; $A0FB05 |
  BNE CODE_A0FB10                           ; $A0FB08 |
  LDA.W #$018C                              ; $A0FB0A |
  BRL CODE_JL_A0FA32                        ; $A0FB0D |

CODE_A0FB10:
  LDA.W #$0021                              ; $A0FB10 |
  BRL CODE_JL_A0FA32                        ; $A0FB13 |

  BNE CODE_A0FB2D                           ; $A0FB16 |
  LDA.L $700758                             ; $A0FB18 |
  CMP.W #$0002                              ; $A0FB1C |
  BNE CODE_A0FB27                           ; $A0FB1F |
  LDA.W #$0034                              ; $A0FB21 |
  BRL CODE_JL_A0FA32                        ; $A0FB24 |

CODE_A0FB27:
  LDA.W #$0020                              ; $A0FB27 |
  BRL CODE_JL_A0FAA4                        ; $A0FB2A |

CODE_A0FB2D:
  BRL CODE_JL_A0FA9E                        ; $A0FB2D |

  BNE CODE_A0FB3F                           ; $A0FB30 |
  LDA.W #$004B                              ; $A0FB32 |
  JSL.L push_sound_queue                    ; $A0FB35 |
  LDA.W #$0020                              ; $A0FB39 |
  BRL CODE_JL_A0FA32                        ; $A0FB3C |

CODE_A0FB3F:
  BRL CODE_JL_A0FA9E                        ; $A0FB3F |

  BNE CODE_A0FB69                           ; $A0FB42 |
  LDA.L $700758                             ; $A0FB44 |
  CMP.W #$000B                              ; $A0FB48 |
  BEQ CODE_A0FB63                           ; $A0FB4B |
  CMP.W #$0005                              ; $A0FB4D |
  BEQ CODE_A0FB5D                           ; $A0FB50 |
  CMP.W #$0007                              ; $A0FB52 |
  BEQ CODE_A0FB5D                           ; $A0FB55 |
  LDA.W #$0074                              ; $A0FB57 |
  BRL CODE_JL_A0FA32                        ; $A0FB5A |

CODE_A0FB5D:
  LDA.W #$0080                              ; $A0FB5D |
  BRL CODE_JL_A0FA32                        ; $A0FB60 |

CODE_A0FB63:
  LDA.W #$0078                              ; $A0FB63 |
  BRL CODE_JL_A0FA32                        ; $A0FB66 |

CODE_A0FB69:
  BRL CODE_JL_A0FA9E                        ; $A0FB69 |

  BNE CODE_A0FB9A                           ; $A0FB6C |
  LDA.B $F8                                 ; $A0FB6E |
  AND.W #$FFFE                              ; $A0FB70 |
  CMP.W #$0098                              ; $A0FB73 |
  BEQ CODE_A0FB94                           ; $A0FB76 |
  CMP.W #$0088                              ; $A0FB78 |
  BEQ CODE_A0FB94                           ; $A0FB7B |
  LDA.W $1672                               ; $A0FB7D |
  CMP.W #$0260                              ; $A0FB80 |
  BCS CODE_A0FB8B                           ; $A0FB83 |

CODE_A0FB85:
  LDA.W #$0074                              ; $A0FB85 |
  BRL CODE_JL_A0FA32                        ; $A0FB88 |

CODE_A0FB8B:
  LDA.L $700758                             ; $A0FB8B |
  CMP.W #$0006                              ; $A0FB8F |
  BEQ CODE_A0FB85                           ; $A0FB92 |

CODE_A0FB94:
  LDA.W #$0098                              ; $A0FB94 |
  BRL CODE_JL_A0FA32                        ; $A0FB97 |

CODE_A0FB9A:
  BRL CODE_JL_A0FA9E                        ; $A0FB9A |

  BNE CODE_A0FBB1                           ; $A0FB9D |
  LDA.L $7002AE                             ; $A0FB9F |
  BNE CODE_A0FBAB                           ; $A0FBA3 |
  LDA.W #$0024                              ; $A0FBA5 |
  BRL CODE_JL_A0FA32                        ; $A0FBA8 |

CODE_A0FBAB:
  LDA.W #$0028                              ; $A0FBAB |
  BRL CODE_JL_A0FA32                        ; $A0FBAE |

CODE_A0FBB1:
  BRL CODE_JL_A0FA9E                        ; $A0FBB1 |

  BNE CODE_A0FBCB                           ; $A0FBB4 |
  LDA.L $70073C                             ; $A0FBB6 |
  CMP.W #$0001                              ; $A0FBBA |
  BEQ CODE_A0FBC5                           ; $A0FBBD |
  LDA.W #$0074                              ; $A0FBBF |
  BRL CODE_JL_A0FA3E                        ; $A0FBC2 |

CODE_A0FBC5:
  LDA.W #$00A0                              ; $A0FBC5 |
  BRL CODE_JL_A0FA32                        ; $A0FBC8 |

CODE_A0FBCB:
  BRL CODE_JL_A0FA9E                        ; $A0FBCB |

  BNE CODE_A0FBEA                           ; $A0FBCE |
  LDA.B $F8                                 ; $A0FBD0 |
  CMP.W #$00A0                              ; $A0FBD2 |
  BEQ CODE_A0FBDD                           ; $A0FBD5 |
  LDA.W #$0190                              ; $A0FBD7 |
  BRL CODE_JL_A0FA3E                        ; $A0FBDA |

CODE_A0FBDD:
  LDA.W #$0000                              ; $A0FBDD |
  STA.L $700742                             ; $A0FBE0 |
  LDA.W #$00A0                              ; $A0FBE4 |
  BRL CODE_JL_A0FA32                        ; $A0FBE7 |

CODE_A0FBEA:
  BRL CODE_JL_A0FA9E                        ; $A0FBEA |

  BNE CODE_A0FC0E                           ; $A0FBED |
  LDA.L $7008E0                             ; $A0FBEF |
  BEQ CODE_A0FC08                           ; $A0FBF3 |
  LDA.L $700696                             ; $A0FBF5 |
  AND.W #$00FF                              ; $A0FBF9 |
  BEQ CODE_A0FC02                           ; $A0FBFC |
  LDA.B $A6                                 ; $A0FBFE |
  BNE CODE_A0FC08                           ; $A0FC00 |

CODE_A0FC02:
  LDA.W #$010C                              ; $A0FC02 |
  BRL CODE_JL_A0FA32                        ; $A0FC05 |

CODE_A0FC08:
  LDA.W #$0108                              ; $A0FC08 |
  BRL CODE_JL_A0FA32                        ; $A0FC0B |

CODE_A0FC0E:
  BRL CODE_JL_A0FA9E                        ; $A0FC0E |

  BNE CODE_A0FC2E                           ; $A0FC11 |
  LDA.L $7008E2                             ; $A0FC13 |
  BEQ CODE_A0FC22                           ; $A0FC17 |
  LDA.L $7006AB                             ; $A0FC19 |
  AND.W #$00FF                              ; $A0FC1D |
  BEQ CODE_A0FC28                           ; $A0FC20 |

CODE_A0FC22:
  LDA.W #$00A8                              ; $A0FC22 |
  BRL CODE_JL_A0FA32                        ; $A0FC25 |

CODE_A0FC28:
  LDA.W #$0110                              ; $A0FC28 |
  BRL CODE_JL_A0FA32                        ; $A0FC2B |

CODE_A0FC2E:
  BRL CODE_JL_A0FA9E                        ; $A0FC2E |

  BNE CODE_A0FC48                           ; $A0FC31 |
  LDA.L $7006AB                             ; $A0FC33 |
  AND.W #$00FF                              ; $A0FC37 |
  BEQ CODE_A0FC28                           ; $A0FC3A |
  LDA.W #$00A8                              ; $A0FC3C |
  BRL CODE_JL_A0FA32                        ; $A0FC3F |

  LDA.W #$0110                              ; $A0FC42 |
  BRL CODE_JL_A0FA32                        ; $A0FC45 |

CODE_A0FC48:
  BRL CODE_JL_A0FA9E                        ; $A0FC48 |

  BNE CODE_A0FC60                           ; $A0FC4B |
  LDA.B $F8                                 ; $A0FC4D |
  CMP.W #$019C                              ; $A0FC4F |
  BNE CODE_A0FC5A                           ; $A0FC52 |
  LDA.W #$01A0                              ; $A0FC54 |
  BRL CODE_JL_A0FA32                        ; $A0FC57 |

CODE_A0FC5A:
  LDA.W #$000C                              ; $A0FC5A |
  BRL CODE_JL_A0FA32                        ; $A0FC5D |

CODE_A0FC60:
  BRL CODE_JL_A0FA9E                        ; $A0FC60 |

  BNE CODE_A0FC78                           ; $A0FC63 |
  LDA.B $F8                                 ; $A0FC65 |
  CMP.W #$019C                              ; $A0FC67 |
  BNE CODE_A0FC72                           ; $A0FC6A |
  LDA.W #$01A0                              ; $A0FC6C |
  BRL CODE_JL_A0FA32                        ; $A0FC6F |

CODE_A0FC72:
  LDA.W #$0190                              ; $A0FC72 |
  BRL CODE_JL_A0FA32                        ; $A0FC75 |

CODE_A0FC78:
  BRL CODE_JL_A0FA9E                        ; $A0FC78 |

  BNE CODE_A0FC90                           ; $A0FC7B |
  LDA.B $F8                                 ; $A0FC7D |
  CMP.W #$00F4                              ; $A0FC7F |
  BEQ CODE_A0FC8A                           ; $A0FC82 |
  LDA.W #$0075                              ; $A0FC84 |
  BRL CODE_JL_A0FA32                        ; $A0FC87 |

CODE_A0FC8A:
  LDA.W #$00F5                              ; $A0FC8A |
  BRL CODE_JL_A0FA32                        ; $A0FC8D |

CODE_A0FC90:
  BRL CODE_JL_A0FA9E                        ; $A0FC90 |

  BNE CODE_A0FCA7                           ; $A0FC93 |
  LDA.L $700782                             ; $A0FC95 |
  BNE CODE_A0FCA1                           ; $A0FC99 |
  LDA.W #$005C                              ; $A0FC9B |
  BRL CODE_JL_A0FA32                        ; $A0FC9E |

CODE_A0FCA1:
  LDA.W #$00A8                              ; $A0FCA1 |
  BRL CODE_JL_A0FA32                        ; $A0FCA4 |

CODE_A0FCA7:
  BRL CODE_JL_A0FA9E                        ; $A0FCA7 |

  BNE CODE_A0FCBE                           ; $A0FCAA |
  LDA.L $700786                             ; $A0FCAC |
  BNE CODE_A0FCB8                           ; $A0FCB0 |
  LDA.W #$0104                              ; $A0FCB2 |
  BRL CODE_JL_A0FA32                        ; $A0FCB5 |

CODE_A0FCB8:
  LDA.W #$00B8                              ; $A0FCB8 |
  BRL CODE_JL_A0FA32                        ; $A0FCBB |

CODE_A0FCBE:
  BRL CODE_JL_A0FA9E                        ; $A0FCBE |

  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCC1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCC9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCD1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCD9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCE1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCE9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCF1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FCF9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD01 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD09 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD11 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD19 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD21 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD29 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD31 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD39 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD41 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD49 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD51 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD59 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD61 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD69 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD71 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD79 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD81 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD89 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD91 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FD99 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDA1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDA9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDB1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDB9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDC1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDC9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDD1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDD9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDE1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDE9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDF1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FDF9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE01 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE09 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE11 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE19 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE21 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE29 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE31 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE39 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE41 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE49 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE51 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE59 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE61 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE69 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE71 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE79 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE81 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE89 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE91 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FE99 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEA1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEA9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEB1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEB9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEC1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEC9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FED1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FED9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEE1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEE9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEF1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FEF9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF01 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF09 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF11 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF19 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF21 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF29 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF31 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF39 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF41 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF49 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF51 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF59 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF61 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF69 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF71 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF79 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF81 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF89 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF91 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FF99 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFA1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFA9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFB1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFB9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFC1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFC9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFD1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFD9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFE1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFE9 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF        ; $A0FFF1 |
  db $FF,$FF,$FF,$FF,$FF,$FF,$FF            ; $A0FFF9 |
