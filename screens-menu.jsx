// Screens: Menu, Wallet, History, Profile, Notifications
// ═══════════════════════════════════════════════════════════════

// ─────────────── SIDE MENU (Drawer) ───────────────
const MenuScreen = ({ theme, version, onClose, onNav, lang, userName = 'أحمد الشيباني' }) => {
  const items = [
    { icon: 'user', label: T('الملف الشخصي', 'Profile', lang), screen: 'profile' },
    { icon: 'clock', label: T('رحلاتي', 'My rides', lang), screen: 'history', badge: '12' },
    { icon: 'wallet', label: T('المحفظة', 'Wallet', lang), screen: 'wallet' },
    { icon: 'bell', label: T('الإشعارات', 'Notifications', lang), screen: 'notifs', badge: '3' },
    { icon: 'tag', label: T('الكوبونات', 'Promos', lang), screen: 'promo' },
    { icon: 'gift', label: T('نظام النقاط', 'Rewards', lang), screen: 'rewards', badge: T('جديد', 'New', lang) },
    { icon: 'crown', label: T('اشتراك VIP', 'VIP subscription', lang), screen: 'vip', highlight: true },
    { icon: 'shield', label: T('جهات الطوارئ', 'Emergency contacts', lang), screen: 'sos' },
    { icon: 'settings', label: T('الإعدادات', 'Settings', lang), screen: 'settings' },
    { icon: 'help', label: T('المساعدة', 'Help', lang), screen: 'help' },
  ];

  return (
    <div style={{
      position: 'absolute', inset: 0,
      background: 'rgba(0,0,0,0.5)',
      display: 'flex',
      animation: 'fadeIn 0.2s',
    }} onClick={onClose}>
      <div style={{
        width: '82%', maxWidth: 340, height: '100%',
        background: theme.surfaceElev,
        display: 'flex', flexDirection: 'column',
        animation: `slideIn${lang === 'ar' ? 'R' : 'L'} 0.3s cubic-bezier(0.25,0.85,0.4,1)`,
        overflowY: 'auto',
      }} onClick={e => e.stopPropagation()}>
        {/* Header - Profile */}
        <div style={{
          padding: '24px 20px 20px',
          background: `linear-gradient(135deg, ${theme.primary}, ${theme.primaryDark})`,
          color: 'white',
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 14 }}>
            <button onClick={onClose} style={{
              width: 32, height: 32, borderRadius: '50%',
              background: 'rgba(255,255,255,0.2)', border: 'none',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer',
            }}>
              <Icon name="close" color="white" size={18}/>
            </button>
            <div style={{
              padding: '4px 10px', background: 'rgba(255,255,255,0.2)',
              borderRadius: 12, display: 'flex', alignItems: 'center', gap: 5,
            }}>
              <Icon name="star" color="#FFD700" size={12}/>
              <span style={{ fontSize: 12, fontWeight: 700, fontFamily: TYPO.english }}>4.90</span>
            </div>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <DriverAvatar size={56} seed={1} ring="white"/>
            <div>
              <div style={{ fontSize: 17, fontWeight: 800, fontFamily: TYPO.arabic }}>
                {userName}
              </div>
              <div style={{ fontSize: 12, opacity: 0.9, fontFamily: TYPO.english, marginTop: 2 }}>
                +967 77 123 4567
              </div>
            </div>
          </div>

          {/* Wallet balance quick view */}
          <div style={{
            marginTop: 16, padding: '10px 12px',
            background: 'rgba(255,255,255,0.15)',
            borderRadius: 12, display: 'flex', alignItems: 'center', gap: 10,
            backdropFilter: 'blur(10px)',
          }}>
            <Icon name="wallet" color="white" size={20}/>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 10, opacity: 0.8, fontFamily: TYPO.arabic }}>
                {T('رصيد المحفظة', 'Wallet balance', lang)}
              </div>
              <div style={{ fontSize: 15, fontWeight: 800, fontFamily: TYPO.english }}>
                15,300 <span style={{ fontSize: 11, opacity: 0.8, fontFamily: TYPO.arabic }}>ر.ي</span>
              </div>
            </div>
            <div style={{
              padding: '6px 10px', background: 'white', color: theme.primary,
              borderRadius: 10, fontSize: 11, fontWeight: 800, fontFamily: TYPO.arabic,
              cursor: 'pointer',
            }} onClick={() => onNav('wallet')}>
              {T('شحن', 'Top up', lang)}
            </div>
          </div>
        </div>

        {/* Menu items */}
        <div style={{ padding: '12px 0', flex: 1 }}>
          {items.map((it, i) => (
            <button
              key={i}
              onClick={() => { onClose(); setTimeout(() => onNav(it.screen), 100); }}
              style={{
                width: '100%', display: 'flex', alignItems: 'center', gap: 14,
                padding: '14px 20px',
                background: it.highlight ? theme.accent + '10' : 'transparent',
                border: 'none', cursor: 'pointer', textAlign: 'start',
                fontFamily: TYPO.arabic,
              }}
            >
              <div style={{
                width: 36, height: 36, borderRadius: 10,
                background: it.highlight ? theme.accent + '25' : theme.surface,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon name={it.icon} color={it.highlight ? theme.accent : theme.text} size={18}/>
              </div>
              <span style={{ flex: 1, fontSize: 14, fontWeight: 600, color: theme.text }}>
                {it.label}
              </span>
              {it.badge && (
                <span style={{
                  padding: '2px 8px',
                  background: typeof it.badge === 'string' && it.badge.length > 2 ? theme.primary : theme.danger,
                  color: 'white', borderRadius: 10,
                  fontSize: 10, fontWeight: 700,
                }}>{it.badge}</span>
              )}
              <Icon name={lang === 'ar' ? 'back' : 'forward'} color={theme.textLight} size={16}/>
            </button>
          ))}
        </div>

        {/* Logout */}
        <div style={{
          padding: '14px 20px', borderTop: `1px solid ${theme.border}`,
          display: 'flex', alignItems: 'center', gap: 10, cursor: 'pointer',
        }}>
          <Icon name="logout" color={theme.danger} size={18}/>
          <span style={{ fontSize: 13, fontWeight: 700, color: theme.danger, fontFamily: TYPO.arabic }}>
            {T('تسجيل الخروج', 'Sign out', lang)}
          </span>
        </div>
      </div>
      <style>{`
        @keyframes fadeIn {0%{opacity:0}100%{opacity:1}}
        @keyframes slideInR {0%{transform:translateX(100%)}100%{transform:translateX(0)}}
        @keyframes slideInL {0%{transform:translateX(-100%)}100%{transform:translateX(0)}}
      `}</style>
    </div>
  );
};

// ─────────────── WALLET ───────────────
const WalletScreen = ({ theme, version, onBack, lang }) => {
  const isB = version === 'B';
  const transactions = [
    { icon: 'car', title: T('رحلة إلى جامعة عدن', 'Trip to Aden University', lang), sub: T('اليوم · 09:24', 'Today · 09:24', lang), amount: -3800, type: 'ride' },
    { icon: 'plus2', title: T('شحن المحفظة', 'Wallet top-up', lang), sub: T('أمس · 18:12', 'Yesterday · 18:12', lang), amount: +10000, type: 'topup' },
    { icon: 'gift', title: T('مكافأة ترحيبية', 'Welcome bonus', lang), sub: T('4 يوليو · 14:00', 'Jul 4 · 14:00', lang), amount: +2000, type: 'bonus' },
    { icon: 'car', title: T('رحلة إلى المعلا', 'Trip to Maalla', lang), sub: T('3 يوليو · 20:30', 'Jul 3 · 20:30', lang), amount: -2100, type: 'ride' },
    { icon: 'tag', title: T('استرداد كوبون', 'Promo refund', lang), sub: T('2 يوليو · 11:15', 'Jul 2 · 11:15', lang), amount: +500, type: 'promo' },
  ];

  return (
    <div style={{ position: 'absolute', inset: 0, background: theme.bg, display: 'flex', flexDirection: 'column' }}>
      {/* Header */}
      <div style={{ padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
        <button onClick={onBack} style={{
          width: 40, height: 40, borderRadius: '50%',
          background: theme.surface, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer',
        }}>
          <Icon name={lang === 'ar' ? 'forward' : 'back'} color={theme.text} size={20}/>
        </button>
        <div style={{ flex: 1, fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
          {T('المحفظة', 'Wallet', lang)}
        </div>
        <button style={{
          background: 'none', border: 'none', color: theme.primary,
          fontSize: 13, fontWeight: 700, cursor: 'pointer', fontFamily: TYPO.arabic,
        }}>
          {T('السجل', 'History', lang)}
        </button>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '0 16px 20px' }}>
        {/* Balance card */}
        <div style={{
          padding: '20px', borderRadius: 20,
          background: `linear-gradient(135deg, ${theme.primary}, ${theme.primaryDark})`,
          color: 'white', position: 'relative', overflow: 'hidden',
          boxShadow: `0 12px 32px ${theme.primary}40`,
        }}>
          {/* Decorative circles */}
          <div style={{
            position: 'absolute', top: -30, insetInlineEnd: -30,
            width: 140, height: 140, borderRadius: '50%',
            background: 'rgba(255,255,255,0.1)',
          }}/>
          <div style={{
            position: 'absolute', bottom: -50, insetInlineStart: -50,
            width: 120, height: 120, borderRadius: '50%',
            background: 'rgba(255,255,255,0.08)',
          }}/>

          <div style={{ position: 'relative', zIndex: 1 }}>
            <div style={{ fontSize: 12, opacity: 0.9, fontFamily: TYPO.arabic }}>
              {T('الرصيد الحالي', 'Current Balance', lang)}
            </div>
            <div style={{ fontSize: 36, fontWeight: 900, marginTop: 4, fontFamily: TYPO.english, letterSpacing: -1 }}>
              15,300 <span style={{ fontSize: 16, opacity: 0.9, fontFamily: TYPO.arabic, fontWeight: 700 }}>ر.ي</span>
            </div>

            <div style={{ display: 'flex', gap: 10, marginTop: 18 }}>
              <button style={{
                flex: 1, padding: '12px', background: 'white', color: theme.primary,
                border: 'none', borderRadius: 12,
                fontSize: 13, fontWeight: 800, cursor: 'pointer',
                display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
                fontFamily: TYPO.arabic,
              }}>
                <Icon name="plus" size={16}/>
                {T('شحن الرصيد', 'Top up', lang)}
              </button>
              <button style={{
                flex: 1, padding: '12px', background: 'rgba(255,255,255,0.2)', color: 'white',
                border: '1.5px solid rgba(255,255,255,0.35)', borderRadius: 12,
                fontSize: 13, fontWeight: 800, cursor: 'pointer',
                display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
                backdropFilter: 'blur(10px)',
                fontFamily: TYPO.arabic,
              }}>
                <Icon name="share" size={16}/>
                {T('تحويل', 'Send', lang)}
              </button>
            </div>
          </div>
        </div>

        {/* Payment methods */}
        <div style={{ marginTop: 20 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 10 }}>
            <div style={{ fontSize: 15, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
              {T('طرق الدفع', 'Payment methods', lang)}
            </div>
            <button style={{
              background: 'none', border: 'none', color: theme.primary,
              fontSize: 12, fontWeight: 700, cursor: 'pointer', fontFamily: TYPO.arabic,
            }}>
              + {T('إضافة', 'Add', lang)}
            </button>
          </div>

          {/* Cards */}
          <div style={{ display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 4 }}>
            <PaymentCard theme={theme} type="cash" lang={lang}/>
            <PaymentCard theme={theme} type="visa" last4="4287" lang={lang}/>
            <PaymentCard theme={theme} type="add" lang={lang}/>
          </div>
        </div>

        {/* Transactions */}
        <div style={{ marginTop: 24 }}>
          <div style={{ fontSize: 15, fontWeight: 800, color: theme.text, marginBottom: 10, fontFamily: TYPO.arabic }}>
            {T('آخر المعاملات', 'Recent transactions', lang)}
          </div>
          <div style={{
            background: theme.surface, borderRadius: 14,
            border: `1px solid ${theme.border}`, overflow: 'hidden',
          }}>
            {transactions.map((t, i) => (
              <div key={i} style={{
                display: 'flex', alignItems: 'center', gap: 12,
                padding: '14px 14px',
                borderTop: i > 0 ? `1px solid ${theme.border}` : 'none',
              }}>
                <div style={{
                  width: 40, height: 40, borderRadius: 10,
                  background: t.amount > 0 ? theme.success + '20' : theme.surfaceElev,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  <Icon name={t.icon} color={t.amount > 0 ? theme.success : theme.text} size={18}/>
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic }}>
                    {t.title}
                  </div>
                  <div style={{ fontSize: 11, color: theme.textMuted, marginTop: 2, fontFamily: TYPO.arabic }}>
                    {t.sub}
                  </div>
                </div>
                <div style={{
                  fontSize: 14, fontWeight: 800, fontFamily: TYPO.english,
                  color: t.amount > 0 ? theme.success : theme.text,
                }}>
                  {t.amount > 0 ? '+' : ''}{t.amount.toLocaleString()}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

const PaymentCard = ({ theme, type, last4, lang }) => {
  if (type === 'add') {
    return (
      <div style={{
        minWidth: 140, height: 90, borderRadius: 14,
        border: `2px dashed ${theme.border}`,
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        gap: 6, cursor: 'pointer',
      }}>
        <Icon name="plus" color={theme.textMuted} size={22}/>
        <span style={{ fontSize: 11, fontWeight: 600, color: theme.textMuted, fontFamily: TYPO.arabic }}>
          {T('إضافة بطاقة', 'Add card', lang)}
        </span>
      </div>
    );
  }
  if (type === 'cash') {
    return (
      <div style={{
        minWidth: 140, height: 90, borderRadius: 14, padding: 12,
        background: `linear-gradient(135deg, #06D6A0, #04A47C)`,
        color: 'white', position: 'relative', overflow: 'hidden',
        display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
      }}>
        <Icon name="cash" color="white" size={22}/>
        <div>
          <div style={{ fontSize: 13, fontWeight: 800, fontFamily: TYPO.arabic }}>
            {T('نقدي', 'Cash', lang)}
          </div>
          <div style={{ fontSize: 10, opacity: 0.85, fontFamily: TYPO.arabic }}>
            {T('الافتراضي', 'Default', lang)}
          </div>
        </div>
      </div>
    );
  }
  return (
    <div style={{
      minWidth: 140, height: 90, borderRadius: 14, padding: 12,
      background: `linear-gradient(135deg, #1A1F36, #2E3554)`,
      color: 'white', position: 'relative',
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <Icon name="creditCard" color="white" size={22}/>
        <span style={{ fontSize: 16, fontWeight: 900, fontStyle: 'italic', fontFamily: 'serif' }}>VISA</span>
      </div>
      <div style={{ fontSize: 13, fontFamily: TYPO.english, letterSpacing: 1.5 }}>
        •••• {last4}
      </div>
    </div>
  );
};

// ─────────────── TRIP HISTORY ───────────────
const HistoryScreen = ({ theme, version, onBack, lang }) => {
  const trips = [
    { date: T('اليوم', 'Today', lang), from: T('كريتر', 'Crater', lang), to: T('جامعة عدن', 'Aden University', lang), price: 3800, status: 'completed', time: '09:24', rating: 5 },
    { date: T('أمس', 'Yesterday', lang), from: T('التواهي', 'Tawahi', lang), to: T('المعلا', 'Maalla', lang), price: 2500, status: 'completed', time: '18:12', rating: 4 },
    { date: T('أمس', 'Yesterday', lang), from: T('خور مكسر', 'Khormaksar', lang), to: T('كريتر', 'Crater', lang), price: 3200, status: 'completed', time: '10:30', rating: 5 },
    { date: T('4 يوليو', 'Jul 4', lang), from: T('الملاح', 'Al-Mallah', lang), to: T('جامعة عدن', 'Aden University', lang), price: 4500, status: 'cancelled', time: '14:00' },
    { date: T('3 يوليو', 'Jul 3', lang), from: T('المنزل', 'Home', lang), to: T('العمل', 'Work', lang), price: 2100, status: 'completed', time: '08:00', rating: 5 },
  ];

  return (
    <div style={{ position: 'absolute', inset: 0, background: theme.bg, display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
        <button onClick={onBack} style={{
          width: 40, height: 40, borderRadius: '50%',
          background: theme.surface, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer',
        }}>
          <Icon name={lang === 'ar' ? 'forward' : 'back'} color={theme.text} size={20}/>
        </button>
        <div style={{ flex: 1, fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
          {T('رحلاتي', 'My rides', lang)}
        </div>
        <button style={{
          width: 40, height: 40, borderRadius: '50%',
          background: theme.surface, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer',
        }}>
          <Icon name="filter" color={theme.text} size={18}/>
        </button>
      </div>

      {/* Stats */}
      <div style={{ padding: '0 16px 8px', display: 'flex', gap: 10 }}>
        {[
          { label: T('رحلات', 'Rides', lang), value: '47' },
          { label: T('كيلومتر', 'km', lang), value: '312' },
          { label: T('توفير', 'Saved', lang), value: '4.2K' },
        ].map((s, i) => (
          <div key={i} style={{
            flex: 1, padding: '12px', background: theme.surface,
            borderRadius: 12, textAlign: 'center',
            border: `1px solid ${theme.border}`,
          }}>
            <div style={{ fontSize: 20, fontWeight: 800, color: theme.primary, fontFamily: TYPO.english }}>
              {s.value}
            </div>
            <div style={{ fontSize: 11, color: theme.textMuted, marginTop: 2, fontFamily: TYPO.arabic }}>
              {s.label}
            </div>
          </div>
        ))}
      </div>

      {/* Trips list */}
      <div style={{ flex: 1, overflow: 'auto', padding: '12px 16px 20px' }}>
        {trips.map((t, i) => {
          const isSameDay = i > 0 && trips[i-1].date === t.date;
          return (
            <React.Fragment key={i}>
              {!isSameDay && (
                <div style={{
                  fontSize: 11, fontWeight: 800, color: theme.textMuted,
                  margin: i === 0 ? '4px 4px 8px' : '16px 4px 8px',
                  letterSpacing: 0.5, fontFamily: TYPO.arabic,
                }}>
                  {t.date}
                </div>
              )}
              <div style={{
                display: 'flex', gap: 12, padding: '14px',
                background: theme.surface, borderRadius: 14,
                marginBottom: 8, cursor: 'pointer',
                border: `1px solid ${theme.border}`,
              }}>
                <MiniMap theme={theme} style={{ width: 66, height: 66, borderRadius: 10, flexShrink: 0 }}/>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
                    <span style={{ fontSize: 12, color: theme.textMuted, fontFamily: TYPO.arabic }}>
                      {t.time}
                    </span>
                    {t.status === 'cancelled' && (
                      <span style={{
                        padding: '1px 6px', background: theme.danger + '20',
                        color: theme.danger, borderRadius: 4, fontSize: 9, fontWeight: 700,
                        fontFamily: TYPO.arabic,
                      }}>
                        {T('ملغاة', 'Cancelled', lang)}
                      </span>
                    )}
                    {t.rating && (
                      <div style={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                        <Icon name="star" color={theme.accent} size={11} strokeWidth={0}/>
                        <span style={{ fontSize: 11, fontWeight: 700, color: theme.text, fontFamily: TYPO.english }}>
                          {t.rating}.0
                        </span>
                      </div>
                    )}
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 6 }}>
                    <div style={{ width: 6, height: 6, borderRadius: '50%', background: theme.success, flexShrink: 0 }}/>
                    <div style={{ fontSize: 12, color: theme.text, fontFamily: TYPO.arabic, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                      {t.from}
                    </div>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 4 }}>
                    <div style={{ width: 6, height: 6, borderRadius: 1, background: theme.danger, flexShrink: 0 }}/>
                    <div style={{ fontSize: 12, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                      {t.to}
                    </div>
                  </div>
                </div>
                <div style={{ textAlign: 'end', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
                  <div style={{ fontSize: 15, fontWeight: 800, color: theme.text, fontFamily: TYPO.english }}>
                    {t.price.toLocaleString()}
                    <div style={{ fontSize: 10, color: theme.textMuted, fontFamily: TYPO.arabic, fontWeight: 600 }}>
                      {T('ر.ي', 'YER', lang)}
                    </div>
                  </div>
                </div>
              </div>
            </React.Fragment>
          );
        })}
      </div>
    </div>
  );
};

// ─────────────── PROFILE ───────────────
const ProfileScreen = ({ theme, version, onBack, lang }) => {
  return (
    <div style={{ position: 'absolute', inset: 0, background: theme.bg, display: 'flex', flexDirection: 'column', overflow: 'auto' }}>
      <div style={{ padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
        <button onClick={onBack} style={{
          width: 40, height: 40, borderRadius: '50%',
          background: theme.surface, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
        }}>
          <Icon name={lang === 'ar' ? 'forward' : 'back'} color={theme.text} size={20}/>
        </button>
        <div style={{ flex: 1, fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
          {T('الملف الشخصي', 'Profile', lang)}
        </div>
        <button style={{
          background: 'none', border: 'none', color: theme.primary,
          fontSize: 13, fontWeight: 700, cursor: 'pointer', fontFamily: TYPO.arabic,
        }}>
          {T('تعديل', 'Edit', lang)}
        </button>
      </div>

      {/* Profile card */}
      <div style={{ padding: '12px 16px 0' }}>
        <div style={{
          padding: '20px', background: theme.surface,
          borderRadius: 18, border: `1px solid ${theme.border}`,
          display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <div style={{ position: 'relative' }}>
            <DriverAvatar size={68} seed={1} ring={theme.primary}/>
            <button style={{
              position: 'absolute', bottom: -2, insetInlineEnd: -2,
              width: 24, height: 24, borderRadius: '50%',
              background: theme.primary, border: `2px solid ${theme.surface}`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer',
            }}>
              <Icon name="edit" color="white" size={12}/>
            </button>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
              {T('أحمد الشيباني', 'Ahmed Al-Shaibani', lang)}
            </div>
            <div style={{ fontSize: 12, color: theme.textMuted, marginTop: 4, fontFamily: TYPO.english }}>
              ahmed@example.com
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 6 }}>
              <Icon name="star" color={theme.accent} size={12} strokeWidth={0}/>
              <span style={{ fontSize: 12, fontWeight: 700, color: theme.text, fontFamily: TYPO.english }}>
                4.90
              </span>
              <span style={{ fontSize: 11, color: theme.textMuted, fontFamily: TYPO.arabic }}>
                · {T('عضو منذ 2023', 'Member since 2023', lang)}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Points card */}
      <div style={{ padding: '12px 16px 0' }}>
        <div style={{
          padding: '16px', borderRadius: 16,
          background: `linear-gradient(135deg, ${theme.accent}, #FF9800)`,
          color: 'white', position: 'relative', overflow: 'hidden',
        }}>
          <div style={{ position: 'absolute', top: -20, insetInlineEnd: -20, width: 80, height: 80, borderRadius: '50%', background: 'rgba(255,255,255,0.15)' }}/>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', position: 'relative' }}>
            <div>
              <div style={{ fontSize: 11, opacity: 0.9, fontFamily: TYPO.arabic }}>
                {T('نقاطك المتاحة', 'Your points', lang)}
              </div>
              <div style={{ fontSize: 28, fontWeight: 900, marginTop: 2, fontFamily: TYPO.english }}>
                2,450 <span style={{ fontSize: 13, opacity: 0.9, fontFamily: TYPO.arabic }}>{T('نقطة', 'pts', lang)}</span>
              </div>
              <div style={{ fontSize: 10, opacity: 0.85, marginTop: 4, fontFamily: TYPO.arabic }}>
                {T('550 نقطة لمستوى ذهبي', '550 pts to Gold tier', lang)}
              </div>
              {/* progress */}
              <div style={{
                marginTop: 8, width: 140, height: 5, borderRadius: 3,
                background: 'rgba(255,255,255,0.3)',
              }}>
                <div style={{ width: '80%', height: '100%', borderRadius: 3, background: 'white' }}/>
              </div>
            </div>
            <div style={{
              width: 54, height: 54, borderRadius: '50%',
              background: 'rgba(255,255,255,0.2)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              backdropFilter: 'blur(10px)',
            }}>
              <Icon name="gift" color="white" size={28}/>
            </div>
          </div>
        </div>
      </div>

      {/* Info sections */}
      <div style={{ padding: '20px 16px 24px' }}>
        <SettingSection theme={theme} title={T('المعلومات الشخصية', 'Personal info', lang)} items={[
          { icon: 'user', label: T('الاسم', 'Name', lang), value: T('أحمد الشيباني', 'Ahmed Al-Shaibani', lang) },
          { icon: 'phone', label: T('الجوال', 'Phone', lang), value: '+967 77 123 4567', verified: true },
          { icon: 'message', label: T('البريد', 'Email', lang), value: 'ahmed@example.com' },
        ]} lang={lang}/>

        <SettingSection theme={theme} title={T('العناوين المحفوظة', 'Saved addresses', lang)} items={[
          { icon: 'home', label: T('المنزل', 'Home', lang), value: T('حي الشيخ عثمان، عدن', 'Sheikh Othman, Aden', lang) },
          { icon: 'work', label: T('العمل', 'Work', lang), value: T('شارع كالتكس، المعلا', 'Caltex St, Maalla', lang) },
          { icon: 'plus2', label: T('إضافة عنوان', 'Add address', lang), value: '', primary: true },
        ]} lang={lang}/>

        <SettingSection theme={theme} title={T('جهات الطوارئ', 'Emergency contacts', lang)} items={[
          { icon: 'user', label: T('والدي', 'Father', lang), value: '+967 77 xxx xxxx' },
          { icon: 'plus2', label: T('إضافة جهة اتصال', 'Add contact', lang), value: '', primary: true },
        ]} lang={lang}/>
      </div>
    </div>
  );
};

const SettingSection = ({ theme, title, items, lang }) => (
  <div style={{ marginBottom: 20 }}>
    <div style={{
      fontSize: 12, fontWeight: 800, color: theme.textMuted,
      marginBottom: 8, letterSpacing: 0.5, fontFamily: TYPO.arabic,
    }}>
      {title}
    </div>
    <div style={{
      background: theme.surface, borderRadius: 14,
      border: `1px solid ${theme.border}`, overflow: 'hidden',
    }}>
      {items.map((it, i) => (
        <div key={i} style={{
          display: 'flex', alignItems: 'center', gap: 12,
          padding: '12px 14px',
          borderTop: i > 0 ? `1px solid ${theme.border}` : 'none',
          cursor: 'pointer',
        }}>
          <div style={{
            width: 32, height: 32, borderRadius: 9,
            background: it.primary ? theme.primary + '20' : theme.surfaceElev,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon name={it.icon} color={it.primary ? theme.primary : theme.textMuted} size={16}/>
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              fontSize: 13, fontWeight: it.primary ? 700 : 500,
              color: it.primary ? theme.primary : theme.textMuted,
              fontFamily: TYPO.arabic,
            }}>
              {it.label}
            </div>
            {it.value && (
              <div style={{ fontSize: 13, fontWeight: 600, color: theme.text, marginTop: 2, fontFamily: TYPO.arabic, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                {it.value}
              </div>
            )}
          </div>
          {it.verified && (
            <div style={{
              padding: '2px 6px', background: theme.success + '20',
              color: theme.success, borderRadius: 4, fontSize: 9, fontWeight: 700,
              fontFamily: TYPO.arabic,
            }}>
              {T('موثق', 'Verified', lang)}
            </div>
          )}
          <Icon name={lang === 'ar' ? 'back' : 'forward'} color={theme.textLight} size={14}/>
        </div>
      ))}
    </div>
  </div>
);

// ─────────────── NOTIFICATIONS ───────────────
const NotificationsScreen = ({ theme, version, onBack, lang }) => {
  const notifs = [
    { icon: 'gift', color: theme.accent, title: T('🎉 حصلت على 200 نقطة', '🎉 You earned 200 points', lang), sub: T('لإكمالك رحلة اليوم', 'For completing today\'s ride', lang), time: T('الآن', 'Now', lang), unread: true },
    { icon: 'tag', color: theme.primary, title: T('كوبون خصم 30%', '30% off coupon', lang), sub: T('عرض خاص لهذا الأسبوع فقط', 'Special weekly offer', lang), time: T('منذ ساعتين', '2h ago', lang), unread: true },
    { icon: 'check', color: theme.success, title: T('اكتملت رحلتك', 'Trip completed', lang), sub: T('إلى جامعة عدن · 3,800 ر.ي', 'To Aden University · 3,800 YER', lang), time: T('منذ 3 ساعات', '3h ago', lang), unread: true },
    { icon: 'crown', color: theme.accent, title: T('ترقية VIP بخصم 50%', 'VIP upgrade 50% off', lang), sub: T('استمتع بمزايا حصرية', 'Enjoy exclusive benefits', lang), time: T('أمس', 'Yesterday', lang) },
    { icon: 'star', color: theme.primary, title: T('محمد قيمك بـ 5 نجوم', 'Mohammed rated you 5 stars', lang), sub: T('راكب رائع، شكراً!', 'Great passenger, thanks!', lang), time: T('أمس', 'Yesterday', lang) },
  ];

  return (
    <div style={{ position: 'absolute', inset: 0, background: theme.bg, display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
        <button onClick={onBack} style={{
          width: 40, height: 40, borderRadius: '50%',
          background: theme.surface, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
        }}>
          <Icon name={lang === 'ar' ? 'forward' : 'back'} color={theme.text} size={20}/>
        </button>
        <div style={{ flex: 1, fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic }}>
          {T('الإشعارات', 'Notifications', lang)}
        </div>
        <button style={{
          background: 'none', border: 'none', color: theme.primary,
          fontSize: 12, fontWeight: 700, cursor: 'pointer', fontFamily: TYPO.arabic,
        }}>
          {T('تحديد الكل مقروء', 'Mark all read', lang)}
        </button>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '4px 16px 20px' }}>
        {notifs.map((n, i) => (
          <div key={i} style={{
            display: 'flex', gap: 12, padding: '14px 12px',
            background: n.unread ? theme.primary + '08' : 'transparent',
            borderRadius: 12, marginBottom: 6, cursor: 'pointer',
            position: 'relative',
          }}>
            {n.unread && (
              <div style={{
                position: 'absolute', top: 20, insetInlineStart: 2,
                width: 6, height: 6, borderRadius: '50%',
                background: theme.primary,
              }}/>
            )}
            <div style={{
              width: 44, height: 44, borderRadius: 12,
              background: n.color + '20',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              flexShrink: 0, marginInlineStart: n.unread ? 8 : 0,
            }}>
              <Icon name={n.icon} color={n.color} size={22} strokeWidth={n.icon === 'star' ? 0 : 1.8}/>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 13, fontWeight: 700, color: theme.text, fontFamily: TYPO.arabic }}>
                {n.title}
              </div>
              <div style={{ fontSize: 12, color: theme.textMuted, marginTop: 3, fontFamily: TYPO.arabic }}>
                {n.sub}
              </div>
              <div style={{ fontSize: 10, color: theme.textLight, marginTop: 5, fontFamily: TYPO.arabic }}>
                {n.time}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

Object.assign(window, { MenuScreen, WalletScreen, HistoryScreen, ProfileScreen, NotificationsScreen });
