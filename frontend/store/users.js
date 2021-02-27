export const state = () => ({
  user: {}
})

export const actions = {
  async fetchUser({ commit }, id) {
    let res = await this.$axios.$get('/api/v1/users/' + id)
    console.log(res)
    commit('setUser', res)
  }
}

export const getters = {
  user(state) {
    return state.user
  },
}

export const mutations = {
  setUser(state, payload) {
    state.user = payload
  },
}
