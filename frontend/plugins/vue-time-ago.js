import VueTimeago from "vue-timeago";
import Vue from "vue";

Vue.use(VueTimeago, {
  name: "Timeago", // Component name, `Timeago` by default
  locale: "en", // Default locale
  // We use `date-fns` under the hood
  // So you can use all locales from it
  locales: {
    ja: require("date-fns/locale/ja")
  }
});
