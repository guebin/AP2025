#!/bin/bash

echo "📚 Quarto 간단 미리보기"

# 기존 프로세스 정리
pkill -f "quarto preview" || true
sleep 1

# 임시 파일 정리
rm -rf .quarto _site site_libs index.html index-listing.json

echo ""
echo "미리보기할 파일을 선택하세요:"
echo "1) index.qmd (HTML 웹사이트)"
echo "2) posts/01wk.ipynb (Reveal.js 슬라이드)"
read -p "선택 (1-2): " choice

if [ "$choice" = "2" ]; then
    echo "📊 01wk.ipynb를 Reveal.js 슬라이드로 미리보기..."
    cd posts
    quarto preview 01wk.ipynb --to revealjs
else
    echo "🌐 index.qmd를 HTML로 미리보기..."
    quarto preview index.qmd --to html
fi