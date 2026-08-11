// Design System - Mishwarak App
// ═══════════════════════════════════════════════════════════════
// نظام التصميم الموحد لتطبيق مشوارك

const MISHWARAK = {
  // ─── Version A: Classic Refined (Careem-inspired) ───
  versionA: {
    light: {
      primary: '#00A651',       // أخضر مشوارك (نضارة وحيوية)
      primaryDark: '#008A44',
      secondary: '#004E89',
      accent: '#FFC300',
      bg: '#FFFFFF',
      surface: '#F7F8FA',
      surfaceElev: '#FFFFFF',
      text: '#0F1420',
      textMuted: '#6B7280',
      textLight: '#9CA3AF',
      border: '#E5E7EB',
      success: '#10B981',
      danger: '#EF4444',
      warning: '#F59E0B',
      mapBg: '#E8EEF3',
      mapRoad: '#FFFFFF',
      mapWater: '#D6E4F0',
    },
    dark: {
      primary: '#00C853',
      primaryDark: '#00A651',
      secondary: '#4A90E2',
      accent: '#FFD54F',
      bg: '#0A0E1A',
      surface: '#141826',
      surfaceElev: '#1C2233',
      text: '#F5F7FA',
      textMuted: '#9AA3B2',
      textLight: '#6B7280',
      border: '#252B3B',
      success: '#10B981',
      danger: '#EF4444',
      warning: '#F59E0B',
      mapBg: '#1A2030',
      mapRoad: '#2A3245',
      mapWater: '#0F1826',
    },
  },
  // ─── Version B: Bold Modern (Uber-inspired) ───
  versionB: {
    light: {
      primary: '#FF6B35',       // برتقالي جريء
      primaryDark: '#E85826',
      secondary: '#1A1F36',
      accent: '#FFB800',
      bg: '#FAFAFA',
      surface: '#FFFFFF',
      surfaceElev: '#FFFFFF',
      text: '#0F1420',
      textMuted: '#6B7280',
      textLight: '#9CA3AF',
      border: '#EAECEF',
      success: '#00A651',
      danger: '#E11D48',
      warning: '#F59E0B',
      mapBg: '#F1EDE4',
      mapRoad: '#FFFFFF',
      mapWater: '#CFE0EC',
    },
    dark: {
      primary: '#FF7A45',
      primaryDark: '#FF6B35',
      secondary: '#F5F5F7',
      accent: '#FFB800',
      bg: '#000000',
      surface: '#0E0E10',
      surfaceElev: '#1A1A1D',
      text: '#FFFFFF',
      textMuted: '#A0A0A8',
      textLight: '#6B6B75',
      border: '#26262A',
      success: '#00C853',
      danger: '#FF3B5C',
      warning: '#FFB800',
      mapBg: '#0F0F12',
      mapRoad: '#252528',
      mapWater: '#0A0A0C',
    },
  },
};

// Typography
const TYPO = {
  arabic: '"IBM Plex Sans Arabic", "Cairo", -apple-system, system-ui, sans-serif',
  english: '"Inter", -apple-system, system-ui, sans-serif',
  mono: '"SF Mono", "JetBrains Mono", monospace',
};

// Spacing scale
const SP = {
  xs: 4, sm: 8, md: 12, lg: 16, xl: 20, xxl: 24, xxxl: 32,
};

// Radius scale
const R = {
  sm: 8, md: 12, lg: 16, xl: 20, xxl: 24, full: 9999,
};

// Get current theme
function getTheme(version = 'A', mode = 'light') {
  const v = version === 'A' ? MISHWARAK.versionA : MISHWARAK.versionB;
  return mode === 'dark' ? v.dark : v.light;
}

// Bilingual text helper
function T(ar, en, lang = 'ar') {
  return lang === 'ar' ? ar : en;
}

Object.assign(window, { MISHWARAK, TYPO, SP, R, getTheme, T });
