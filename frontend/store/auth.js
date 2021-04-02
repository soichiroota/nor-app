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
    let user = response.user;
    this.$cookies.set("token", token);
    commit("setCurrentUser", { user });
    return response;
  },
  async createPasswordReset({}, { email, url }) {
    const endpoint = "api/v1/password_resets";
    const payload = {
      password_reset: {
        email: email,
        url: url
      }
    };
    const response = await this.$axios.$post(endpoint, payload);
    return response;
  }
};
