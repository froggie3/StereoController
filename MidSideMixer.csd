<Cabbage> bounds(0, 0, 0, 0)
form size(510, 440), caption("M/S Mixer"), pluginId("MsMixer"), colour(128, 39, 39, 255) outlinecolour("white")
image bounds(10, 10, 490, 420) colour(152, 46, 46, 255)

// Title
groupbox bounds(24, 26, 456, 51) colour(255, 255, 255, 26) fontcolour(255, 255, 255, 255) outlinecolour(255, 255, 255, 0) outlinethickness(2) corners(1)
label bounds(36, 34, 195, 33), text("M/S Mixer"), fontcolour(233, 233, 233, 255) align("left") corners(0)
label bounds(252, 34, 212, 12) text("Just a simple mid / side processor") align("right") fontcolour(255, 255, 255, 255), corners(0) 
groupbox fontcolour(255, 255, 255, 255), , 255) colour(94, 94, 94, 255) corners(0) outlinecolour(0, 0, 0, 0) bounds(10, 20, 480, 53)
label bounds(252, 58, 211, 10) text("built by Yokkin / v1.0.1 (21 December 2020)") align("right") colour(255, 255, 255, 0) fontcolour(255, 255, 255, 255)

// Volume
groupbox bounds(24, 86, 273, 326) fontcolour(233, 233, 233, 255) colour(255, 255, 255, 26) outlinecolour(255, 255, 255, 255) corners(0) outlinethickness(2) linethickness(10) text("Volume")
label bounds(46, 384, 96, 12) text("Mid Volume (dB)") fontcolour(255, 255, 255, 255)
vslider bounds(64, 120, 48, 256) range(-144, 6, 0, 6, 0.1) trackercolour(0, 118, 38, 0) channel("Mid Volume (dB)")
vslider bounds(178, 120, 48, 256) range(-144, 6, 0, 6, 0.1) trackercolour(0, 118, 38, 0) channel("Side Volume (dB)") 
label bounds(158, 384, 103, 12) text("Side Volume (dB)") colour(255, 255, 255, 0) fontcolour(255, 255, 255, 255)
label bounds(114, 172, 51, 12) text("0dB") align("left") fontcolour(255, 255, 255, 255)
label bounds(224, 172, 51, 12) text("0dB") align("left") fontcolour(255, 255, 255, 255)
label bounds(114, 358, 51, 12) text("-144dB") align("left") fontcolour(255, 255, 255, 255)
label bounds(224, 358, 51, 12) text("-144dB") align("left") fontcolour(255, 255, 255, 255)
label bounds(114, 122, 51, 12) text("+6dB") align("left") fontcolour(255, 255, 255, 255)
label bounds(224, 122, 51, 12) text("+6dB") align("left") fontcolour(255, 255, 255, 255)

// Invert
groupbox bounds(310, 338, 170, 74) fontcolour(233, 233, 233, 255) colour(255, 255, 255, 26) outlinecolour(255, 255, 255, 255) corners(0) outlinethickness(2) linethickness(10) text("Routing")
label bounds(324, 374, 55, 14) text("INVERT") align("left") fontcolour(255, 255, 255, 255)
combobox bounds(400, 372, 64, 20) text("NONE", "LEFT", "RIGHT") channel("Invert") colour(212, 212, 212, 255) fontcolour(0, 0, 0, 255)

// Panning
groupbox bounds(310, 86, 170, 239) fontcolour(233, 233, 233, 255) colour(255, 255, 255, 26) outlinecolour(255, 255, 255, 255) corners(0) outlinethickness(2) linethickness(10) text("Panning")
rslider bounds(338, 160, 116, 100) range(-100, 100, 0, 1, 0.1) channel("Panning (%)")  trackercolour(205, 41, 4, 255) textcolour(255, 255, 255, 255) trackerinsideradius(0.8) outlinecolour(229, 80, 24, 50) colour(255, 255, 255, 255) markercolour(224, 108, 89, 255)   textboxoutlinecolour(128, 128, 128, 0) 
label bounds(339, 264, 37, 12) text("-100L") align("left") fontcolour(255, 255, 255, 255)
label bounds(418, 264, 36, 12) text("100R") align("right") fontcolour(255, 255, 255, 255)
label bounds(324, 140, 141, 12) text("Center")  fontcolour(255, 255, 255, 255)
label bounds(324, 292, 65, 14) text("PAN LAW") align("left") fontcolour(255, 255, 255, 255)  
combobox bounds(394, 290, 70, 20) text("NONE", "LINEAR: (-6 dB Center)", "SQUARE: (-3 dB Center)", "CIRCULAR: (-3 dB Center)", "CIRCULAR: (-4.5 dB Center)", "CIRCULAR: (-6 dB Center)") channel("Pan Law") colour(212, 212, 212, 255) fontcolour(0, 0, 0, 255) 


checkbox bounds(324, 118, 71, 16) value(1) channel("Panning") text("Panning") colour:1(255, 255, 0, 255) fontcolour:1(255, 255, 255, 255)
</Cabbage>
<CsoundSynthesizer>

<CsOptions>
-n -d
</CsOptions>

<CsInstruments>
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1
    kmidlevel       chnget "Mid Volume (dB)"
    ksidelevel      chnget "Side Volume (dB)"
    kinvert         chnget "Invert"
    kPanSwitch      chnget "Panning"
    kBal            chnget "Panning (%)"
    kPanLaw         chnget "Pan Law"
    kporttime linseg 0, 0.01, 0.03
    
    kmidlevel portk kmidlevel, kporttime
    kmidlevel= db(kmidlevel)
    
    ksidelevel portk ksidelevel, kporttime
    ksidelevel = db(ksidelevel)
    
    kBal portk kBal, kporttime
    kBal = (kBal + 100) * 0.005 // 0.0 ~ 1.0
    
    asigL, asigR ins
    
    asigM = (asigL + asigR)/2
    asigS = (asigL - asigR)/2
    
    asigM *= kmidlevel
    asigS *= ksidelevel
    
    // Routing
        if kinvert = 1 then
            asigL = asigM + asigS
            asigR = asigM - asigS
        endif
    
        if kinvert = 2 then     // Left Invert
            asigL = -(asigM + asigS)
            asigR = asigM - asigS
        endif
    
        if kinvert = 3 then      // Right Invert
            asigL = asigM + asigS
            asigR = -(asigM - asigS)
        endif

    
    // Panning
    if kPanSwitch = 1 then
        if kPanLaw = 1 then
            if kBal = 0.5 then
                asigL *= 1
                asigR *= 1
            endif
        
            if kBal < 0.5 then // Left
                asigL *= 1
                asigR *= (2 * kBal)
            endif
        
            if kBal > 0.5 then // Right
                asigL *= (1 - kBal) * 2
                asigR *= 1
            endif
            

        endif
        if kPanLaw = 2 then
            asigL *= (1 - kBal)
            asigR *= kBal
        endif
    
        if kPanLaw = 3 then // Square 
            asigL *= sqrt(1.0 - kBal)
            asigR *= sqrt(kBal)
        endif
    
        if kPanLaw = 4 then // - 3dB center law
            asigL *= sin((1.0 - kBal) * $M_PI_2)
            asigR *= sin(kBal * $M_PI_2)
        endif
    
        if kPanLaw = 5 then // - 4.5dB center law
            asigL *= pow(sin((1.0 - kBal) * $M_PI_2), 1.5)
            asigR *= pow(sin(kBal * $M_PI_2), 1.5)
        endif

        if kPanLaw = 6 then // - -6.0dB center law
            asigL *= pow(sin((1.0 - kBal) * $M_PI_2), 2)
            asigR *= pow(sin(kBal * $M_PI_2), 2)
        endif
    endif
    // Out
    out asigL, asigR
    
endin

</CsInstruments>  
<CsScore>
i 1 0 [60*60*12*7]
</CsScore>
</CsoundSynthesizer>