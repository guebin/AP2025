#!/bin/bash

echo "📚 Building and publishing Quarto project with both HTML and Reveal.js formats..."

# Enable output-dir for publishing
echo "⚙️ Enabling output-dir for publishing..."
sed -i.bak 's/# output-dir: docs  # 개발시 주석처리, 배포시 주석해제/output-dir: docs/' _quarto.yml

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf docs/
mkdir -p docs

# Render HTML format
echo "🌐 Rendering HTML format..."
quarto render --to html

# Check if HTML build was successful
if [ $? -ne 0 ]; then
    echo "❌ HTML build failed!"
    exit 1
fi

echo "✅ HTML build completed successfully"

# Render Reveal.js format to slides subdirectory
echo "📊 Rendering Reveal.js format..."

# Create slides directory
mkdir -p docs/slides

# Render each post as Reveal.js slides
for file in posts/*.ipynb posts/*.qmd; do
    if [ -f "$file" ]; then
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        echo "   📄 Processing $filename..."
        quarto render "$file" --to revealjs --output "docs/slides/$filename.html"
    fi
done

# Also render any standalone qmd files as slides
for file in *.qmd; do
    if [ -f "$file" ] && [ "$file" != "index.qmd" ]; then
        filename=$(basename "$file" .qmd)
        echo "   📄 Processing $filename..."
        quarto render "$file" --to revealjs --output "docs/slides/$filename.html"
    fi
done

echo "✅ Reveal.js slides build completed successfully"

# Create index page for slides
echo "📋 Creating slides index page..."
cat > docs/slides/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고급확률론 (2025) - 슬라이드</title>
    <style>
        body { font-family: 'Nanum Myeongjo', serif; margin: 40px; }
        h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .slide-list { list-style: none; padding: 0; }
        .slide-item { margin: 15px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .slide-item a { text-decoration: none; color: #3498db; font-weight: bold; }
        .slide-item a:hover { color: #2980b9; }
        .back-link { margin-top: 30px; }
        .back-link a { background: #3498db; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>🎯 고급확률론 (2025) - 슬라이드</h1>
    <ul class="slide-list">
EOF

# Add links to all slide files
for file in docs/slides/*.html; do
    if [ -f "$file" ] && [ "$(basename "$file")" != "index.html" ]; then
        filename=$(basename "$file" .html)
        echo "        <li class=\"slide-item\"><a href=\"$filename.html\">📊 $filename</a></li>" >> docs/slides/index.html
    fi
done

cat >> docs/slides/index.html << 'EOF'
    </ul>
    <div class="back-link">
        <a href="../index.html">🏠 메인 페이지로 돌아가기</a>
    </div>
</body>
</html>
EOF

# Check if we're in a git repository and commit if requested
if [ -d ".git" ]; then
    echo "📤 Git repository detected. Checking status..."
    
    # Check if there are changes to commit
    if [ -n "$(git status --porcelain)" ]; then
        echo "📝 Changes detected. Adding files to git..."
        git add docs/
        
        # Commit with timestamp
        commit_message="Update site: $(date '+%Y-%m-%d %H:%M:%S')"
        git commit -m "$commit_message"
        echo "✅ Changes committed: $commit_message"
        
        # Ask if user wants to push (commented out for safety)
        # echo "🚀 Push to remote? (y/n)"
        # read -r response
        # if [[ "$response" =~ ^[Yy]$ ]]; then
        #     git push
        #     echo "✅ Pushed to remote repository"
        # fi
    else
        echo "ℹ️  No changes to commit"
    fi
fi

# Restore development mode
echo "🔄 Restoring development mode..."
sed -i.bak 's/output-dir: docs/# output-dir: docs  # 개발시 주석처리, 배포시 주석해제/' _quarto.yml
rm -f _quarto.yml.bak

echo ""
echo "🎉 Build completed successfully!"
echo "📄 HTML site: docs/index.html"
echo "🎯 Slides: docs/slides/index.html"
echo ""
echo "To serve locally:"
echo "  cd docs && python3 -m http.server 8000"
echo "  Then visit: http://localhost:8000"