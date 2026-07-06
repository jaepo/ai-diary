"use client";

type DiaryEntry = {
  id: string;
  content: string;
  sentiment: string | null;
  sentimentScore: number | null;
  aiResponse: string | null;
  keywords: string[];
  createdAt: string;
};

export default function DiaryList({ entries }: { entries: DiaryEntry[] }) {
  if (entries.length === 0) {
    return (
      <div className="bg-white rounded-2xl shadow-lg p-12 text-center">
        <p className="text-foreground/40">
          아직 작성한 일기가 없습니다.
          <br />첫 일기를 작성해보세요!
        </p>
      </div>
    );
  }

  const getSentimentColor = (sentiment: string | null) => {
    switch (sentiment) {
      case "positive":
        return "border-sentiment-positive bg-sentiment-positive-light";
      case "negative":
        return "border-sentiment-negative bg-sentiment-negative-light";
      default:
        return "border-sentiment-neutral bg-sentiment-neutral-light";
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

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat("ko-KR", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    }).format(date);
  };

  return (
    <div className="space-y-4">
      {entries.map((entry, index) => (
        <div
          key={entry.id}
          className={`bg-white rounded-2xl shadow-lg p-6 space-y-4 border-l-4 ${getSentimentColor(
            entry.sentiment
          )} animate-fade-in`}
          style={{ animationDelay: `${index * 0.1}s` }}
        >
          {/* Header */}
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="text-2xl">{getSentimentEmoji(entry.sentiment)}</span>
              <span className="text-sm text-foreground/60 font-mono">
                {formatDate(entry.createdAt)}
              </span>
            </div>
            {entry.sentimentScore !== null && (
              <span className="text-xs text-foreground/40 font-mono">
                Score: {entry.sentimentScore.toFixed(2)}
              </span>
            )}
          </div>

          {/* Content */}
          <p className="text-foreground/80 leading-relaxed whitespace-pre-wrap">
            {entry.content}
          </p>

          {/* Keywords */}
          {entry.keywords && entry.keywords.length > 0 && (
            <div className="flex flex-wrap gap-2">
              {entry.keywords.map((keyword, idx) => (
                <span
                  key={idx}
                  className="px-2 py-1 bg-primary-100 text-primary-700 rounded-full text-xs"
                >
                  #{keyword}
                </span>
              ))}
            </div>
          )}

          {/* AI Response */}
          {entry.aiResponse && (
            <div className="p-4 bg-secondary-50 rounded-xl border-l-2 border-secondary-500">
              <p className="text-sm text-foreground/70 mb-1">💬 AI의 응답:</p>
              <p className="text-foreground/80 leading-relaxed font-accent">
                {entry.aiResponse}
              </p>
            </div>
          )}
        </div>
      ))}
    </div>
  );
}
