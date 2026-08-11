// Map Component - رسم خريطة SVG لمدينة عدن
// ═══════════════════════════════════════════════════════════════

const MapView = ({ theme, zoom = 1, showRoute = false, showPin = true, showDriver = false, driverPos = 0.3, pinLabel = null, style = {} }) => {
  return (
    <div style={{
      position: 'absolute', inset: 0, overflow: 'hidden',
      background: theme.mapBg, ...style,
    }}>
      {/* Map SVG - simulate Aden city map */}
      <svg
        width="100%" height="100%" viewBox="0 0 400 800"
        preserveAspectRatio="xMidYMid slice"
        style={{ transform: `scale(${zoom})`, transformOrigin: 'center', transition: 'transform 0.5s ease' }}
      >
        <defs>
          <pattern id="mapDots" x="0" y="0" width="40" height="40" patternUnits="userSpaceOnUse">
            <circle cx="20" cy="20" r="0.5" fill={theme.textLight} opacity="0.15"/>
          </pattern>
        </defs>

        {/* Water bodies - Aden bay */}
        <path d="M -50 500 Q 100 480 200 520 T 450 500 L 450 900 L -50 900 Z"
          fill={theme.mapWater} opacity="0.7"/>
        <path d="M 350 -50 Q 380 100 420 200 L 450 200 L 450 -50 Z"
          fill={theme.mapWater} opacity="0.5"/>

        {/* Land background pattern */}
        <rect x="0" y="0" width="400" height="800" fill="url(#mapDots)"/>

        {/* Districts (soft shapes) */}
        <path d="M 60 100 Q 150 90 220 130 L 240 220 Q 180 260 100 240 Z"
          fill={theme.text} opacity="0.03"/>
        <path d="M 250 200 Q 330 180 380 250 L 370 340 Q 300 350 250 320 Z"
          fill={theme.text} opacity="0.04"/>
        <path d="M 80 350 Q 180 340 240 380 L 240 450 Q 150 470 80 440 Z"
          fill={theme.text} opacity="0.05"/>

        {/* Main roads */}
        <g stroke={theme.mapRoad} strokeLinecap="round" fill="none">
          {/* Highway (thick) */}
          <path d="M 0 300 Q 100 290 200 310 T 400 320" strokeWidth="12"/>
          <path d="M 200 -20 Q 210 200 200 400 T 190 800" strokeWidth="10"/>
          {/* Secondary roads */}
          <path d="M 50 150 L 350 180" strokeWidth="6"/>
          <path d="M 60 450 Q 200 460 380 440" strokeWidth="6"/>
          <path d="M 100 550 L 350 570" strokeWidth="6"/>
          <path d="M 130 -20 L 150 500" strokeWidth="5"/>
          <path d="M 300 50 L 280 500" strokeWidth="5"/>
          {/* Small streets */}
          <path d="M 20 80 L 380 90" strokeWidth="3"/>
          <path d="M 30 220 L 380 230" strokeWidth="3"/>
          <path d="M 40 380 L 380 390" strokeWidth="3"/>
          <path d="M 50 620 L 380 630" strokeWidth="3"/>
          <path d="M 70 700 L 380 710" strokeWidth="3"/>
          <path d="M 60 -20 L 80 500" strokeWidth="3"/>
          <path d="M 240 -20 L 250 500" strokeWidth="3"/>
          <path d="M 340 -20 L 350 500" strokeWidth="3"/>
        </g>

        {/* Road labels */}
        <g fill={theme.textLight} fontFamily="system-ui" fontSize="9" opacity="0.5">
          <text x="20" y="295">شارع الملكة أروى</text>
          <text x="210" y="150" transform="rotate(90 210 150)">طريق المعلا</text>
          <text x="60" y="445">شارع الزعفران</text>
        </g>

        {/* Place labels */}
        <g fill={theme.textMuted} fontFamily="system-ui" fontSize="11" fontWeight="500" opacity="0.6">
          <text x="70" y="180">كريتر</text>
          <text x="270" y="270">المعلا</text>
          <text x="130" y="410">التواهي</text>
          <text x="290" y="500">الملاح</text>
          <text x="80" y="620">خور مكسر</text>
        </g>

        {/* Green/park areas */}
        <circle cx="180" cy="180" r="18" fill={theme.success} opacity="0.15"/>
        <circle cx="320" cy="420" r="22" fill={theme.success} opacity="0.15"/>

        {/* Route (if enabled) */}
        {showRoute && (
          <g>
            <path
              d="M 200 550 Q 210 450 180 350 T 150 200"
              stroke={theme.primary} strokeWidth="5" fill="none"
              strokeLinecap="round"
              strokeDasharray="0 0"
            />
            <path
              d="M 200 550 Q 210 450 180 350 T 150 200"
              stroke={theme.primary} strokeWidth="10" fill="none"
              strokeLinecap="round"
              opacity="0.2"
            />
          </g>
        )}

        {/* Driver marker (moves along route) */}
        {showDriver && (() => {
          // simple lerp on route
          const points = [[200,550],[205,450],[180,350],[165,275],[150,200]];
          const idx = driverPos * (points.length - 1);
          const i = Math.floor(idx);
          const t = idx - i;
          const p1 = points[i], p2 = points[Math.min(i+1, points.length-1)];
          const x = p1[0] + (p2[0]-p1[0]) * t;
          const y = p1[1] + (p2[1]-p1[1]) * t;
          return (
            <g transform={`translate(${x} ${y})`}>
              <circle r="18" fill={theme.primary} opacity="0.2">
                <animate attributeName="r" values="18;28;18" dur="2s" repeatCount="indefinite"/>
                <animate attributeName="opacity" values="0.3;0;0.3" dur="2s" repeatCount="indefinite"/>
              </circle>
              <circle r="10" fill={theme.primary} stroke="white" strokeWidth="2.5"/>
              <path d="M-4 -1 L4 -1 L3 3 L-3 3 Z" fill="white"/>
            </g>
          );
        })()}
      </svg>

      {/* Center Pin (user's picking location) */}
      {showPin && (
        <div style={{
          position: 'absolute', left: '50%', top: '50%',
          transform: 'translate(-50%, -100%)',
          display: 'flex', flexDirection: 'column', alignItems: 'center',
          pointerEvents: 'none', zIndex: 5,
        }}>
          {pinLabel && (
            <div style={{
              background: theme.text, color: theme.bg,
              padding: '6px 12px', borderRadius: 12,
              fontSize: 12, fontWeight: 600,
              marginBottom: 8, whiteSpace: 'nowrap',
              boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
            }}>{pinLabel}</div>
          )}
          <svg width="36" height="46" viewBox="0 0 36 46">
            <ellipse cx="18" cy="43" rx="6" ry="2" fill="rgba(0,0,0,0.2)"/>
            <path d="M18 2 C10 2 4 8 4 16 C4 26 18 40 18 40 S32 26 32 16 C32 8 26 2 18 2 Z"
              fill={theme.primary} stroke="white" strokeWidth="2.5"/>
            <circle cx="18" cy="16" r="5" fill="white"/>
          </svg>
        </div>
      )}

      {/* Current location dot (blue dot) */}
      <div style={{
        position: 'absolute', left: '32%', top: '68%',
        transform: 'translate(-50%, -50%)',
        width: 18, height: 18, borderRadius: '50%',
        background: '#4285F4',
        border: '3px solid white',
        boxShadow: '0 0 0 8px rgba(66,133,244,0.2), 0 2px 8px rgba(0,0,0,0.2)',
        zIndex: 3,
      }} />

      {/* Map controls overlay slot */}
    </div>
  );
};

// Small map preview (for cards / trip history)
const MiniMap = ({ theme, style = {} }) => (
  <div style={{
    background: theme.mapBg, overflow: 'hidden',
    position: 'relative', ...style,
  }}>
    <svg width="100%" height="100%" viewBox="0 0 200 120" preserveAspectRatio="xMidYMid slice">
      <path d="M 0 60 Q 50 55 100 65 T 200 60" stroke={theme.mapRoad} strokeWidth="8" fill="none"/>
      <path d="M 60 -10 L 70 130" stroke={theme.mapRoad} strokeWidth="6" fill="none"/>
      <path d="M 140 -10 L 130 130" stroke={theme.mapRoad} strokeWidth="6" fill="none"/>
      <path d="M 20 20 L 180 40 M 20 90 L 180 80" stroke={theme.mapRoad} strokeWidth="3" fill="none"/>
      <path d="M 40 90 Q 90 60 160 30" stroke={theme.primary} strokeWidth="3" fill="none" strokeLinecap="round"/>
      <circle cx="40" cy="90" r="4" fill={theme.primary}/>
      <circle cx="160" cy="30" r="4" fill={theme.danger}/>
    </svg>
  </div>
);

Object.assign(window, { MapView, MiniMap });
