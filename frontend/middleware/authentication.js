export default async ({ app, route, redirect, store }) => {
  function deleteAuthToken() {
    // token が正しくない場合、cookie から削除する
    app.$cookies.remove("token");
  }

  const publicPaths = [
    "/",
    "/users/new",
    "/signup",
    "/home",
    "/help",
    "/about",
    "/contact"
  ];

  const token = app.$cookies.get("token");
  // token があって sign in へアクセスされたときは dashboard へ
  if (
    token &&
    route.path == "/sessions/new" &&
    store.getters["auth/currentUser"]
  ) {
    const currentUser = store.getters["auth/currentUser"];
    redirect(`/users/${currentUser.id}/show`);
    return;
  }

  // cookie に何もなく sign in へ遷移するときは何もしない
  if (!token && route.path == "/sessions/new") {
    return;
  }

  if (process.server && !token && !publicPaths.includes(route.path)) {
    redirect("/sessions/new");
    return;
  }

  // リロード時にもcookieに正しいtokenがあれば'auth/currentUser'に常に

  // 正しい値をセットする
  if ((process.server && !store.getters["auth/currentUser"]) || "/") {
    try {
      const endpoint = "api/v1/token_current_user";
      const response = await app.$axios.$get(endpoint);
      const user = response.user;
      if (user == null) {
        deleteAuthToken();

        redirect("/sessions/new");
        return;
      }
      store.commit("auth/setCurrentUser", { user });
    } catch (e) {
      console.log("middleware/authentication: ", e);
      deleteAuthToken();
      redirect("/sessions/new");
      return;
    }
  }
};
