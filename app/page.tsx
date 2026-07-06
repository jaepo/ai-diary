import { auth } from "@/auth";
import DiaryApp from "@/components/DiaryApp";
import LoginPage from "@/components/LoginPage";

export default async function Home() {
  const session = await auth();

  if (!session) {
    return <LoginPage />;
  }

  return <DiaryApp user={session.user} />;
}
