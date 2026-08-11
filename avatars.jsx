// Avatars & Car illustrations
// ═══════════════════════════════════════════════════════════════

// Simple driver avatar - abstract silhouette
const DriverAvatar = ({ size = 56, seed = 1, ring = null, style = {} }) => {
  const palettes = [
    ['#FFD93D', '#FF6B35'],
    ['#4ECDC4', '#556270'],
    ['#F38181', '#FCE38A'],
    ['#95E1D3', '#3D5A80'],
    ['#F6D186', '#EE6C4D'],
  ];
  const [bg1, bg2] = palettes[seed % palettes.length];
  const skin = ['#F4C293', '#D4A373', '#C68B59', '#8D5524'][seed % 4];
  return (
    <div style={{
      width: size, height: size, borderRadius: '50%',
      background: `linear-gradient(135deg, ${bg1}, ${bg2})`,
      overflow: 'hidden', position: 'relative',
      border: ring ? `3px solid ${ring}` : 'none',
      flexShrink: 0, ...style,
    }}>
      <svg viewBox="0 0 60 60" width="100%" height="100%">
        {/* body */}
        <path d="M 5 60 Q 30 40 55 60 Z" fill={skin} opacity="0.9"/>
        {/* head */}
        <circle cx="30" cy="26" r="12" fill={skin}/>
        {/* hair (simplified) */}
        <path d="M 18 22 Q 30 12 42 22 L 42 26 Q 30 20 18 26 Z" fill="#2A1810"/>
      </svg>
    </div>
  );
};

// Car type illustrations
const CarIllustration = ({ type = 'economy', width = 100, color, style = {} }) => {
  const colors = {
    economy: '#4A90E2',
    comfort: '#00A651',
    xl: '#8B5CF6',
    women: '#EC4899',
    vip: '#1A1F36',
  }[type] || color || '#4A90E2';

  const h = width * 0.65;
  return (
    <svg width={width} height={h} viewBox="0 0 160 100" style={style}>
      {/* Shadow */}
      <ellipse cx="80" cy="90" rx="60" ry="4" fill="rgba(0,0,0,0.15)"/>
      {/* Car body */}
      <path
        d="M 15 70 L 15 55 Q 15 45 25 42 L 45 30 Q 55 25 70 24 L 100 24 Q 115 25 125 32 L 140 42 Q 150 45 150 55 L 150 70 Z"
        fill={colors}
      />
      {/* Roof highlight */}
      <path
        d="M 45 30 Q 55 25 70 24 L 100 24 Q 115 25 125 32 L 122 35 Q 110 30 100 30 L 70 30 Q 60 30 50 34 Z"
        fill="rgba(255,255,255,0.15)"
      />
      {/* Windows */}
      <path
        d="M 50 35 Q 58 30 68 30 L 82 30 L 82 42 L 50 42 Z"
        fill="#2A2F3A" opacity="0.7"
      />
      <path
        d="M 86 30 L 98 30 Q 108 30 115 36 L 120 42 L 86 42 Z"
        fill="#2A2F3A" opacity="0.7"
      />
      {/* Door line */}
      <line x1="83" y1="30" x2="83" y2="70" stroke="rgba(0,0,0,0.2)" strokeWidth="1.5"/>
      {/* Wheels */}
      <circle cx="40" cy="72" r="12" fill="#1A1D26"/>
      <circle cx="40" cy="72" r="6" fill="#4A4F5A"/>
      <circle cx="40" cy="72" r="2" fill="#8A8F9A"/>
      <circle cx="125" cy="72" r="12" fill="#1A1D26"/>
      <circle cx="125" cy="72" r="6" fill="#4A4F5A"/>
      <circle cx="125" cy="72" r="2" fill="#8A8F9A"/>
      {/* Headlight */}
      <ellipse cx="147" cy="52" rx="3" ry="4" fill="#FFF3A0"/>
      {/* Taillight */}
      <rect x="15" y="50" width="3" height="8" rx="1" fill="#FF6B6B"/>

      {type === 'women' && (
        <circle cx="80" cy="12" r="8" fill="#EC4899">
          <text x="80" y="16" fontSize="10" fontFamily="sans-serif" fill="white" textAnchor="middle" fontWeight="bold">♀</text>
        </circle>
      )}
      {type === 'vip' && (
        <path d="M 74 10 L 80 4 L 86 10 L 84 16 L 76 16 Z" fill="#FFD700"/>
      )}
    </svg>
  );
};

// Rating stars
const StarRating = ({ value = 5, max = 5, size = 14, color = '#FFB800', showValue = false }) => (
  <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
    <div style={{ display: 'flex', gap: 2 }}>
      {Array.from({ length: max }).map((_, i) => {
        const filled = i < Math.floor(value);
        const half = i === Math.floor(value) && value % 1 >= 0.5;
        return (
          <svg key={i} width={size} height={size} viewBox="0 0 24 24">
            <polygon
              points="12 2 15 9 22 10 17 15 18 22 12 18.5 6 22 7 15 2 10 9 9"
              fill={filled ? color : 'none'}
              stroke={color} strokeWidth="1.5"
              strokeLinejoin="round"
            />
            {half && (
              <polygon
                points="12 2 15 9 22 10 17 15 18 22 12 18.5"
                fill={color}
              />
            )}
          </svg>
        );
      })}
    </div>
    {showValue && (
      <span style={{ fontSize: size - 1, fontWeight: 600, marginInlineStart: 4 }}>
        {value.toFixed(2)}
      </span>
    )}
  </div>
);

Object.assign(window, { DriverAvatar, CarIllustration, StarRating });
