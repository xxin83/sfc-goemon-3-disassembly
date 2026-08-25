; Bounded compressed blocks referenced by bank $88.
incbin ../assets/bank_9B.bin:$0..$6AFD   ; unconverted gap before $9BEAFD

SPRITE_9BEAFD:
  ; Header size $0055 proves 85 bytes.
  db $55,$00,$8D,$02,$1B,$00,$0D,$0E,$01,$05,$05,$FD,$F5,$09,$F1,$F9 ; $9BEAFD
  db $07,$E6,$07,$ED,$07,$E4,$85,$F9,$09,$F1,$FD,$F5,$0F,$EC,$85,$F2 ; $9BEB0D
  db $FA,$E2,$FA,$FA,$C1,$F2,$C1,$EA,$C0,$E2,$C0,$F2,$00,$00,$C1,$F2 ; $9BEB1D
  db $C0,$FA,$0C,$07,$8E,$84,$80,$85,$81,$80,$83,$82,$84,$89,$88,$87 ; $9BEB2D
  db $86,$85,$8A,$04,$1A,$85,$84,$83,$82,$81,$80,$0C,$22,$C1,$4F,$C8 ; $9BEB3D
  db $0F,$C2,$4F,$C8,$0F ; $9BEB4D

SPRITE_9BEB52:
  ; Header size $0058 proves 88 bytes.
  db $58,$00,$86,$02,$1B,$00,$0D,$0E,$05,$C1,$F5,$C0,$05,$88,$F1,$FD ; $9BEB52
  db $FD,$05,$FD,$FD,$F5,$F1,$0B,$E4,$C1,$FD,$C1,$05,$07,$EE,$86,$E2 ; $9BEB62
  db $EA,$F2,$FA,$FA,$F2,$04,$00,$C0,$EA,$C0,$E2,$00,$09,$86,$EA,$FA ; $9BEB72
  db $F2,$FA,$EE,$F2,$04,$03,$04,$09,$97,$80,$83,$84,$85,$85,$84,$88 ; $9BEB82
  db $87,$86,$83,$82,$81,$80,$88,$80,$83,$85,$84,$86,$89,$87,$85,$84 ; $9BEB92
  db $08,$23,$C2,$49,$C8,$09,$2C,$35 ; $9BEBA2

FILE_9BEBAA:
  ; Header size $0027 proves 39 bytes.
  db $27,$00,$FF,$3E,$8D,$01,$02,$03,$04,$0C,$0D,$0E,$0F,$05,$05,$06 ; $9BEBAA
  db $07,$10,$C1,$05,$82,$08,$09,$10,$2F,$82,$0A,$0B,$10,$37,$C6,$11 ; $9BEBBA
  db $C1,$12,$81,$13,$08,$47,$EE ; $9BEBCA
incbin ../assets/bank_9B.bin:$6BD1..$6CB8   ; unconverted gap before $9BECB8

FILE_9BECB8:
  ; Header size $0009 proves 9 bytes.
  db $09,$00,$FF,$48,$C0,$70,$10,$27,$E0 ; $9BECB8

VRAM_9BECC1:
  ; Header size $0071 proves 113 bytes.
  db $71,$84,$88,$00,$01,$02,$03,$03,$02,$03,$04,$17,$DF,$81,$05,$07 ; $9BECC1
  db $DE,$0B,$EF,$83,$03,$00,$01,$C3,$03,$94,$07,$F0,$48,$E4,$54,$BC ; $9BECD1
  db $54,$B8,$F1,$F0,$38,$EC,$1C,$54,$94,$B8,$71,$00,$F0,$18,$C1,$E8 ; $9BECE1
  db $84,$40,$80,$F0,$F8,$C2,$FC,$82,$F8,$F1,$0B,$F2,$84,$01,$06,$1D ; $9BECF1
  db $ED,$04,$1F,$03,$E8,$83,$01,$13,$EA,$E1,$85,$03,$06,$09,$03,$1C ; $9BED01
  db $04,$27,$03,$FD,$9F,$0D,$1B,$FF,$3F,$E0,$3C,$7F,$FF,$CF,$E8,$D7 ; $9BED11
  db $3F,$DF,$DB,$98,$38,$AF,$78,$9F,$00,$3F,$98,$18,$38,$B0,$3F,$68 ; $9BED21
  db $3F ; $9BED31
incbin ../assets/bank_9B.bin:$6D32..$7132   ; unconverted gap before $9BF132

VRAM_9BF132:
  ; Header size $0082 proves 130 bytes.
  db $82,$8D,$9F,$2F,$35,$1F,$3F,$5F,$74,$3A,$3C,$14,$0A,$0E,$04,$20 ; $9BF132
  db $18,$0B,$04,$00,$0A,$0E,$0E,$34,$23,$04,$03,$14,$00,$04,$00,$00 ; $9BF142
  db $0B,$0F,$9F,$07,$A6,$CC,$F9,$EE,$E5,$E7,$CD,$FA,$66,$8C,$21,$52 ; $9BF152
  db $1B,$98,$33,$A6,$19,$33,$86,$99,$28,$28,$18,$11,$7F,$3F,$27,$03 ; $9BF162
  db $03,$80,$9F,$03,$87,$2C,$B0,$1F,$66,$8A,$64,$83,$FA,$30,$C0,$00 ; $9BF172
  db $64,$8C,$F8,$80,$FC,$C0,$00,$E0,$98,$70,$00,$7C,$00,$F0,$C0,$E0 ; $9BF182
  db $FC,$FC,$9F,$F8,$FC,$FC,$2F,$2D,$F4,$AF,$CF,$D3,$E8,$B6,$10,$15 ; $9BF192
  db $0C,$70,$4F,$57,$7B,$7F,$10,$12,$03,$00,$30,$28,$04,$00,$10,$17 ; $9BF1A2
  db $0F,$70 ; $9BF1B2

; End of extracted blocks: $9BF1B4
