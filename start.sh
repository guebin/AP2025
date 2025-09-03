#!/bin/bash

echo "📚 Quarto 미리보기 시작"

# 기존 프로세스 정리
pkill -f "quarto preview" || true
sleep 1

# 캐시 정리
rm -rf .quarto

echo ""
echo "미리보기 방식:"
echo "1) HTML 웹사이트 (전체 프로젝트)"  
echo "2) Reveal.js 슬라이드 (01wk.ipynb만)"
read -p "선택 (1-2): " choice

if [ "$choice" = "2" ]; then
    echo "📊 01wk.ipynb Reveal.js 슬라이드 미리보기..."
    cd posts
    quarto preview 01wk.ipynb --to revealjs --no-browser
    echo "🌐 브라우저에서 http://localhost:XXXX 를 열어주세요"
else
    echo "🌐 HTML 웹사이트 미리보기..."
    # _site 디렉토리 생성
    mkdir -p _site
    # 먼저 한번 렌더링 (오류 무시)
    quarto render 2>/dev/null || true
    # 그다음 미리보기
    echo "🌐 미리보기 시작... (초기 오류 메시지는 무시해도 됩니다)"
    quarto preview --no-browser
fi