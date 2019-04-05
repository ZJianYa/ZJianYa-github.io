module.exports = {
  // 主题部署
  title: '主页',
  description: '',
  head: ['link', {
    rel: 'icon',
    href: '/icon.png'
  }],
  // TODO 所有的配置以后改为独立文件夹配置，且可以自动扫描注册
  themeConfig: {
    nav: [{
      text: '主页',
      link: '/home/'
    },{
      text: '关于我',
      link: '/about/resume.md'
    },
    {
      text: 'Java系列',
      items: [
        {
          text:'Java Core',
          link:'/article/jdk'
        },
        {
          text:'Spring Core',
          link:'/article/spring'
        },
        {
          text:'mybatis generator',
          link:'/article/mybatis-generator'
        }
      ]
    },
    {
      text: 'MySQL',
      link: '/article/mysql/'
    },
    {
      text: '关于博客',
      items: [{
        text: '如何搭建',
        link: '/about/how-to-build-blog.md',
      },{
        text: '做什么用',
        link: '/about/why-blog.md'
      }]
    },
    // 链接到网站
    {
      text: 'Github',
      link: 'https://github.com/ZJianYa/myblog'
    },
    ]
  },
  markdown: {
		anchor: {
			permalink: true
		},
		toc: {
			includeLevel: [1, 2]
		},
		config: md => {
			// 使用更多 markdown-it 插件！
			md.use(require('markdown-it-task-lists'))
			.use(require('markdown-it-imsize'), { autofill: true })
		}
	},
	postcss: {
		plugins: [require('autoprefixer')]
	},
}