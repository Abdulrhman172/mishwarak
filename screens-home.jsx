// Screens: Home (Map), Search, Vehicle Selection
// ═══════════════════════════════════════════════════════════════

// ─────────────── HOME ───────────────
const HomeScreen = ({ theme, version, onNav, onMenu, lang, userName = 'أحمد' }) => {
  const isB = version === 'B';
  const [showSheet, setShowSheet] = React.useState(true);
  const glassStyle = isB ? {
    background: theme.surfaceElev + 'CC',
    backdropFilter: 'blur(20px) saturate(180%)',
    WebkitBackdropFilter: 'blur(20px) saturate(180%)',
    border: `1px solid ${theme.border}80`,
  } : {
    background: theme.surfaceElev,
    boxShadow: '0 4px 12px rgba(0,0,0,0.12)',
  };

  return (
    <div style={{ position: 'absolute', inset: 0 }}>
      <MapView theme={theme} showPin={true} />

      {/* Top bar */}
      <div style={{
        position: 'absolute', top: 12, insetInline: 12,
        display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        zIndex: 10,
      }}>
        <button onClick={onMenu} style={{
          width: 44, height: 44, borderRadius: isB ? 14 : '50%',
          border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer', ...glassStyle,
        }}>
          <Icon name="menu" color={theme.text} size={22} strokeWidth={isB ? 2.2 : 1.8}/>
        </button>

        <div style={{ display: 'flex', gap: 8 }}>
          <button style={{
            display: 'flex', alignItems: 'center', gap: 8,
            padding: '10px 14px', borderRadius: isB ? 14 : 22,
            border: 'none', cursor: 'pointer',
            fontFamily: TYPO.arabic, fontSize: 13, fontWeight: 700,
            color: theme.text, ...glassStyle,
          }}>
            <Icon name="wallet" color={theme.primary} size={18}/>
            <span>15,300 <span style={{ fontSize: 11, color: theme.textMuted }}>ر.ي</span></span>
          </button>
        </div>
      </div>

      {/* Floating action buttons */}
      <div style={{
        position: 'absolute', insetInlineEnd: 12, bottom: 340,
        display: 'flex', flexDirection: 'column', gap: 8, zIndex: 5,
      }}>
        <button style={{
          width: 44, height: 44, borderRadius: '50%',
          background: theme.surfaceElev, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(0,0,0,0.15)', cursor: 'pointer',
        }}>
          <Icon name="target" color={theme.primary} size={22}/>
        </button>
        <button style={{
          width: 44, height: 44, borderRadius: '50%',
          background: theme.surfaceElev, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(0,0,0,0.15)', cursor: 'pointer',
          position: 'relative',
        }}>
          <Icon name="sos" color={theme.danger} size={22}/>
        </button>
      </div>

      {/* Bottom Sheet */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: theme.surfaceElev,
        borderTopLeftRadius: isB ? 20 : 28,
        borderTopRightRadius: isB ? 20 : 28,
        padding: '10px 20px 24px',
        boxShadow: '0 -8px 32px rgba(0,0,0,0.12)',
        zIndex: 10,
      }}>
        {/* Handle */}
        <div style={{
          width: 40, height: 4, borderRadius: 2,
          background: theme.border, margin: '0 auto 16px',
        }}/>

        {/* Greeting */}
        <div style={{ marginBottom: 14 }}>
          <div style={{
            fontSize: 22, fontWeight: 800, color: theme.text,
            fontFamily: TYPO.arabic, letterSpacing: -0.5,
          }}>
            {T(`مرحباً، ${userName} 👋`, `Hi, ${userName} 👋`, lang)}
          </div>
          <div style={{ fontSize: 13, color: theme.textMuted, fontFamily: TYPO.arabic, marginTop: 2 }}>
            {T('إلى أين تريد أن تذهب اليوم؟', 'Where to today?', lang)}
          </div>
        </div>

        {/* Search box */}
        <button
          onClick={() => onNav('search')}
          style={{
            width: '100%', display: 'flex', alignItems: 'center', gap: 12,
            padding: '16px 16px', background: theme.surface,
            border: `1.5px solid ${theme.border}`, borderRadius: 14,
            cursor: 'pointer', textAlign: 'start',
            fontFamily: TYPO.arabic,
          }}
        >
          <div style={{
            width: 32, height: 32, borderRadius: 10,
            background: theme.primary + '20',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon name="search" color={theme.primary} size={18}/>
          </div>
          <span style={{ flex: 1, fontSize: 15, color: theme.textMuted, fontWeight: 500 }}>
            {T('ابحث عن وجهتك...', 'Search destination...', lang)}
          </span>
          <div style={{
            padding: '6px 10px', background: theme.primary,
            borderRadius: 8, fontSize: 11, fontWeight: 700, color: 'white',
          }}>
            {T('احجز الآن', 'Book', lang)}
          </div>
        </button>

        {/* Saved places */}
        <div style={{ display: 'flex', gap: 10, marginTop: 14 }}>
          {[
            { icon: 'home', label: T('المنزل', 'Home', lang), sub: T('كريتر', 'Crater', lang) },
            { icon: 'work', label: T('العمل', 'Work', lang), sub: T('المعلا', 'Maalla', lang) },
            { icon: 'plus', label: T('إضافة', 'Add', lang), sub: T('مكان جديد', 'new place', lang), add: true },
          ].map((p, i) => (
            <div key={i} style={{
              flex: 1, padding: '12px 10px',
              background: theme.surface, borderRadius: 12,
              border: `1px solid ${theme.border}`,
              cursor: 'pointer',
            }}>
              <div style={{
                width: 30, height: 30, borderRadius: 9,
                background: p.add ? theme.border : theme.primary + '15',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                marginBottom: 8,
              }}>
                <Icon name={p.icon} color={p.add ? theme.textMuted : theme.primary} size={16}/>
              </div>
              <div style={{ fontSize: 12, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic }}>
                {p.label}
              </div>
              <div style={{ fontSize: 10, color: theme.textLight, marginTop: 1, fontFamily: TYPO.arabic }}>
                {p.sub}
              </div>
            </div>
          ))}
        </div>

        {/* Quick services */}
        <div style={{
          marginTop: 14, display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 10,
        }}>
          {[
            { icon: 'car', label: T('اقتصادي', 'Economy', lang), color: theme.secondary },
            { icon: 'crown', label: T('VIP', 'VIP', lang), color: theme.accent },
            { icon: 'female', label: T('نساء', 'Women', lang), color: '#EC4899' },
            { icon: 'calendar', label: T('حجز مسبق', 'Schedule', lang), color: theme.success },
          ].map((s, i) => (
            <div key={i} style={{
              textAlign: 'center', padding: '8px 4px', cursor: 'pointer',
            }}>
              <div style={{
                width: 44, height: 44, borderRadius: 14,
                background: s.color + '18',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                margin: '0 auto 6px',
              }}>
                <Icon name={s.icon} color={s.color} size={22}/>
              </div>
              <div style={{ fontSize: 11, fontWeight: 600, color: theme.text, fontFamily: TYPO.arabic }}>
                {s.label}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

// ─────────────── SEARCH ───────────────
const SearchScreen = ({ theme, version, onBack, onNav, lang }) => {
  const [q, setQ] = React.useState('');
  const isB = version === 'B';
  const recent = [
    { icon: 'clock', name: T('جامعة عدن', 'Aden University', lang), addr: T('خور مكسر', 'Khormaksar', lang) },
    { icon: 'clock', name: T('مستشفى الجمهورية', 'Republic Hospital', lang), addr: T('كريتر', 'Crater', lang) },
    { icon: 'clock', name: T('سوق التواهي', 'Tawahi Market', lang), addr: T('التواهي', 'Tawahi', lang) },
  ];
  const saved = [
    { icon: 'home', name: T('المنزل', 'Home', lang), addr: T('حي الشيخ عثمان، عدن', 'Sheikh Othman, Aden', lang), primary: true },
    { icon: 'work', name: T('العمل', 'Work', lang), addr: T('شارع كالتكس، المعلا', 'Caltex St, Maalla', lang), primary: true },
  ];

  return (
    <div style={{ position: 'absolute', inset: 0, background: theme.bg, display: 'flex', flexDirection: 'column' }}>
      {/* Header */}
      <div style={{
        padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 12,
        borderBottom: `1px solid ${theme.border}`,
      }}>
        <button onClick={onBack} style={{
          width: 40, height: 40, borderRadius: '50%',
          background: theme.surface, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer',
        }}>
          <Icon name="close" color={theme.text} size={20}/>
        </button>
        <div style={{ fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
          {T('اختر وجهتك', 'Choose destination', lang)}
        </div>
      </div>

      {/* Pick-up / Drop-off inputs */}
      <div style={{ padding: '16px', display: 'flex', gap: 12 }}>
        {/* Timeline dots */}
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', paddingTop: 14 }}>
          <div style={{ width: 10, height: 10, borderRadius: '50%', background: theme.success, boxShadow: `0 0 0 3px ${theme.success}30` }}/>
          <div style={{ width: 2, height: 30, background: theme.border, margin: '4px 0' }}/>
          <div style={{ width: 10, height: 10, borderRadius: 2, background: theme.danger }}/>
        </div>
        {/* Inputs */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 8 }}>
          <div style={{
            padding: '10px 14px', background: theme.surface, borderRadius: 12,
            border: `1px solid ${theme.border}`,
          }}>
            <div style={{ fontSize: 10, color: theme.textMuted, fontFamily: TYPO.arabic, fontWeight: 600 }}>
              {T('نقطة الانطلاق', 'Pickup', lang)}
            </div>
            <div style={{ fontSize: 14, fontWeight: 600, color: theme.text, fontFamily: TYPO.arabic, marginTop: 2 }}>
              {T('موقعي الحالي', 'My current location', lang)}
            </div>
          </div>
          <div style={{
            padding: '10px 14px', background: theme.surface, borderRadius: 12,
            border: `2px solid ${theme.primary}`,
          }}>
            <div style={{ fontSize: 10, color: theme.primary, fontFamily: TYPO.arabic, fontWeight: 700 }}>
              {T('الوجهة', 'Destination', lang)}
            </div>
            <input
              autoFocus
              value={q}
              onChange={e => setQ(e.target.value)}
              placeholder={T('إلى أين؟', 'Where to?', lang)}
              style={{
                width: '100%', border: 'none', background: 'transparent',
                fontSize: 15, fontWeight: 600, color: theme.text,
                outline: 'none', fontFamily: TYPO.arabic, marginTop: 2,
              }}
            />
          </div>
        </div>
      </div>

      {/* Options */}
      <div style={{ padding: '0 16px', display: 'flex', gap: 10 }}>
        <button style={{
          flex: 1, display: 'flex', alignItems: 'center', gap: 8,
          padding: '10px', background: theme.surface,
          border: `1px solid ${theme.border}`, borderRadius: 12,
          cursor: 'pointer',
        }}>
          <Icon name="mapPin" color={theme.primary} size={18}/>
          <span style={{ fontSize: 13, fontWeight: 600, color: theme.text, fontFamily: TYPO.arabic }}>
            {T('حدد من الخريطة', 'Set on map', lang)}
          </span>
        </button>
        <button style={{
          flex: 1, display: 'flex', alignItems: 'center', gap: 8,
          padding: '10px', background: theme.surface,
          border: `1px solid ${theme.border}`, borderRadius: 12,
          cursor: 'pointer',
        }}>
          <Icon name="user" color={theme.primary} size={18}/>
          <span style={{ fontSize: 13, fontWeight: 600, color: theme.text, fontFamily: TYPO.arabic }}>
            {T('لشخص آخر', 'For someone', lang)}
          </span>
        </button>
      </div>

      {/* Results */}
      <div style={{ flex: 1, overflow: 'auto', padding: '16px' }}>
        <div style={{ fontSize: 11, fontWeight: 700, color: theme.textMuted, marginBottom: 10, fontFamily: TYPO.arabic, letterSpacing: 0.5 }}>
          {T('المحفوظة', 'SAVED', lang)}
        </div>
        {saved.map((r, i) => (
          <SearchResult key={i} theme={theme} item={r} onClick={() => onNav('vehicle')} lang={lang}/>
        ))}
        <div style={{ fontSize: 11, fontWeight: 700, color: theme.textMuted, margin: '20px 0 10px', fontFamily: TYPO.arabic, letterSpacing: 0.5 }}>
          {T('الأخيرة', 'RECENT', lang)}
        </div>
        {recent.map((r, i) => (
          <SearchResult key={i} theme={theme} item={r} onClick={() => onNav('vehicle')} lang={lang}/>
        ))}
      </div>
    </div>
  );
};

const SearchResult = ({ theme, item, onClick, lang }) => (
  <button onClick={onClick} style={{
    width: '100%', display: 'flex', alignItems: 'center', gap: 14,
    padding: '12px 4px', background: 'transparent', border: 'none',
    cursor: 'pointer', textAlign: 'start',
  }}>
    <div style={{
      width: 40, height: 40, borderRadius: 12,
      background: item.primary ? theme.primary + '18' : theme.surface,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>
      <Icon name={item.icon} color={item.primary ? theme.primary : theme.textMuted} size={20}/>
    </div>
    <div style={{ flex: 1, minWidth: 0 }}>
      <div style={{ fontSize: 15, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic }}>
        {item.name}
      </div>
      <div style={{ fontSize: 12, color: theme.textMuted, marginTop: 2, fontFamily: TYPO.arabic }}>
        {item.addr}
      </div>
    </div>
    <Icon name={lang === 'ar' ? 'back' : 'forward'} color={theme.textLight} size={18}/>
  </button>
);

// ─────────────── VEHICLE SELECTION ───────────────
const VehicleScreen = ({ theme, version, onBack, onNav, lang }) => {
  const [selected, setSelected] = React.useState(1);
  const [paymentMethod, setPaymentMethod] = React.useState('wallet');
  const isB = version === 'B';

  const vehicles = [
    { type: 'economy', name: T('اقتصادي', 'Economy', lang), desc: T('4 ركاب', '4 seats', lang), eta: '3', price: '2,500', old: '3,200' },
    { type: 'comfort', name: T('مريح', 'Comfort', lang), desc: T('سيارة أحدث', 'Newer car', lang), eta: '5', price: '3,800' },
    { type: 'xl', name: T('عائلي XL', 'XL', lang), desc: T('6 ركاب', '6 seats', lang), eta: '7', price: '5,200' },
    { type: 'women', name: T('سائقة للنساء', 'Women only', lang), desc: T('سائقة خبيرة', 'Female driver', lang), eta: '9', price: '3,200', badge: T('حصري', 'Exclusive', lang) },
  ];

  return (
    <div style={{ position: 'absolute', inset: 0 }}>
      <MapView theme={theme} showRoute={true} showPin={false} />

      {/* Top bar */}
      <div style={{
        position: 'absolute', top: 12, insetInline: 12,
        display: 'flex', gap: 8, zIndex: 10,
      }}>
        <button onClick={onBack} style={{
          width: 44, height: 44, borderRadius: '50%',
          background: theme.surfaceElev, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(0,0,0,0.12)', cursor: 'pointer',
        }}>
          <Icon name="back" color={theme.text} size={22}/>
        </button>
        <div style={{
          flex: 1, background: theme.surfaceElev, borderRadius: 22,
          padding: '10px 16px', boxShadow: '0 4px 12px rgba(0,0,0,0.12)',
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 3, alignItems: 'center' }}>
            <div style={{ width: 7, height: 7, borderRadius: '50%', background: theme.success }}/>
            <div style={{ width: 1.5, height: 10, background: theme.border }}/>
            <div style={{ width: 7, height: 7, borderRadius: 1.5, background: theme.danger }}/>
          </div>
          <div style={{ flex: 1, fontSize: 12, fontFamily: TYPO.arabic, color: theme.text, lineHeight: 1.3 }}>
            <div style={{ fontWeight: 600 }}>{T('موقعي', 'My location', lang)}</div>
            <div style={{ fontWeight: 700, marginTop: 2 }}>{T('جامعة عدن', 'Aden University', lang)}</div>
          </div>
        </div>
      </div>

      {/* Bottom Sheet */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: theme.surfaceElev,
        borderTopLeftRadius: isB ? 20 : 28,
        borderTopRightRadius: isB ? 20 : 28,
        padding: '10px 0 24px',
        boxShadow: '0 -8px 32px rgba(0,0,0,0.12)',
        maxHeight: '68%', display: 'flex', flexDirection: 'column',
      }}>
        <div style={{
          width: 40, height: 4, borderRadius: 2,
          background: theme.border, margin: '0 auto 12px',
        }}/>

        <div style={{ padding: '0 20px 12px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
              {T('اختر مركبتك', 'Choose your ride', lang)}
            </div>
            <div style={{ fontSize: 11, color: theme.textMuted, fontFamily: TYPO.arabic, marginTop: 2 }}>
              {T('4 خيارات متاحة', '4 options available', lang)}
            </div>
          </div>
          <button style={{
            display: 'flex', alignItems: 'center', gap: 6,
            padding: '8px 12px', background: theme.surface,
            border: `1px solid ${theme.border}`, borderRadius: 20,
            cursor: 'pointer', fontFamily: TYPO.arabic, fontSize: 12, fontWeight: 700,
            color: theme.text,
          }}>
            <Icon name="calendar" size={14} color={theme.primary}/>
            {T('حجز مسبق', 'Schedule', lang)}
          </button>
        </div>

        {/* Vehicles list */}
        <div style={{ overflow: 'auto', padding: '0 12px', flex: 1 }}>
          {vehicles.map((v, i) => (
            <div
              key={i}
              onClick={() => setSelected(i)}
              style={{
                display: 'flex', alignItems: 'center', gap: 12,
                padding: '12px', margin: '4px 0',
                background: selected === i ? theme.primary + '10' : 'transparent',
                border: `2px solid ${selected === i ? theme.primary : 'transparent'}`,
                borderRadius: 14, cursor: 'pointer',
                transition: 'all 0.2s',
              }}
            >
              <div style={{
                width: 72, height: 52, borderRadius: 10,
                background: theme.surface,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                flexShrink: 0,
              }}>
                <CarIllustration type={v.type} width={68}/>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span style={{ fontSize: 15, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
                    {v.name}
                  </span>
                  {v.badge && (
                    <span style={{
                      padding: '2px 6px', background: '#EC4899',
                      color: 'white', borderRadius: 4, fontSize: 9, fontWeight: 700,
                      fontFamily: TYPO.arabic,
                    }}>{v.badge}</span>
                  )}
                </div>
                <div style={{ fontSize: 11, color: theme.textMuted, marginTop: 2, fontFamily: TYPO.arabic, display: 'flex', alignItems: 'center', gap: 6 }}>
                  <span>🕐 {v.eta} {T('دقائق', 'min', lang)}</span>
                  <span>·</span>
                  <span>{v.desc}</span>
                </div>
              </div>
              <div style={{ textAlign: 'end' }}>
                <div style={{ fontSize: 15, fontWeight: 800, color: theme.text, fontFamily: TYPO.english }}>
                  {v.price}
                </div>
                {v.old && (
                  <div style={{ fontSize: 10, color: theme.textLight, textDecoration: 'line-through', fontFamily: TYPO.english }}>
                    {v.old}
                  </div>
                )}
                <div style={{ fontSize: 9, color: theme.textMuted, fontFamily: TYPO.arabic }}>
                  {T('ر.ي', 'YER', lang)}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Payment + CTA */}
        <div style={{ padding: '12px 20px 0', borderTop: `1px solid ${theme.border}` }}>
          <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
            <button
              onClick={() => setPaymentMethod('wallet')}
              style={{
                flex: 1, display: 'flex', alignItems: 'center', gap: 8,
                padding: '10px', background: paymentMethod === 'wallet' ? theme.primary + '15' : theme.surface,
                border: `1.5px solid ${paymentMethod === 'wallet' ? theme.primary : theme.border}`,
                borderRadius: 12, cursor: 'pointer',
                fontFamily: TYPO.arabic,
              }}
            >
              <Icon name="wallet" color={theme.primary} size={16}/>
              <span style={{ fontSize: 12, fontWeight: 700, color: theme.text }}>
                {T('محفظة', 'Wallet', lang)}
              </span>
            </button>
            <button
              onClick={() => setPaymentMethod('cash')}
              style={{
                flex: 1, display: 'flex', alignItems: 'center', gap: 8,
                padding: '10px', background: paymentMethod === 'cash' ? theme.primary + '15' : theme.surface,
                border: `1.5px solid ${paymentMethod === 'cash' ? theme.primary : theme.border}`,
                borderRadius: 12, cursor: 'pointer',
                fontFamily: TYPO.arabic,
              }}
            >
              <Icon name="cash" color={theme.success} size={16}/>
              <span style={{ fontSize: 12, fontWeight: 700, color: theme.text }}>
                {T('نقدي', 'Cash', lang)}
              </span>
            </button>
            <button
              onClick={() => onNav('promo')}
              style={{
                display: 'flex', alignItems: 'center', gap: 6,
                padding: '10px 14px', background: theme.accent + '15',
                border: `1.5px solid ${theme.accent}40`,
                borderRadius: 12, cursor: 'pointer',
                fontFamily: TYPO.arabic,
              }}
            >
              <Icon name="tag" color={theme.accent} size={16}/>
              <span style={{ fontSize: 12, fontWeight: 700, color: theme.text }}>
                {T('كوبون', 'Promo', lang)}
              </span>
            </button>
          </div>

          <button
            onClick={() => onNav('finding')}
            style={{
              width: '100%', marginTop: 12, height: 54,
              background: theme.primary, color: 'white',
              border: 'none', borderRadius: isB ? 12 : 27,
              fontSize: 16, fontWeight: 800,
              cursor: 'pointer', fontFamily: TYPO.arabic,
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
              boxShadow: `0 8px 20px ${theme.primary}40`,
            }}
          >
            <span>{T('اطلب', 'Confirm', lang)} {vehicles[selected].name}</span>
            <span style={{ opacity: 0.7 }}>· {vehicles[selected].price} {T('ر.ي', 'YER', lang)}</span>
          </button>
        </div>
      </div>
    </div>
  );
};

Object.assign(window, { HomeScreen, SearchScreen, VehicleScreen });
