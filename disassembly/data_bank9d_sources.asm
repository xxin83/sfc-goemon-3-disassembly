; Bounded compressed blocks referenced by bank $88.
incbin ../assets/bank_9D.bin:$0..$65E0   ; unconverted gap before $9DE5E0

FILE_9DE5E0:
  ; Header size $002B proves 43 bytes.
  db $2B,$00,$FF,$3E,$82,$01,$03,$0C,$1F,$84,$51,$57,$53,$0B,$04,$28 ; $9DE5E0
  db $83,$10,$5F,$17,$E3,$84,$11,$01,$5F,$15,$E2,$84,$12,$10,$01,$56 ; $9DE5F0
  db $E3,$83,$16,$57,$58,$E2,$81,$13,$C7,$5F,$E6 ; $9DE600

FILE_9DE60B:
  ; Header size $003C proves 60 bytes.
  db $3C,$00,$C0,$01,$81,$10,$07,$DD,$DE,$41,$C0,$41,$82,$47,$49,$20 ; $9DE60B
  db $05,$C1,$41,$CA,$01,$C2,$41,$81,$40,$E8,$81,$40,$48,$22,$24,$35 ; $9DE61B
  db $81,$40,$0C,$10,$81,$4A,$20,$48,$81,$40,$7C,$21,$08,$04,$24,$47 ; $9DE62B
  db $08,$13,$C0,$40,$E7,$81,$48,$7F,$E6,$81,$41,$FE ; $9DE63B
incbin ../assets/bank_9D.bin:$6647..$691E   ; unconverted gap before $9DE91E

VRAM_9DE91E:
  ; Header size $0074 proves 116 bytes.
  db $74,$06,$FE,$DE,$FF,$C0,$FF,$0B,$FD,$08,$22,$08,$21,$81,$80,$08 ; $9DE91E
  db $20,$1C,$30,$E0,$81,$40,$0C,$25,$86,$FF,$FC,$05,$FB,$FD,$02,$10 ; $9DE92E
  db $21,$0C,$2F,$85,$01,$FF,$07,$FF,$03,$08,$39,$0C,$49,$24,$22,$14 ; $9DE93E
  db $4D,$1C,$34,$E0,$93,$08,$AD,$08,$2D,$88,$AD,$08,$AD,$89,$2D,$09 ; $9DE94E
  db $2D,$09,$AD,$09,$AD,$6E,$10,$EE,$1C,$90,$00,$8F,$00,$9B,$8A,$3F ; $9DE95E
  db $40,$3D,$41,$03,$7B,$65,$AD,$77,$5E,$04,$A7,$90,$56,$77,$56,$80 ; $9DE96E
  db $FF,$82,$FE,$85,$FC,$52,$18,$E3,$08,$E3,$08,$EB,$04,$BA,$9F,$3F ; $9DE97E
  db $BF,$D9,$C7,$07 ; $9DE98E
incbin ../assets/bank_9D.bin:$6992..$6F92   ; unconverted gap before $9DEF92

VRAM_9DEF92:
  ; Header size $00C8 proves 200 bytes.
  db $C8,$02,$81,$A1,$A2,$A0,$A1,$A7,$EE,$9F,$01,$A7,$80,$10,$81,$B9 ; $9DEF92
  db $61,$40,$00,$00,$40,$00,$40,$01,$40,$07,$00,$40,$C0,$60,$E1,$00 ; $9DEFA2
  db $61,$36,$EE,$EA,$00,$D7,$0D,$AD,$40,$92,$38,$F8,$FF,$00,$F9,$06 ; $9DEFB2
  db $DC,$23,$CF,$E1,$11,$17,$4D,$2E,$E1,$1E,$FF,$07,$E4,$96,$76,$78 ; $9DEFC2
  db $7B,$7C,$F9,$FE,$03,$FC,$70,$7F,$FF,$00,$EB,$14,$CB,$34,$FC,$80 ; $9DEFD2
  db $FE,$80,$FF,$00,$04,$33,$87,$80,$00,$00,$03,$04,$03,$04,$E2,$81 ; $9DEFE2
  db $C0,$A2,$F0,$F8,$F0,$80,$83,$30,$B0,$30,$E4,$08,$43,$E1,$00,$4E ; $9DEFF2
  db $8E,$30,$DB,$14,$6E,$93,$EC,$12,$7E,$81,$FF,$00,$AF,$40,$A1,$07 ; $9DF002
  db $E2,$86,$22,$04,$01,$02,$01,$03,$A3,$01,$00,$00,$40,$40,$9F,$69 ; $9DF012
  db $FD,$AF,$7B,$EE,$E0,$9B,$95,$FF,$60,$7F,$80,$A4,$5B,$69,$1F,$F3 ; $9DF022
  db $0E,$F1,$0A,$F1,$11,$60,$F1,$00,$60,$1F,$1F,$FF,$3F,$3F,$91,$BF ; $9DF032
  db $FD,$FF,$FD,$FF,$F8,$FC,$67,$64,$BF,$A0,$EF,$10,$DB,$3C,$76,$89 ; $9DF042
  db $0C,$33,$96,$03,$F8,$9C,$42,$E0 ; $9DF052
incbin ../assets/bank_9D.bin:$705A..$725A   ; unconverted gap before $9DF25A

VRAM_9DF25A:
  ; Header size $000B proves 11 bytes.
  db $0B,$8C,$FE,$C6,$FF,$6F,$E7,$83,$FB,$E0,$ED ; $9DF25A

; End of extracted blocks: $9DF265
