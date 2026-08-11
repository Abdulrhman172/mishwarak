// Screens: Finding Driver, Active Ride, Trip End & Rating
// ═══════════════════════════════════════════════════════════════

// ─────────────── FINDING DRIVER ───────────────
const FindingScreen = ({ theme, version, onCancel, onFound, lang }) => {
  React.useEffect(() => {
    const t = setTimeout(onFound, 3500);
    return () => clearTimeout(t);
  }, []);

  return (
    <div style={{ position: 'absolute', inset: 0 }}>
      <MapView theme={theme} showPin={false} />

      {/* Overlay to dim map slightly */}
      <div style={{ position: 'absolute', inset: 0, background: theme.bg + '30' }}/>

      {/* Radar animation on center */}
      <div style={{
        position: 'absolute', left: '50%', top: '38%',
        transform: 'translate(-50%, -50%)', pointerEvents: 'none',
      }}>
        {[0, 1, 2].map(i => (
          <div key={i} style={{
            position: 'absolute', left: '50%', top: '50%',
            width: 80, height: 80, borderRadius: '50%',
            border: `2px solid ${theme.primary}`,
            transform: 'translate(-50%, -50%)',
            animation: `radar 2.5s ${i * 0.8}s ease-out infinite`,
          }}/>
        ))}
        <div style={{
          width: 80, height: 80, borderRadius: '50%',
          background: theme.primary,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: `0 8px 32px ${theme.primary}60`,
        }}>
          <Icon name="car" color="white" size={40}/>
        </div>
      </div>

      {/* Bottom sheet */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: theme.surfaceElev,
        borderTopLeftRadius: 24, borderTopRightRadius: 24,
        padding: '24px 24px 28px',
        boxShadow: '0 -8px 32px rgba(0,0,0,0.12)',
      }}>
        <div style={{
          fontSize: 22, fontWeight: 800, color: theme.text,
          fontFamily: TYPO.arabic, textAlign: 'center',
        }}>
          {T('نبحث لك عن أفضل سائق...', 'Finding your best driver...', lang)}
        </div>
        <div style={{
          fontSize: 13, color: theme.textMuted, marginTop: 6,
          fontFamily: TYPO.arabic, textAlign: 'center',
        }}>
          {T('لحظات وسنجد لك أقرب سائق متاح', 'Matching you with a nearby driver', lang)}
        </div>

        {/* Dots */}
        <div style={{ display: 'flex', justifyContent: 'center', gap: 8, marginTop: 18 }}>
          {[0,1,2].map(i => (
            <div key={i} style={{
              width: 10, height: 10, borderRadius: '50%',
              background: theme.primary,
              animation: `pulseFind 1.4s ${i * 0.2}s ease-in-out infinite`,
            }}/>
          ))}
        </div>

        <button
          onClick={onCancel}
          style={{
            width: '100%', marginTop: 22, height: 48,
            background: 'transparent', color: theme.danger,
            border: `1.5px solid ${theme.danger}40`, borderRadius: 24,
            fontSize: 15, fontWeight: 700, cursor: 'pointer',
            fontFamily: TYPO.arabic,
          }}
        >
          {T('إلغاء الطلب', 'Cancel request', lang)}
        </button>
      </div>

      <style>{`
        @keyframes radar { 0%{width:80px;height:80px;opacity:0.8} 100%{width:300px;height:300px;opacity:0} }
        @keyframes pulseFind { 0%,100%{opacity:0.3;transform:scale(0.7)} 50%{opacity:1;transform:scale(1.1)} }
      `}</style>
    </div>
  );
};

// ─────────────── ACTIVE RIDE ───────────────
const ActiveRideScreen = ({ theme, version, onEnd, lang }) => {
  const [phase, setPhase] = React.useState('arriving'); // arriving | onTrip
  const [driverPos, setDriverPos] = React.useState(0.05);
  const isB = version === 'B';

  React.useEffect(() => {
    const interval = setInterval(() => {
      setDriverPos(p => {
        const next = p + 0.015;
        if (next >= 0.35 && phase === 'arriving') setPhase('onTrip');
        if (next >= 0.98) { clearInterval(interval); onEnd(); return 1; }
        return next;
      });
    }, 200);
    return () => clearInterval(interval);
  }, [phase]);

  const driver = {
    name: T('محمد صالح', 'Mohammed Saleh', lang),
    rating: 4.92,
    trips: 1247,
    car: T('تويوتا هايلوكس', 'Toyota Hilux', lang),
    color: T('أبيض', 'White', lang),
    plate: 'ADN 4287',
  };

  return (
    <div style={{ position: 'absolute', inset: 0 }}>
      <MapView theme={theme} showRoute={true} showPin={false} showDriver={true} driverPos={driverPos} />

      {/* Top: phase pill */}
      <div style={{
        position: 'absolute', top: 20, left: '50%', transform: 'translateX(-50%)',
        background: theme.surfaceElev, padding: '10px 16px',
        borderRadius: 22, display: 'flex', alignItems: 'center', gap: 8,
        boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
      }}>
        <div style={{
          width: 8, height: 8, borderRadius: '50%',
          background: theme.success,
          animation: 'blink 1.5s infinite',
        }}/>
        <span style={{ fontSize: 13, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic }}>
          {phase === 'arriving'
            ? T(`السائق يصل خلال ${Math.max(1, Math.round((0.35 - driverPos) * 30))} دقائق`, `Driver arriving in ${Math.max(1, Math.round((0.35 - driverPos) * 30))} min`, lang)
            : T(`في الطريق · ${Math.round((1 - driverPos) * 15)} دقيقة`, `On trip · ${Math.round((1 - driverPos) * 15)} min`, lang)
          }
        </span>
      </div>

      {/* Right actions */}
      <div style={{
        position: 'absolute', insetInlineEnd: 12, top: 80,
        display: 'flex', flexDirection: 'column', gap: 8,
      }}>
        <button style={{
          width: 44, height: 44, borderRadius: '50%',
          background: theme.surfaceElev, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(0,0,0,0.15)', cursor: 'pointer',
          position: 'relative',
        }}>
          <Icon name="share" color={theme.primary} size={20}/>
        </button>
        <button style={{
          width: 44, height: 44, borderRadius: '50%',
          background: theme.danger, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(0,0,0,0.25)', cursor: 'pointer',
        }}>
          <Icon name="shield" color="white" size={22}/>
        </button>
      </div>

      {/* Bottom sheet */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: theme.surfaceElev,
        borderTopLeftRadius: 24, borderTopRightRadius: 24,
        padding: '10px 0 20px',
        boxShadow: '0 -8px 32px rgba(0,0,0,0.12)',
      }}>
        <div style={{
          width: 40, height: 4, borderRadius: 2,
          background: theme.border, margin: '0 auto 14px',
        }}/>

        {/* Driver card */}
        <div style={{ padding: '0 20px', display: 'flex', alignItems: 'center', gap: 14 }}>
          <div style={{ position: 'relative' }}>
            <DriverAvatar size={60} seed={2} ring={theme.primary}/>
            <div style={{
              position: 'absolute', bottom: -2, insetInlineEnd: -2,
              width: 22, height: 22, borderRadius: '50%',
              background: theme.success, border: `2px solid ${theme.surfaceElev}`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name="check" color="white" size={12} strokeWidth={3}/>
            </div>
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 16, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
              {driver.name}
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 3 }}>
              <StarRating value={driver.rating} size={12}/>
              <span style={{ fontSize: 12, fontWeight: 700, color: theme.text, fontFamily: TYPO.english }}>
                {driver.rating}
              </span>
              <span style={{ fontSize: 11, color: theme.textMuted, fontFamily: TYPO.arabic }}>
                · {driver.trips} {T('رحلة', 'trips', lang)}
              </span>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <button style={{
              width: 44, height: 44, borderRadius: '50%',
              background: theme.primary + '15', border: `1.5px solid ${theme.primary}30`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer',
            }}>
              <Icon name="message" color={theme.primary} size={20}/>
            </button>
            <button style={{
              width: 44, height: 44, borderRadius: '50%',
              background: theme.primary, border: 'none',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer',
            }}>
              <Icon name="phone" color="white" size={20}/>
            </button>
          </div>
        </div>

        {/* Car details */}
        <div style={{
          margin: '14px 20px 0', padding: '12px 14px',
          background: theme.surface, borderRadius: 14,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <CarIllustration type="economy" width={60}/>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic }}>
              {driver.car}
            </div>
            <div style={{ fontSize: 11, color: theme.textMuted, marginTop: 2, fontFamily: TYPO.arabic }}>
              {driver.color}
            </div>
          </div>
          <div style={{
            padding: '6px 12px', background: theme.text, color: theme.bg,
            borderRadius: 6, fontSize: 13, fontWeight: 800, letterSpacing: 1,
            fontFamily: TYPO.english,
          }}>
            {driver.plate}
          </div>
        </div>

        {/* Route info */}
        <div style={{ padding: '14px 20px 0', display: 'flex', gap: 12 }}>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', paddingTop: 6 }}>
            <div style={{ width: 8, height: 8, borderRadius: '50%', background: theme.success }}/>
            <div style={{ width: 2, height: 20, background: theme.border, margin: '3px 0' }}/>
            <div style={{ width: 8, height: 8, borderRadius: 1, background: theme.danger }}/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic }}>
              {T('كريتر - موقعي', 'Crater - My Location', lang)}
            </div>
            <div style={{ fontSize: 13, fontWeight: 700, color: theme.text, marginTop: 10, fontFamily: TYPO.arabic }}>
              {T('جامعة عدن', 'Aden University', lang)}
            </div>
          </div>
          <div style={{ textAlign: 'end', fontSize: 12, fontFamily: TYPO.arabic }}>
            <div style={{ color: theme.textMuted, marginBottom: 2 }}>{T('السعر', 'Fare', lang)}</div>
            <div style={{ fontSize: 16, fontWeight: 800, color: theme.text, fontFamily: TYPO.english }}>
              3,800 <span style={{ fontSize: 10, color: theme.textMuted, fontFamily: TYPO.arabic }}>ر.ي</span>
            </div>
          </div>
        </div>
      </div>

      <style>{`@keyframes blink {0%,100%{opacity:1}50%{opacity:0.3}}`}</style>
    </div>
  );
};

// ─────────────── TRIP END + RATING ───────────────
const RatingScreen = ({ theme, version, onDone, lang }) => {
  const [rating, setRating] = React.useState(0);
  const [tags, setTags] = React.useState([]);
  const [tip, setTip] = React.useState(0);
  const isB = version === 'B';

  const goodTags = [
    T('قيادة آمنة', 'Safe driving', lang),
    T('سيارة نظيفة', 'Clean car', lang),
    T('كلام لطيف', 'Friendly', lang),
    T('في الموعد', 'On time', lang),
    T('طريق سريع', 'Fast route', lang),
    T('موسيقى جيدة', 'Good music', lang),
  ];
  const badTags = [
    T('قيادة متهورة', 'Reckless', lang),
    T('سيارة متسخة', 'Dirty car', lang),
    T('غير مهذب', 'Rude', lang),
    T('تأخر كثيراً', 'Very late', lang),
  ];
  const currentTags = rating >= 4 ? goodTags : rating === 0 ? [] : badTags;

  const toggleTag = (t) => {
    setTags(tags.includes(t) ? tags.filter(x => x !== t) : [...tags, t]);
  };

  return (
    <div style={{
      position: 'absolute', inset: 0, background: theme.bg,
      display: 'flex', flexDirection: 'column',
      overflow: 'auto',
    }}>
      {/* Header */}
      <div style={{ padding: '20px 24px 0', textAlign: 'center' }}>
        <div style={{
          width: 68, height: 68, borderRadius: '50%',
          background: theme.success + '20',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          margin: '0 auto 14px',
        }}>
          <Icon name="check" color={theme.success} size={36} strokeWidth={3}/>
        </div>
        <div style={{ fontSize: 22, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
          {T('وصلت بسلامة!', 'Trip completed!', lang)}
        </div>
        <div style={{ fontSize: 13, color: theme.textMuted, marginTop: 4, fontFamily: TYPO.arabic }}>
          {T('نتمنى لك يوماً سعيداً 🌟', 'Have a wonderful day 🌟', lang)}
        </div>
      </div>

      {/* Fare summary */}
      <div style={{
        margin: '20px 20px 0', padding: '14px 16px',
        background: theme.surface, borderRadius: 14,
        border: `1px solid ${theme.border}`,
      }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
          <span style={{ fontSize: 13, color: theme.textMuted, fontFamily: TYPO.arabic }}>{T('السعر الأساسي', 'Base fare', lang)}</span>
          <span style={{ fontSize: 13, fontWeight: 600, color: theme.text, fontFamily: TYPO.english }}>3,500 {T('ر.ي','YER',lang)}</span>
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
          <span style={{ fontSize: 13, color: theme.textMuted, fontFamily: TYPO.arabic }}>{T('المسافة (7.2 كم)', 'Distance (7.2 km)', lang)}</span>
          <span style={{ fontSize: 13, fontWeight: 600, color: theme.text, fontFamily: TYPO.english }}>+800</span>
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
          <span style={{ fontSize: 13, color: theme.success, fontFamily: TYPO.arabic }}>{T('خصم كوبون', 'Promo discount', lang)}</span>
          <span style={{ fontSize: 13, fontWeight: 600, color: theme.success, fontFamily: TYPO.english }}>-500</span>
        </div>
        <div style={{ borderTop: `1px dashed ${theme.border}`, paddingTop: 10, marginTop: 8,
          display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ fontSize: 14, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>{T('الإجمالي', 'Total', lang)}</span>
          <span style={{ fontSize: 20, fontWeight: 800, color: theme.primary, fontFamily: TYPO.english }}>3,800 <span style={{ fontSize: 11, color: theme.textMuted, fontFamily: TYPO.arabic, fontWeight: 600 }}>ر.ي</span></span>
        </div>
      </div>

      {/* Driver + rating */}
      <div style={{ padding: '24px 20px 0', textAlign: 'center' }}>
        <DriverAvatar size={70} seed={2} ring={theme.primary} style={{ margin: '0 auto' }}/>
        <div style={{ fontSize: 15, fontWeight: 700, color: theme.text, marginTop: 10, fontFamily: TYPO.arabic }}>
          {T('كيف كانت رحلتك مع محمد؟', 'How was your ride with Mohammed?', lang)}
        </div>

        {/* Stars */}
        <div style={{ display: 'flex', justifyContent: 'center', gap: 10, marginTop: 14 }}>
          {[1,2,3,4,5].map(n => (
            <button
              key={n}
              onClick={() => setRating(n)}
              style={{
                background: 'transparent', border: 'none', cursor: 'pointer',
                transform: rating >= n ? 'scale(1.1)' : 'scale(1)',
                transition: 'transform 0.15s',
              }}
            >
              <svg width="36" height="36" viewBox="0 0 24 24">
                <polygon
                  points="12 2 15 9 22 10 17 15 18 22 12 18.5 6 22 7 15 2 10 9 9"
                  fill={rating >= n ? theme.accent : 'none'}
                  stroke={rating >= n ? theme.accent : theme.border}
                  strokeWidth="1.8" strokeLinejoin="round"
                />
              </svg>
            </button>
          ))}
        </div>
      </div>

      {/* Tags */}
      {rating > 0 && (
        <div style={{ padding: '18px 20px 0' }}>
          <div style={{
            fontSize: 12, fontWeight: 700, color: theme.textMuted,
            marginBottom: 10, fontFamily: TYPO.arabic,
          }}>
            {rating >= 4 ? T('ما الذي أعجبك؟', 'What did you like?', lang) : T('ما الذي أزعجك؟', 'What went wrong?', lang)}
          </div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
            {currentTags.map(t => (
              <button
                key={t}
                onClick={() => toggleTag(t)}
                style={{
                  padding: '8px 14px',
                  background: tags.includes(t) ? theme.primary : theme.surface,
                  color: tags.includes(t) ? 'white' : theme.text,
                  border: `1.5px solid ${tags.includes(t) ? theme.primary : theme.border}`,
                  borderRadius: 20, cursor: 'pointer',
                  fontSize: 12, fontWeight: 600, fontFamily: TYPO.arabic,
                  transition: 'all 0.2s',
                }}
              >
                {t}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Tip */}
      {rating >= 4 && (
        <div style={{ padding: '20px 20px 0' }}>
          <div style={{
            fontSize: 12, fontWeight: 700, color: theme.textMuted,
            marginBottom: 10, fontFamily: TYPO.arabic,
          }}>
            {T('أضف إكرامية للسائق', 'Add a tip for the driver', lang)}
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            {[0, 200, 500, 1000].map(t => (
              <button
                key={t}
                onClick={() => setTip(t)}
                style={{
                  flex: 1, padding: '12px 4px',
                  background: tip === t ? theme.primary : theme.surface,
                  color: tip === t ? 'white' : theme.text,
                  border: `1.5px solid ${tip === t ? theme.primary : theme.border}`,
                  borderRadius: 12, cursor: 'pointer',
                  fontSize: 13, fontWeight: 800, fontFamily: TYPO.english,
                }}
              >
                {t === 0 ? T('لا شكراً', 'None', lang) : `${t}`}
              </button>
            ))}
          </div>
        </div>
      )}

      <div style={{ flex: 1, minHeight: 20 }}/>

      {/* CTA */}
      <div style={{ padding: '20px 20px 24px' }}>
        <button
          onClick={onDone}
          style={{
            width: '100%', height: 54,
            background: rating > 0 ? theme.primary : theme.border,
            color: 'white', border: 'none',
            borderRadius: isB ? 12 : 27,
            fontSize: 16, fontWeight: 800, cursor: 'pointer',
            fontFamily: TYPO.arabic,
            boxShadow: rating > 0 ? `0 8px 20px ${theme.primary}40` : 'none',
          }}
        >
          {T('إرسال التقييم', 'Submit rating', lang)}
        </button>
      </div>
    </div>
  );
};

Object.assign(window, { FindingScreen, ActiveRideScreen, RatingScreen });
