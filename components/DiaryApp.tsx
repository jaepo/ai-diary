"use client";

import { useState, useEffect } from "react";
import { signOut } from "next-auth/react";
import DiaryEditor from "./DiaryEditor";
import DiaryList from "./DiaryList";

type User = {
  id?: string;
  name?: string | null;
  email?: string | null;
  image?: string | null;
};

type DiaryEntry = {
  id: string;
  content: string;
  sentiment: string | null;
  sentimentScore: number | null;
  aiResponse: string | null;
  keywords: string[];
  createdAt: string;
};

export default function DiaryApp({ user }: { user: User }) {
  const [entries, setEntries] = useState<DiaryEntry[]>([]);
  const [loading, setLoading] = useState(true);

  // 일기 목록 불러오기
  const fetchEntries = async () => {
    try {
      const res = await fetch("/api/diary");
      if (res.ok) {
        const data = await res.json();
        setEntries(data);
      }
    } catch (error) {
      console.error("Failed to fetch entries:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchEntries();
  }, []);

  // 새 일기 추가
  const handleNewEntry = (newEntry: DiaryEntry) => {
    setEntries([newEntry, ...entries]);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-50 via-background to-secondary-50">
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-sm border-b border-foreground/10 sticky top-0 z-10">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <h1 className="text-2xl font-bold bg-gradient-to-r from-primary-600 to-secondary-600 bg-clip-text text-transparent">
            AI 일기장
          </h1>
          <div className="flex items-center gap-4">
            <div className="text-sm text-foreground/70">
              {user.name || user.email}
            </div>
            <button
              onClick={() => signOut()}
              className="text-sm text-foreground/60 hover:text-foreground transition-colors"
            >
              로그아웃
            </button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        {/* Diary Editor */}
        <DiaryEditor onNewEntry={handleNewEntry} />

        {/* Diary List */}
        <div className="space-y-4">
          <h2 className="text-xl font-semibold text-foreground/80">
            📖 나의 일기
          </h2>
          {loading ? (
            <div className="text-center py-12 text-foreground/50">
              불러오는 중...
            </div>
          ) : (
            <DiaryList entries={entries} />
          )}
        </div>
      </main>
    </div>
  );
}
