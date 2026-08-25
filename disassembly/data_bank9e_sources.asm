; Bounded compressed blocks referenced by bank $88.
incbin ../assets/bank_9E.bin:$0..$7E80   ; unconverted gap before $9EFE80

FILE_9EFE80:
  ; Header size $0015 proves 21 bytes.
  db $15,$00,$FF,$46,$82,$01,$03,$0C,$27,$CD,$02,$81,$05,$1C,$2D,$82 ; $9EFE80
  db $01,$04,$C4,$02,$EE ; $9EFE90

FILE_9EFE95:
  ; Header size $0037 proves 55 bytes.
  db $37,$00,$FF,$3E,$9F,$01,$02,$03,$04,$11,$12,$13,$14,$05,$06,$07 ; $9EFE95
  db $08,$15,$16,$17,$18,$09,$0A,$0B,$0C,$0C,$19,$1A,$1B,$0D,$0E,$0F ; $9EFEA5
  db $10,$10,$1C,$1D,$91,$1E,$1F,$20,$21,$10,$10,$26,$27,$28,$22,$23 ; $9EFEB5
  db $24,$25,$29,$2A,$2B,$2C,$EE ; $9EFEC5

FILE_9EFECC:
  ; Header size $007A proves 122 bytes.
  db $7A,$00,$83,$01,$02,$10,$07,$DD,$D1,$41,$82,$4A,$4B,$07,$E4,$C0 ; $9EFECC
  db $01,$07,$FB,$07,$F6,$82,$4A,$48,$C1,$41,$C6,$40,$C6,$41,$34,$0A ; $9EFEDC
  db $18,$20,$0C,$29,$07,$F8,$0C,$31,$C0,$21,$04,$30,$0F,$E4,$81,$40 ; $9EFEEC
  db $07,$E2,$C0,$01,$C0,$21,$83,$01,$00,$00,$0C,$2A,$3C,$48,$04,$58 ; $9EFEFC
  db $E4,$14,$29,$81,$4A,$E6,$04,$06,$10,$05,$14,$6C,$1C,$12,$30,$8B ; $9EFF0C
  db $14,$68,$10,$72,$0C,$36,$18,$7D,$38,$95,$50,$85,$28,$AA,$20,$75 ; $9EFF1C
  db $0C,$41,$14,$04,$7C,$8B,$7C,$AC,$7C,$CD,$20,$EF,$10,$F8,$11,$40 ; $9EFF2C
  db $81,$4A,$19,$43,$21,$6F,$31,$87,$FF,$3E ; $9EFF3C

; End of extracted blocks: $9EFF46
