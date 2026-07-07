"use client";

import { useState } from "react";

type DiaryEntry = {
  id: string;
  content: string;
  sentiment: string | null;
  sentimentScore: number | null;
  aiResponse: string | null;
  keywords: string[];
  createdAt: string;
};

export default function DiaryEditor({
  onNewEntry,
}: {
  onNewEntry: (entry: DiaryEntry) => void;
}) {
  const [content, setContent] = useState("");
  const [loading, setLoading] = useState(false);
  const [showResponse, setShowResponse] = useState(false);
  const [latestResponse, setLatestResponse] = useState<DiaryEntry | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!content.trim() || loading) return;

    setLoading(true);
    setShowResponse(false);

    try {
      const res = await fetch("/api/diary", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content }),
      });

      if (res.ok) {
        const newEntry = await res.json();
        setLatestResponse(newEntry);
        setShowResponse(true);
        onNewEntry(newEntry);
        setContent("");

        // 3초 후 일기 목록으로 부드럽게 스크롤
        setTimeout(() => {
          window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
        }, 3000);
      } else {
        alert("일기 저장에 실패했습니다");
      }
    } catch (error) {
      console.error("Failed to save diary:", error);
      alert("일기 저장 중 오류가 발생했습니다");
    } finally {
      setLoading(false);
    }
  };

  const getSentimentColor = (sentiment: string | null) => {
    switch (sentiment) {
      case "positive":
        return "text-sentiment-positive";
      case "negative":
        return "text-sentiment-negative";
      default:
        return "text-sentiment-neutral";
    }
  };

  const getSentimentEmoji = (sentiment: string | null) => {
    switch (sentiment) {
      case "positive":
        return "😊";
      case "negative":
        return "😢";
      default:
        return "😐";
    }
  };

  return (
    <div className="space-y-6">
      {/* Editor Card */}
      <div className="bg-white rounded-2xl shadow-lg p-6 space-y-4">
        <h2 className="text-lg font-semibold text-foreground/80">
          ✍️ 오늘의 이야기
        </h2>

        <form onSubmit={handleSubmit} className="space-y-4">
          <textarea
            value={content}
            onChange={(e) => setContent(e.target.value)}
            placeholder="오늘 하루는 어떠셨나요? 당신의 이야기를 들려주세요..."
            className="w-full min-h-[200px] p-4 border-2 border-foreground/10 rounded-xl focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none resize-none transition-all"
            disabled={loading}
          />

          <div className="flex justify-end">
            <button
              type="submit"
              disabled={!content.trim() || loading}
              className="px-6 py-3 bg-gradient-to-r from-primary-600 to-secondary-600 text-white rounded-lg font-medium hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? "분석 중..." : "일기 저장하기"}
            </button>
          </div>
        </form>
      </div>

      {/* AI Response Card */}
      {showResponse && latestResponse && (
        <div className="bg-white rounded-2xl shadow-lg p-6 space-y-4 animate-slide-up">
          <div className="flex items-center gap-2">
            <span className="text-2xl">
              {getSentimentEmoji(latestResponse.sentiment)}
            </span>
            <h3 className="text-lg font-semibold">AI 분석 결과</h3>
          </div>

          {/* Sentiment */}
          <div className="flex items-center gap-2">
            <span className="text-sm text-foreground/60">감정:</span>
            <span
              className={`font-medium ${getSentimentColor(
                latestResponse.sentiment
              )}`}
            >
              {latestResponse.sentiment === "positive"
                ? "긍정적"
                : latestResponse.sentiment === "negative"
                ? "부정적"
                : "중립적"}
            </span>
            {latestResponse.sentimentScore !== null && (
              <span className="text-sm text-foreground/40">
                ({latestResponse.sentimentScore.toFixed(2)})
              </span>
            )}
          </div>

          {/* Keywords */}
          {latestResponse.keywords && latestResponse.keywords.length > 0 && (
            <div className="flex flex-wrap gap-2">
              {latestResponse.keywords.map((keyword, idx) => (
                <span
                  key={idx}
                  className="px-3 py-1 bg-primary-100 text-primary-700 rounded-full text-sm"
                >
                  #{keyword}
                </span>
              ))}
            </div>
          )}

          {/* AI Response */}
          {latestResponse.aiResponse && (
            <div className="p-4 bg-secondary-50 rounded-xl">
              <p className="text-foreground/80 leading-relaxed font-accent">
                {latestResponse.aiResponse}
              </p>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
