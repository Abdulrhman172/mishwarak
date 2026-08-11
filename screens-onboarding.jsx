// Screens: Splash, Onboarding, Auth
// ═══════════════════════════════════════════════════════════════

// ─────────────── SPLASH ───────────────
const SplashScreen = ({ theme, version, onDone, lang }) => {
  React.useEffect(() => {
    const t = setTimeout(onDone, 2200);
    return () => clearTimeout(t);
  }, []);
  const isB = version === 'B';
  return (
    <div style={{
      position: 'absolute', inset: 0,
      background: isB
        ? `linear-gradient(135deg, ${theme.primary} 0%, ${theme.primaryDark} 100%)`
        : theme.bg,
      display: 'flex', flexDirection: 'column',
      alignItems: 'center', justifyContent: 'center',
      overflow: 'hidden',
    }}>
      {/* Animated background blobs */}
      <div style={{
        position: 'absolute', width: 300, height: 300, borderRadius: '50%',
        background: isB ? 'rgba(255,255,255,0.1)' : theme.primary + '20',
        top: -100, right: -100,
        animation: 'float 4s ease-in-out infinite',
      }}/>
      <div style={{
        position: 'absolute', width: 250, height: 250, borderRadius: '50%',
        background: isB ? 'rgba(255,255,255,0.06)' : theme.primary + '15',
        bottom: -80, left: -80,
        animation: 'float 5s ease-in-out infinite reverse',
      }}/>

      {/* Logo */}
      <div style={{
        width: 120, height: 120, borderRadius: 32,
        background: isB ? 'white' : theme.primary,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        boxShadow: isB ? '0 20px 60px rgba(0,0,0,0.2)' : `0 20px 60px ${theme.primary}40`,
        animation: 'logoIn 0.8s cubic-bezier(0.34,1.56,0.64,1) both',
      }}>
        <svg width="72" height="72" viewBox="0 0 72 72">
          {/* Car mark */}
          <path d="M 12 42 L 12 32 Q 12 26 18 24 L 26 18 Q 32 15 38 15 L 52 15 Q 58 16 62 22 L 60 42 L 12 42 Z"
            fill={isB ? theme.primary : 'white'} />
          <circle cx="24" cy="46" r="6" fill={isB ? theme.primary : 'white'}/>
          <circle cx="52" cy="46" r="6" fill={isB ? theme.primary : 'white'}/>
          <path d="M 22 24 L 28 18 L 40 18 L 44 24 Z" fill={isB ? theme.primaryDark : theme.primary} opacity="0.7"/>
        </svg>
      </div>

      <div style={{
        marginTop: 28, fontSize: 40, fontWeight: 800,
        color: isB ? 'white' : theme.text,
        fontFamily: TYPO.arabic, letterSpacing: -1,
        animation: 'slideUp 0.8s 0.2s both',
      }}>
        {T('مِشوارَك', 'Mishwarak', lang)}
      </div>
      <div style={{
        marginTop: 8, fontSize: 15, fontWeight: 500,
        color: isB ? 'rgba(255,255,255,0.9)' : theme.textMuted,
        animation: 'slideUp 0.8s 0.35s both',
      }}>
        {T('رحلتك تبدأ من هنا', 'Your journey starts here', lang)}
      </div>

      {/* Loading dots */}
      <div style={{
        position: 'absolute', bottom: 80,
        display: 'flex', gap: 6,
      }}>
        {[0,1,2].map(i => (
          <div key={i} style={{
            width: 8, height: 8, borderRadius: '50%',
            background: isB ? 'white' : theme.primary,
            animation: `pulse 1.4s ${i * 0.2}s ease-in-out infinite`,
          }}/>
        ))}
      </div>

      <style>{`
        @keyframes float { 0%,100%{transform:translate(0,0)} 50%{transform:translate(20px,-20px)} }
        @keyframes logoIn { 0%{opacity:0;transform:scale(0.5) rotate(-10deg)} 100%{opacity:1;transform:scale(1) rotate(0)} }
        @keyframes slideUp { 0%{opacity:0;transform:translateY(20px)} 100%{opacity:1;transform:translateY(0)} }
        @keyframes pulse { 0%,100%{opacity:0.3;transform:scale(0.8)} 50%{opacity:1;transform:scale(1.2)} }
      `}</style>
    </div>
  );
};

// ─────────────── ONBOARDING ───────────────
const OnboardingScreen = ({ theme, version, onDone, lang }) => {
  const [step, setStep] = React.useState(0);
  const isB = version === 'B';
  const slides = [
    {
      title: T('اطلب مشوارك بضغطة زر', 'Order a ride in one tap', lang),
      subtitle: T('سائقين موثوقين في عدن حول ساعة، جاهزين لخدمتك', 'Trusted drivers in Aden, 24/7', lang),
      illustration: 'ride',
    },
    {
      title: T('اسعار شفافة قبل الرحلة', 'Transparent pricing upfront', lang),
      subtitle: T('اعرف السعر قبل تأكيد الطلب. بدون مفاجآت.', 'Know the price before you book. No surprises.', lang),
      illustration: 'price',
    },
    {
      title: T('أمانك اولويتنا', 'Your safety comes first', lang),
      subtitle: T('شارك رحلتك مع عائلتك، وزر SOS للطوارئ، وخيار سائقة للنساء', 'Share your trip, SOS button, women-only option', lang),
      illustration: 'safe',
    },
  ];
  const cur = slides[step];

  return (
    <div style={{
      position: 'absolute', inset: 0, background: theme.bg,
      display: 'flex', flexDirection: 'column',
    }}>
      {/* Skip button */}
      <div style={{ padding: '16px 20px', display: 'flex', justifyContent: 'flex-end' }}>
        <button onClick={onDone} style={{
          background: 'none', border: 'none', color: theme.textMuted,
          fontSize: 15, fontWeight: 600, cursor: 'pointer',
          fontFamily: TYPO.arabic,
        }}>
          {T('تخطي', 'Skip', lang)}
        </button>
      </div>

      {/* Illustration */}
      <div style={{
        flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: '20px 32px',
      }}>
        <OnboardingIllustration type={cur.illustration} theme={theme} version={version} />
      </div>

      {/* Content */}
      <div style={{ padding: '0 32px 24px', textAlign: 'center' }} key={step}>
        <div style={{
          fontSize: 26, fontWeight: 800, color: theme.text,
          fontFamily: TYPO.arabic, lineHeight: 1.3, letterSpacing: -0.5,
          animation: 'fadeUp 0.5s both',
        }}>
          {cur.title}
        </div>
        <div style={{
          marginTop: 12, fontSize: 15, color: theme.textMuted,
          fontFamily: TYPO.arabic, lineHeight: 1.6,
          animation: 'fadeUp 0.5s 0.1s both',
        }}>
          {cur.subtitle}
        </div>
      </div>

      {/* Dots */}
      <div style={{
        display: 'flex', justifyContent: 'center', gap: 8,
        padding: '0 0 24px',
      }}>
        {slides.map((_, i) => (
          <div key={i} onClick={() => setStep(i)} style={{
            width: step === i ? 24 : 8, height: 8, borderRadius: 4,
            background: step === i ? theme.primary : theme.border,
            transition: 'all 0.3s', cursor: 'pointer',
          }}/>
        ))}
      </div>

      {/* CTA */}
      <div style={{ padding: '0 24px 32px' }}>
        <button
          onClick={() => step < slides.length - 1 ? setStep(step + 1) : onDone()}
          style={{
            width: '100%', height: 56,
            background: theme.primary, color: 'white',
            border: 'none', borderRadius: isB ? 12 : 28,
            fontSize: 16, fontWeight: 700,
            cursor: 'pointer', fontFamily: TYPO.arabic,
            boxShadow: `0 8px 24px ${theme.primary}40`,
            transition: 'transform 0.15s',
          }}
          onMouseDown={e => e.currentTarget.style.transform = 'scale(0.97)'}
          onMouseUp={e => e.currentTarget.style.transform = 'scale(1)'}
        >
          {step < slides.length - 1 ? T('التالي', 'Next', lang) : T('يلا نبدأ', "Let's go", lang)}
        </button>
      </div>
      <style>{`@keyframes fadeUp { 0%{opacity:0;transform:translateY(15px)} 100%{opacity:1;transform:translateY(0)} }`}</style>
    </div>
  );
};

const OnboardingIllustration = ({ type, theme, version }) => {
  if (type === 'ride') {
    return (
      <div style={{ width: '100%', maxWidth: 320, position: 'relative' }}>
        <svg viewBox="0 0 320 260" width="100%">
          {/* Ground */}
          <ellipse cx="160" cy="230" rx="140" ry="15" fill={theme.primary} opacity="0.08"/>
          {/* Road */}
          <path d="M 30 220 L 290 220" stroke={theme.textLight} strokeWidth="2" strokeDasharray="8 6" opacity="0.4"/>
          {/* Buildings back */}
          <rect x="20" y="80" width="30" height="120" fill={theme.textMuted} opacity="0.15" rx="2"/>
          <rect x="55" y="60" width="35" height="140" fill={theme.textMuted} opacity="0.2" rx="2"/>
          <rect x="240" y="70" width="40" height="130" fill={theme.textMuted} opacity="0.18" rx="2"/>
          <rect x="285" y="90" width="25" height="110" fill={theme.textMuted} opacity="0.12" rx="2"/>
          {/* Phone */}
          <rect x="120" y="30" width="80" height="150" rx="12" fill={theme.text}/>
          <rect x="125" y="42" width="70" height="120" rx="4" fill={theme.surface}/>
          <circle cx="160" cy="170" r="4" fill={theme.textMuted}/>
          {/* Mini map on phone */}
          <path d="M 130 60 Q 160 55 190 65" stroke={theme.primary} strokeWidth="2" fill="none"/>
          <circle cx="132" cy="61" r="3" fill={theme.primary}/>
          <circle cx="188" cy="65" r="3" fill={theme.danger}/>
          <rect x="132" y="80" width="56" height="8" rx="2" fill={theme.textMuted} opacity="0.3"/>
          <rect x="132" y="94" width="40" height="6" rx="2" fill={theme.textMuted} opacity="0.2"/>
          {/* CTA in phone */}
          <rect x="132" y="140" width="56" height="14" rx="7" fill={theme.primary}/>
          {/* Car icon zoom */}
          <g transform="translate(160 200)">
            <circle r="30" fill={theme.primary} opacity="0.15"/>
            <path d="M -20 5 L -20 -3 Q -20 -8 -14 -10 L -6 -14 Q 0 -16 6 -16 L 14 -16 Q 20 -14 22 -8 L 20 5 Z" fill={theme.primary}/>
            <circle cx="-13" cy="7" r="4" fill={theme.text}/>
            <circle cx="15" cy="7" r="4" fill={theme.text}/>
          </g>
          {/* Ping */}
          <circle cx="160" cy="200" r="35" fill="none" stroke={theme.primary} strokeWidth="1.5" opacity="0.5">
            <animate attributeName="r" values="30;50;30" dur="2s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0.5;0;0.5" dur="2s" repeatCount="indefinite"/>
          </circle>
        </svg>
      </div>
    );
  }
  if (type === 'price') {
    return (
      <div style={{ width: '100%', maxWidth: 300 }}>
        <svg viewBox="0 0 300 260" width="100%">
          <ellipse cx="150" cy="240" rx="120" ry="10" fill={theme.primary} opacity="0.08"/>
          {/* Receipt */}
          <rect x="70" y="30" width="160" height="200" rx="10" fill={theme.surfaceElev} stroke={theme.border} strokeWidth="1.5"/>
          <path d="M 70 220 L 78 230 L 90 220 L 102 230 L 114 220 L 126 230 L 138 220 L 150 230 L 162 220 L 174 230 L 186 220 L 198 230 L 210 220 L 222 230 L 230 220" stroke={theme.border} strokeWidth="1.5" fill="none"/>
          {/* Header */}
          <rect x="90" y="50" width="80" height="10" rx="3" fill={theme.text}/>
          <rect x="90" y="66" width="50" height="6" rx="2" fill={theme.textMuted} opacity="0.5"/>
          {/* Lines */}
          <line x1="85" y1="90" x2="215" y2="90" stroke={theme.border} strokeDasharray="3 3"/>
          <rect x="90" y="100" width="60" height="8" rx="2" fill={theme.textMuted} opacity="0.4"/>
          <rect x="180" y="100" width="30" height="8" rx="2" fill={theme.text}/>
          <rect x="90" y="120" width="80" height="8" rx="2" fill={theme.textMuted} opacity="0.4"/>
          <rect x="180" y="120" width="30" height="8" rx="2" fill={theme.text}/>
          <rect x="90" y="140" width="70" height="8" rx="2" fill={theme.textMuted} opacity="0.4"/>
          <rect x="180" y="140" width="30" height="8" rx="2" fill={theme.text}/>
          <line x1="85" y1="165" x2="215" y2="165" stroke={theme.border}/>
          {/* Total */}
          <rect x="90" y="180" width="45" height="14" rx="3" fill={theme.text}/>
          <rect x="165" y="178" width="45" height="18" rx="4" fill={theme.primary}/>
          {/* Coins around */}
          <g transform="translate(45 90)">
            <circle r="18" fill={theme.accent}/>
            <text y="5" fontSize="16" fontFamily="sans-serif" fontWeight="bold" textAnchor="middle" fill={theme.text}>﷼</text>
          </g>
          <g transform="translate(255 130)">
            <circle r="14" fill={theme.accent}/>
            <text y="5" fontSize="14" fontFamily="sans-serif" fontWeight="bold" textAnchor="middle" fill={theme.text}>﷼</text>
          </g>
          <g transform="translate(250 60)">
            <circle r="10" fill={theme.accent} opacity="0.7"/>
          </g>
          {/* Check badge */}
          <circle cx="230" cy="30" r="18" fill={theme.success}/>
          <path d="M 222 30 L 228 36 L 240 24" stroke="white" strokeWidth="3" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      </div>
    );
  }
  // safe
  return (
    <div style={{ width: '100%', maxWidth: 300 }}>
      <svg viewBox="0 0 300 260" width="100%">
        <ellipse cx="150" cy="240" rx="120" ry="10" fill={theme.primary} opacity="0.08"/>
        {/* Shield big */}
        <path d="M 150 30 L 220 55 L 220 130 Q 220 190 150 220 Q 80 190 80 130 L 80 55 Z"
          fill={theme.primary} opacity="0.15"/>
        <path d="M 150 45 L 205 65 L 205 130 Q 205 180 150 205 Q 95 180 95 130 L 95 65 Z"
          fill={theme.primary}/>
        {/* Check in shield */}
        <path d="M 125 130 L 145 150 L 180 110" stroke="white" strokeWidth="6" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
        {/* Floating icons around */}
        <g transform="translate(60 80)">
          <circle r="22" fill={theme.surfaceElev} stroke={theme.border} strokeWidth="1.5"/>
          <path d="M -8 0 Q -8 -6 -2 -6 L 6 -6 L 10 -2 L 10 4 L -8 4 Z" fill={theme.danger}/>
          <text y="10" fontSize="8" fontWeight="bold" textAnchor="middle" fill={theme.text}>SOS</text>
        </g>
        <g transform="translate(240 90)">
          <circle r="22" fill={theme.surfaceElev} stroke={theme.border} strokeWidth="1.5"/>
          <path d="M -6 -6 L 6 -6 L 8 -2 L 4 8 L -4 8 L -8 -2 Z" fill={theme.secondary}/>
          <circle cx="0" cy="-2" r="2" fill="white"/>
        </g>
        <g transform="translate(55 200)">
          <circle r="20" fill={theme.surfaceElev} stroke={theme.border} strokeWidth="1.5"/>
          <circle cx="0" cy="-3" r="5" fill={theme.accent}/>
          <path d="M -8 8 Q 0 3 8 8" stroke={theme.accent} strokeWidth="3" fill="none" strokeLinecap="round"/>
        </g>
        <g transform="translate(245 195)">
          <circle r="20" fill={theme.surfaceElev} stroke={theme.border} strokeWidth="1.5"/>
          <circle cx="0" cy="0" r="7" fill={theme.success}/>
          <path d="M -4 0 L -1 3 L 4 -3" stroke="white" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
        </g>
      </svg>
    </div>
  );
};

// ─────────────── LOGIN ───────────────
const LoginScreen = ({ theme, version, onDone, lang }) => {
  const [phone, setPhone] = React.useState('');
  const [otpMode, setOtpMode] = React.useState(false);
  const [otp, setOtp] = React.useState(['','','','']);
  const isB = version === 'B';

  const sendOtp = () => phone.length >= 9 && setOtpMode(true);
  const verify = () => otp.every(d => d) && onDone();

  return (
    <div style={{
      position: 'absolute', inset: 0, background: theme.bg,
      display: 'flex', flexDirection: 'column',
      padding: '20px 24px',
    }}>
      {otpMode && (
        <button onClick={() => setOtpMode(false)} style={{
          background: theme.surface, border: 'none', color: theme.text,
          width: 40, height: 40, borderRadius: '50%',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer', marginBottom: 20,
        }}>
          <Icon name="back" size={20} />
        </button>
      )}

      {/* Header */}
      <div style={{ marginTop: otpMode ? 8 : 40 }}>
        <div style={{
          width: 64, height: 64, borderRadius: 18,
          background: theme.primary,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: `0 12px 32px ${theme.primary}40`,
          marginBottom: 24,
        }}>
          <Icon name={otpMode ? "message" : "phone"} color="white" size={28} strokeWidth={2}/>
        </div>
        <div style={{
          fontSize: 26, fontWeight: 800, color: theme.text,
          fontFamily: TYPO.arabic, letterSpacing: -0.5,
        }}>
          {otpMode
            ? T('أدخل رمز التحقق', 'Enter verification code', lang)
            : T('أهلاً بك في مشوارك', 'Welcome to Mishwarak', lang)}
        </div>
        <div style={{
          marginTop: 8, fontSize: 14, color: theme.textMuted,
          fontFamily: TYPO.arabic, lineHeight: 1.6,
        }}>
          {otpMode
            ? T(`أرسلنا رمزاً مكوناً من 4 أرقام إلى ${phone}`, `We sent a 4-digit code to ${phone}`, lang)
            : T('سجّل دخولك برقم جوالك للبدء', 'Sign in with your phone number', lang)}
        </div>
      </div>

      {/* Input */}
      <div style={{ marginTop: 32 }}>
        {!otpMode ? (
          <div>
            <div style={{
              fontSize: 12, fontWeight: 600, color: theme.textMuted,
              marginBottom: 8, letterSpacing: 0.5,
            }}>
              {T('رقم الجوال', 'PHONE NUMBER', lang)}
            </div>
            <div style={{
              display: 'flex', alignItems: 'center', gap: 8,
              background: theme.surface, borderRadius: 14,
              padding: '4px 4px 4px 16px',
              border: `1.5px solid ${theme.border}`,
            }}>
              <div style={{
                display: 'flex', alignItems: 'center', gap: 6,
                padding: '12px 12px 12px 4px',
                borderInlineEnd: `1px solid ${theme.border}`,
              }}>
                <span style={{ fontSize: 18 }}>🇾🇪</span>
                <span style={{ fontSize: 15, fontWeight: 600, color: theme.text }}>+967</span>
              </div>
              <input
                type="tel"
                value={phone}
                onChange={e => setPhone(e.target.value.replace(/\D/g,'').slice(0,9))}
                placeholder="7X XXX XXXX"
                style={{
                  flex: 1, border: 'none', background: 'transparent',
                  fontSize: 17, fontWeight: 600, color: theme.text,
                  outline: 'none', padding: '12px 0',
                  fontFamily: TYPO.english, direction: 'ltr',
                }}
              />
            </div>
          </div>
        ) : (
          <div style={{ display: 'flex', gap: 12, direction: 'ltr' }}>
            {otp.map((d, i) => (
              <input
                key={i}
                inputMode="numeric"
                maxLength={1}
                value={d}
                onChange={e => {
                  const v = e.target.value.replace(/\D/g,'');
                  const next = [...otp]; next[i] = v; setOtp(next);
                  if (v && i < 3) document.getElementById(`otp-${i+1}`)?.focus();
                }}
                id={`otp-${i}`}
                style={{
                  flex: 1, aspectRatio: '1', textAlign: 'center',
                  border: `2px solid ${d ? theme.primary : theme.border}`,
                  background: theme.surface, borderRadius: 14,
                  fontSize: 26, fontWeight: 700, color: theme.text,
                  outline: 'none', transition: 'border-color 0.2s',
                }}
              />
            ))}
          </div>
        )}
      </div>

      {/* Resend */}
      {otpMode && (
        <div style={{ textAlign: 'center', marginTop: 20 }}>
          <span style={{ fontSize: 13, color: theme.textMuted, fontFamily: TYPO.arabic }}>
            {T('لم يصلك الرمز؟ ', "Didn't get the code? ", lang)}
          </span>
          <button style={{
            background: 'none', border: 'none', color: theme.primary,
            fontSize: 13, fontWeight: 700, cursor: 'pointer',
            fontFamily: TYPO.arabic,
          }}>
            {T('إعادة الإرسال', 'Resend', lang)}
          </button>
        </div>
      )}

      <div style={{ flex: 1 }}/>

      {/* CTA */}
      <button
        onClick={otpMode ? verify : sendOtp}
        style={{
          width: '100%', height: 56,
          background: (otpMode ? otp.every(d=>d) : phone.length >= 9) ? theme.primary : theme.border,
          color: 'white', border: 'none',
          borderRadius: isB ? 12 : 28,
          fontSize: 16, fontWeight: 700,
          cursor: 'pointer', fontFamily: TYPO.arabic,
          transition: 'all 0.2s',
          boxShadow: `0 8px 20px ${theme.primary}30`,
        }}
      >
        {otpMode ? T('تحقق ومتابعة', 'Verify & Continue', lang) : T('إرسال الرمز', 'Send Code', lang)}
      </button>

      {/* Terms */}
      {!otpMode && (
        <div style={{
          marginTop: 16, textAlign: 'center',
          fontSize: 11, color: theme.textLight,
          fontFamily: TYPO.arabic, lineHeight: 1.7,
          paddingBottom: 8,
        }}>
          {T('بمتابعتك، فإنك توافق على ', 'By continuing, you agree to our ', lang)}
          <span style={{ color: theme.primary, fontWeight: 600 }}>
            {T('الشروط وسياسة الخصوصية', 'Terms & Privacy Policy', lang)}
          </span>
        </div>
      )}
    </div>
  );
};

Object.assign(window, { SplashScreen, OnboardingScreen, LoginScreen });
