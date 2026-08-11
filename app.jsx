// Main App - Mishwarak
// ═══════════════════════════════════════════════════════════════

const { useState, useEffect, useMemo } = React;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "version": "A",
  "mode": "light",
  "lang": "ar",
  "device": "android",
  "screen": "home"
}/*EDITMODE-END*/;

// Auto system-dark detection (only if mode == 'auto')
function useSystemDark() {
  const [dark, setDark] = useState(false);
  useEffect(() => {
    const mq = window.matchMedia('(prefers-color-scheme: dark)');
    setDark(mq.matches);
    const handler = e => setDark(e.matches);
    mq.addEventListener('change', handler);
    return () => mq.removeEventListener('change', handler);
  }, []);
  return dark;
}

// ─────────────── SCREEN ROUTER ───────────────
const ScreenRouter = ({ theme, version, lang, initial = 'home', onScreenChange }) => {
  const [screen, setScreen] = useState(initial);
  const [showMenu, setShowMenu] = useState(false);

  useEffect(() => setScreen(initial), [initial]);

  const nav = (s) => {
    setScreen(s);
    onScreenChange?.(s);
  };

  const back = () => nav('home');

  return (
    <>
      {screen === 'splash' && <SplashScreen theme={theme} version={version} lang={lang} onDone={() => nav('onboarding')}/>}
      {screen === 'onboarding' && <OnboardingScreen theme={theme} version={version} lang={lang} onDone={() => nav('login')}/>}
      {screen === 'login' && <LoginScreen theme={theme} version={version} lang={lang} onDone={() => nav('home')}/>}
      {screen === 'home' && <HomeScreen theme={theme} version={version} lang={lang} onNav={nav} onMenu={() => setShowMenu(true)}/>}
      {screen === 'search' && <SearchScreen theme={theme} version={version} lang={lang} onBack={back} onNav={nav}/>}
      {screen === 'vehicle' && <VehicleScreen theme={theme} version={version} lang={lang} onBack={back} onNav={nav}/>}
      {screen === 'finding' && <FindingScreen theme={theme} version={version} lang={lang} onCancel={back} onFound={() => nav('active')}/>}
      {screen === 'active' && <ActiveRideScreen theme={theme} version={version} lang={lang} onEnd={() => nav('rating')}/>}
      {screen === 'rating' && <RatingScreen theme={theme} version={version} lang={lang} onDone={back}/>}
      {screen === 'wallet' && <WalletScreen theme={theme} version={version} lang={lang} onBack={back}/>}
      {screen === 'history' && <HistoryScreen theme={theme} version={version} lang={lang} onBack={back}/>}
      {screen === 'profile' && <ProfileScreen theme={theme} version={version} lang={lang} onBack={back}/>}
      {screen === 'notifs' && <NotificationsScreen theme={theme} version={version} lang={lang} onBack={back}/>}
      {['settings', 'help', 'rewards', 'vip', 'sos', 'promo'].includes(screen) && (
        <PlaceholderScreen theme={theme} lang={lang} onBack={back} name={screen}/>
      )}
      {showMenu && <MenuScreen theme={theme} version={version} lang={lang} onClose={() => setShowMenu(false)} onNav={nav}/>}
    </>
  );
};

const PlaceholderScreen = ({ theme, lang, onBack, name }) => {
  const labels = {
    settings: T('الإعدادات', 'Settings', lang),
    help: T('المساعدة', 'Help', lang),
    rewards: T('نظام النقاط', 'Rewards', lang),
    vip: T('اشتراك VIP', 'VIP subscription', lang),
    sos: T('جهات الطوارئ', 'Emergency contacts', lang),
    promo: T('الكوبونات', 'Promo codes', lang),
  };
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
          {labels[name]}
        </div>
      </div>
      <div style={{
        flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center',
        flexDirection: 'column', gap: 16, padding: 40,
      }}>
        <div style={{
          width: 100, height: 100, borderRadius: 30,
          background: theme.primary + '15',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="settings" color={theme.primary} size={48}/>
        </div>
        <div style={{ fontSize: 18, fontWeight: 800, color: theme.text, fontFamily: TYPO.arabic, textAlign: 'center' }}>
          {T('هذه الشاشة قيد التطوير', 'This screen is coming soon', lang)}
        </div>
        <div style={{ fontSize: 13, color: theme.textMuted, textAlign: 'center', fontFamily: TYPO.arabic, lineHeight: 1.6 }}>
          {T('ركزنا في هذا العرض على الشاشات الأساسية للتجربة الكاملة', 'This prototype focuses on the core flow screens', lang)}
        </div>
        <button onClick={onBack} style={{
          padding: '12px 24px', background: theme.primary, color: 'white',
          border: 'none', borderRadius: 24, cursor: 'pointer',
          fontSize: 14, fontWeight: 700, fontFamily: TYPO.arabic,
          marginTop: 8,
        }}>
          {T('العودة للرئيسية', 'Back to home', lang)}
        </button>
      </div>
    </div>
  );
};

// ─────────────── DEVICE WRAPPER ───────────────
const PhoneMockup = ({ device, dark, version, lang, screen, onScreenChange }) => {
  const theme = getTheme(version, dark ? 'dark' : 'light');
  const isIOS = device === 'ios';

  const deviceStyle = {
    width: isIOS ? 393 : 393,
    height: isIOS ? 852 : 852,
    borderRadius: isIOS ? 55 : 38,
    background: theme.bg,
    border: `10px solid ${isIOS ? '#1a1a1a' : '#252525'}`,
    boxShadow: '0 30px 80px rgba(0,0,0,0.35), 0 8px 24px rgba(0,0,0,0.2)',
    overflow: 'hidden',
    position: 'relative',
    display: 'flex', flexDirection: 'column',
    boxSizing: 'border-box',
  };

  return (
    <div style={deviceStyle} dir={lang === 'ar' ? 'rtl' : 'ltr'}>
      {/* Status bar */}
      {isIOS ? (
        <div style={{
          height: 54, display: 'flex', alignItems: 'center',
          justifyContent: 'space-between', padding: '16px 32px 0',
          position: 'relative', flexShrink: 0, zIndex: 100,
        }}>
          <span style={{ fontSize: 17, fontWeight: 600, color: theme.text, fontFamily: '-apple-system, sans-serif' }}>9:41</span>
          {/* Dynamic Island */}
          <div style={{
            position: 'absolute', left: '50%', top: 12, transform: 'translateX(-50%)',
            width: 120, height: 36, borderRadius: 20, background: '#000',
          }}/>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <svg width="18" height="12" viewBox="0 0 18 12"><rect x="0" y="7" width="3" height="5" rx="0.8" fill={theme.text}/><rect x="5" y="4" width="3" height="8" rx="0.8" fill={theme.text}/><rect x="10" y="2" width="3" height="10" rx="0.8" fill={theme.text}/><rect x="15" y="0" width="3" height="12" rx="0.8" fill={theme.text}/></svg>
            <svg width="16" height="12" viewBox="0 0 16 12"><path d="M8 2C10.2 2 12.2 2.9 13.7 4.3L15 3C13 1 10.5 0 8 0S3 1 1 3L2.3 4.3C3.8 2.9 5.8 2 8 2z" fill={theme.text}/><path d="M8 6C9.1 6 10.1 6.5 10.8 7.2L12.2 5.8C11.1 4.7 9.6 4 8 4C6.4 4 4.9 4.7 3.8 5.8L5.2 7.2C5.9 6.5 6.9 6 8 6z" fill={theme.text}/><circle cx="8" cy="10" r="1.5" fill={theme.text}/></svg>
            <svg width="26" height="12" viewBox="0 0 26 12"><rect x="0.5" y="0.5" width="22" height="11" rx="3" stroke={theme.text} strokeOpacity="0.4" fill="none"/><rect x="2" y="2" width="19" height="8" rx="1.5" fill={theme.text}/><rect x="24" y="4" width="1.5" height="4" rx="0.5" fill={theme.text} fillOpacity="0.4"/></svg>
          </div>
        </div>
      ) : (
        <div style={{
          height: 38, display: 'flex', alignItems: 'center',
          justifyContent: 'space-between', padding: '0 20px',
          position: 'relative', flexShrink: 0, zIndex: 100, background: 'transparent',
        }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: theme.text, fontFamily: 'Roboto, sans-serif' }}>9:41</span>
          {/* Punch hole */}
          <div style={{
            position: 'absolute', left: '50%', top: 8, transform: 'translateX(-50%)',
            width: 22, height: 22, borderRadius: '50%', background: '#000',
          }}/>
          <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
            <svg width="14" height="10" viewBox="0 0 14 10"><path d="M7 8.5L1 3a8 8 0 0112 0L7 8.5z" fill={theme.text}/></svg>
            <svg width="14" height="10" viewBox="0 0 14 10"><path d="M13 9V1L1 9h12z" fill={theme.text}/></svg>
            <svg width="18" height="10" viewBox="0 0 18 10"><rect x="1" y="1" width="14" height="8" rx="2" stroke={theme.text} strokeWidth="1" fill="none"/><rect x="2.5" y="2.5" width="9" height="5" rx="1" fill={theme.text}/></svg>
          </div>
        </div>
      )}

      {/* Content */}
      <div style={{ flex: 1, position: 'relative', overflow: 'hidden', background: theme.bg }}>
        <ScreenRouter theme={theme} version={version} lang={lang} initial={screen} onScreenChange={onScreenChange}/>
      </div>

      {/* Nav bar */}
      {isIOS ? (
        <div style={{
          height: 34, display: 'flex', alignItems: 'flex-end', justifyContent: 'center',
          paddingBottom: 8, flexShrink: 0, zIndex: 100,
        }}>
          <div style={{ width: 135, height: 5, borderRadius: 2.5, background: theme.text, opacity: 0.4 }}/>
        </div>
      ) : (
        <div style={{
          height: 24, display: 'flex', alignItems: 'center', justifyContent: 'center',
          flexShrink: 0, zIndex: 100, background: 'transparent',
        }}>
          <div style={{ width: 108, height: 4, borderRadius: 2, background: theme.text, opacity: 0.4 }}/>
        </div>
      )}
    </div>
  );
};

// ─────────────── MAIN APP ───────────────
const App = () => {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const tweaks = t;

  // resolved dark mode - allow explicit dark tweak toggle
  const isDark = tweaks.mode === 'dark';

  // Load saved screen
  useEffect(() => {
    const saved = localStorage.getItem('mishwarak-screen');
    if (saved && saved !== tweaks.screen) {
      setTweak('screen', saved);
    }
  }, []);

  const setScreen = (s) => {
    localStorage.setItem('mishwarak-screen', s);
    setTweak('screen', s);
  };

  const screenLabels = {
    ar: {
      splash: 'شاشة البداية',
      onboarding: 'الترحيب',
      login: 'تسجيل الدخول',
      home: 'الرئيسية',
      search: 'البحث',
      vehicle: 'اختيار المركبة',
      finding: 'البحث عن سائق',
      active: 'الرحلة النشطة',
      rating: 'التقييم',
      wallet: 'المحفظة',
      history: 'الرحلات',
      profile: 'الملف الشخصي',
      notifs: 'الإشعارات',
    },
    en: {
      splash: 'Splash', onboarding: 'Onboarding', login: 'Login',
      home: 'Home', search: 'Search', vehicle: 'Choose ride',
      finding: 'Finding', active: 'Active ride', rating: 'Rating',
      wallet: 'Wallet', history: 'History', profile: 'Profile', notifs: 'Notifications',
    },
  }[tweaks.lang];

  return (
    <div style={{
      minHeight: '100vh',
      background: isDark
        ? 'radial-gradient(ellipse at top, #1a1a2e 0%, #0a0a15 60%)'
        : 'radial-gradient(ellipse at top, #f0f4f8 0%, #e2e8f0 60%)',
      display: 'flex', flexDirection: 'column', alignItems: 'center',
      padding: '40px 20px 60px',
      fontFamily: TYPO.arabic,
    }}>
      {/* Title */}
      <div style={{ textAlign: 'center', marginBottom: 32, maxWidth: 900 }}>
        <div style={{
          display: 'inline-block', padding: '4px 12px',
          background: isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.05)',
          borderRadius: 20, fontSize: 11, fontWeight: 700,
          color: isDark ? '#94a3b8' : '#64748b',
          letterSpacing: 0.5, marginBottom: 12,
        }}>
          Prototype · Aden, Yemen
        </div>
        <h1 style={{
          fontSize: 42, fontWeight: 900,
          color: isDark ? '#f1f5f9' : '#0f172a',
          margin: 0, letterSpacing: -1.5, fontFamily: TYPO.arabic,
        }}>
          مِشوارَك <span style={{ color: tweaks.version === 'A' ? '#00A651' : '#FF6B35' }}>·</span> Mishwarak
        </h1>
        <p style={{
          fontSize: 15, color: isDark ? '#94a3b8' : '#64748b',
          marginTop: 8, fontFamily: TYPO.arabic,
        }}>
          تطبيق توصيل الركاب — نموذج تفاعلي كامل
        </p>
        <a href="Flutter Developer Guide.html" style={{
          display: 'inline-flex', alignItems: 'center', gap: 8,
          marginTop: 16, padding: '10px 18px',
          background: isDark ? 'rgba(2, 86, 155, 0.2)' : 'rgba(2, 86, 155, 0.1)',
          border: `1.5px solid ${isDark ? 'rgba(2, 86, 155, 0.4)' : 'rgba(2, 86, 155, 0.3)'}`,
          color: isDark ? '#4FC3F7' : '#02569B',
          borderRadius: 12, fontSize: 13, fontWeight: 700,
          textDecoration: 'none', fontFamily: TYPO.arabic,
          transition: 'all 0.2s',
        }}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
            <path d="M14.314 0L2.3 12 6 15.7 21.684.013h-7.357zm.014 11.072L7.857 17.53l6.457 6.47H21.7l-6.46-6.468 6.46-6.46h-7.37z"/>
          </svg>
          دليل مطور Flutter/Dart · Developer Guide →
        </a>
      </div>

      {/* Screen navigator pills */}
      <div style={{
        display: 'flex', flexWrap: 'wrap', gap: 6, justifyContent: 'center',
        maxWidth: 900, marginBottom: 32,
      }}>
        {Object.entries(screenLabels).map(([k, v]) => (
          <button
            key={k}
            onClick={() => setScreen(k)}
            style={{
              padding: '7px 14px',
              background: tweaks.screen === k
                ? (tweaks.version === 'A' ? '#00A651' : '#FF6B35')
                : (isDark ? 'rgba(255,255,255,0.06)' : 'rgba(255,255,255,0.8)'),
              color: tweaks.screen === k ? 'white' : (isDark ? '#e2e8f0' : '#334155'),
              border: `1.5px solid ${tweaks.screen === k ? 'transparent' : (isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.06)')}`,
              borderRadius: 20, cursor: 'pointer',
              fontSize: 12, fontWeight: 700, fontFamily: TYPO.arabic,
              transition: 'all 0.2s',
              boxShadow: tweaks.screen === k ? '0 4px 12px rgba(0,0,0,0.15)' : 'none',
            }}
          >
            {v}
          </button>
        ))}
      </div>

      {/* Devices grid */}
      <div style={{
        display: 'flex', gap: 40, flexWrap: 'wrap', justifyContent: 'center',
        alignItems: 'flex-start',
      }}>
        {(tweaks.device === 'both' || tweaks.device === 'ios') && (
          <DeviceLabel label="iOS · iPhone 15 Pro" isDark={isDark}>
            <PhoneMockup device="ios" dark={isDark} version={tweaks.version} lang={tweaks.lang} screen={tweaks.screen} onScreenChange={setScreen}/>
          </DeviceLabel>
        )}
        {(tweaks.device === 'both' || tweaks.device === 'android') && (
          <DeviceLabel label="Android · Pixel 8" isDark={isDark}>
            <PhoneMockup device="android" dark={isDark} version={tweaks.version} lang={tweaks.lang} screen={tweaks.screen} onScreenChange={setScreen}/>
          </DeviceLabel>
        )}
      </div>

      {/* Info footer */}
      <div style={{
        marginTop: 60, maxWidth: 800, textAlign: 'center',
        fontSize: 13, color: isDark ? '#94a3b8' : '#64748b',
        lineHeight: 1.8, fontFamily: TYPO.arabic,
      }}>
        <strong style={{ color: isDark ? '#e2e8f0' : '#0f172a' }}>
          مقارنة بين تصميمين:
        </strong>
        <br/>
        <span style={{ color: '#00A651', fontWeight: 700 }}>النسخة A — كلاسيكية مطوّرة</span>: مستوحاة من Careem · لون أخضر · حواف ناعمة · تركيز على الوضوح.
        <br/>
        <span style={{ color: '#FF6B35', fontWeight: 700 }}>النسخة B — عصرية جريئة</span>: مستوحاة من Uber · لون برتقالي · حواف حادة · Typography كبير.
        <br/>
        <span style={{ fontSize: 11, opacity: 0.7 }}>
          افتح لوحة التعديلات (Tweaks) للتبديل بين النسختين، اللغة، الوضع، والجهاز.
        </span>
      </div>

      {/* Tweaks panel */}
      <TweaksPanel title="Tweaks · مِشوارَك">
        <TweakSection title="🎨 نسخة التصميم">
          <TweakRadio
            tweakKey="version"
            options={[
              { value: 'A', label: 'A · كلاسيكي' },
              { value: 'B', label: 'B · عصري' },
            ]}
          />
        </TweakSection>

        <TweakSection title="🌓 الوضع">
          <TweakRadio
            tweakKey="mode"
            options={[
              { value: 'light', label: '☀️ فاتح' },
              { value: 'dark', label: '🌙 داكن' },
            ]}
          />
        </TweakSection>

        <TweakSection title="🌐 اللغة">
          <TweakRadio
            tweakKey="lang"
            options={[
              { value: 'ar', label: 'عربي' },
              { value: 'en', label: 'English' },
            ]}
          />
        </TweakSection>

        <TweakSection title="📱 الجهاز">
          <TweakRadio
            tweakKey="device"
            options={[
              { value: 'android', label: 'Android' },
              { value: 'ios', label: 'iOS' },
              { value: 'both', label: 'كلاهما' },
            ]}
          />
        </TweakSection>

        <TweakSection title="🗺️ الشاشة">
          <TweakSelect
            tweakKey="screen"
            options={Object.entries(screenLabels).map(([k, v]) => ({ value: k, label: v }))}
          />
        </TweakSection>

        <TweakSuggestionBar suggestions={[
          'أضف شاشة لسحب رصيد المحفظة إلى بطاقة بنكية',
          'اجعل النسخة B تستخدم Glass morphism في الـ Bottom Sheet',
          'أضف طريقة دفع "الفلوس الإلكترونية" مثل الكريمي',
          'صمّم شاشة اختيار طريقة الدفع بشكل منفصل',
          'حسّن رسوم الخريطة لتبدو أكثر واقعية',
        ]}/>
      </TweaksPanel>
    </div>
  );
};

const DeviceLabel = ({ label, isDark, children }) => (
  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14 }}>
    {children}
    <div style={{
      padding: '6px 14px',
      background: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.8)',
      borderRadius: 12, fontSize: 11, fontWeight: 700,
      color: isDark ? '#94a3b8' : '#475569',
      fontFamily: 'Inter, sans-serif',
      letterSpacing: 0.5,
    }}>
      {label}
    </div>
  </div>
);

ReactDOM.createRoot(document.getElementById('root')).render(<App/>);
