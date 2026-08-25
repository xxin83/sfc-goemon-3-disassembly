; Bounded compressed blocks referenced by bank $88.
incbin ../assets/bank_A0.bin:$0..$6B80   ; unconverted gap before $A0EB80

VRAM_A0EB80:
  ; Header size $0047 proves 71 bytes.
  db $47,$00,$81,$80,$7F,$DE,$7F,$FF,$7C,$20,$7C,$41,$7C,$62,$7C,$83 ; $A0EB80
  db $1C,$A4,$82,$81,$04,$70,$AF,$7C,$8F,$7C,$B0,$7C,$D1,$7C,$F2,$7D ; $A0EB90
  db $13,$7D,$34,$7D,$55,$7D,$76,$7D,$97,$7D,$B8,$7D,$D9,$7D,$FA,$7E ; $A0EBA0
  db $1B,$7E,$3C,$7E,$5D,$7E,$7E,$7E,$9F,$7E,$C0,$7E,$E1,$7F,$02,$7F ; $A0EBB0
  db $23,$7F,$44,$7F,$A3,$5F,$C4 ; $A0EBC0
incbin ../assets/bank_A0.bin:$6BC7..$6BDA   ; unconverted gap before $A0EBDA

VRAM_A0EBDA:
  ; Header size $0057 proves 87 bytes.
  db $57,$01,$9F,$52,$1F,$13,$1E,$2D,$0D,$19,$01,$0C,$0F,$08,$0F,$0B ; $A0EBDA
  db $03,$07,$00,$21,$04,$20,$00,$13,$00,$06,$07,$10,$1F,$10,$1F,$04 ; $A0EBEA
  db $07,$00,$9F,$00,$5A,$E7,$FF,$1A,$BD,$C3,$A6,$A4,$5A,$DB,$A4,$BF ; $A0EBFA
  db $2B,$3B,$87,$20,$FF,$3C,$1A,$18,$FF,$00,$7D,$C1,$24,$C7,$40,$87 ; $A0EC0A
  db $C4,$87,$81,$58,$E1,$93,$02,$09,$1F,$07,$07,$00,$03,$01,$03,$03 ; $A0EC1A
  db $07,$07,$04,$02,$0F,$00,$10 ; $A0EC2A
incbin ../assets/bank_A0.bin:$6C31..$6D31   ; unconverted gap before $A0ED31

VRAM_A0ED31:
  ; Header size $002A proves 42 bytes.
  db $2A,$81,$FE,$C4,$FF,$82,$FE,$FC,$33,$F7,$C8,$FF,$85,$F8,$F0,$E0 ; $A0ED31
  db $C0,$80,$3F,$F4,$C8,$FF,$53,$EF,$38,$35,$82,$01,$03,$18,$5F,$1B ; $A0ED41
  db $FF,$C6,$FF,$85,$07,$0F,$1F,$3F,$7F,$24 ; $A0ED51
incbin ../assets/bank_A0.bin:$6D5B..$6E5B   ; unconverted gap before $A0EE5B

VRAM_A0EE5B:
  ; Header size $00F6 proves 246 bytes.
  db $F6,$00,$82,$00,$33,$4F,$DF,$81,$23,$3F,$E7,$3B,$F6,$68,$16,$08 ; $A0EE5B
  db $06,$18,$36,$38,$32,$7C,$4E,$7C,$31,$7C,$90,$7C,$B1,$3C,$D2,$83 ; $A0EE6B
  db $AD,$33,$AE,$7C,$E6,$41,$07,$82,$AD,$73,$18,$DD,$81,$AF,$04,$80 ; $A0EE7B
  db $87,$20,$33,$2B,$33,$8E,$33,$26,$05,$26,$81,$07,$05,$30,$81,$61 ; $A0EE8B
  db $30,$80,$15,$44,$81,$89,$1C,$DC,$81,$6A,$05,$38,$81,$AF,$2D,$1C ; $A0EE9B
  db $83,$30,$33,$3B,$05,$66,$85,$36,$33,$5F,$33,$17,$05,$6C,$81,$71 ; $A0EEAB
  db $4D,$38,$81,$99,$1D,$4E,$81,$7A,$3D,$58,$7D,$A7,$3D,$C8,$79,$9B ; $A0EEBB
  db $81,$AA,$7D,$BC,$1C,$DD,$82,$B3,$AE,$7E,$26,$42,$47,$82,$AD,$F3 ; $A0EECB
  db $7C,$DD,$7C,$FE,$59,$1F,$81,$62,$7D,$38,$71,$59,$81,$72,$7D,$78 ; $A0EEDB
  db $7D,$D9,$7F,$38,$7D,$DB,$7F,$3C,$7E,$1D,$7E,$3E,$7E,$5F,$7E,$80 ; $A0EEEB
  db $52,$A1,$81,$63,$7E,$B8,$72,$D9,$81,$73,$7E,$F8,$7F,$59,$7C,$B8 ; $A0EEFB
  db $7F,$5B,$7C,$BC,$7F,$9D,$7F,$BE,$7D,$5D,$7D,$7E,$6B,$E3,$00,$1B ; $A0EF0B
  db $69,$A3,$7C,$9D,$05,$1A,$40,$25,$02,$0F,$83,$09,$33,$0D,$7C,$98 ; $A0EF1B
  db $29,$F7,$30,$69,$02,$4F,$83,$19,$33,$1D,$2E,$16,$61,$25,$01,$5B ; $A0EF2B
  db $6A,$63,$7D,$81,$7E,$BA,$7E,$DB,$7E,$FC,$7F,$1D,$7F,$3E,$7F,$5F ; $A0EF3B
  db $7F,$80,$7F,$A1,$67,$C2 ; $A0EF4B

; End of extracted blocks: $A0EF51
