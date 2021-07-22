export const state = () => ({
  currentUser: null
});

export const getters = {
  currentUser: state => state.currentUser
};

export const mutations = {
  setCurrentUser(state, { user }) {
    state.currentUser = user;
  }
};

export const actions = {
  async signIn({ commit }, { email, password }) {
    const endpoint = "api/v1/login";
    const payload = {
      email: email,
      password: password
    };
    const response = await this.$axios.$post(endpoint, payload);
    const token = response.token;
    const user = response.user;
    this.$cookies.set("token", token);
    commit("setCurrentUser", { user });
    return response;
  }
};
