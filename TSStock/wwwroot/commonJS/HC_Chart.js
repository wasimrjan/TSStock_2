


function getUpperLimit(lgdata,rsdata,hldata)
{
    var max = 0;
    if(lgdata>rsdata && lgdata>hldata)
        max = lgdata;
    else
    if(rsdata>lgdata && rsdata>hldata)
        max = rsdata;
    else
        max = hldata;

    return getUpperLimitGraph(max);
}

function getUpperLimitGraph(mxvl)
{
    var vl = eval(mxvl);
    if(vl<10)
        return 10;
    if(vl<20)
        return 20;
    if(vl<30)
        return 30;
    if(vl<50)
        return 50;
    if(vl<75)
        return 75;
    if(vl<100)
        return 100;
    if(vl<150)
        return 150;
    if(vl<200)
        return 200;
    if(vl<300)
        return 300;
    if(vl<500)
        return 500;
    if(vl<700)
        return 700;
    if(vl<1000)
        return 1000;
    if(val<1500)
        return 1500;
    if(vl<2000)
        return 2000;
    if(vl<3000)
        return 3000;
    if(vl<4000)
        return 4000;
    if(vl<5000)
        return 5000;
    if(vl<7000)
        return 7000;
    if(vl<9000)
        return 10000;
}
function setupLineGraph(cngraph,gName,lgdata,rsdata,hldata,cldata)
{
    var ulm = getUpperLimit(lgdata,rsdata,hldata);
    var color = Chart.helpers.color;
    
    var weeklyChart = {
        labels: [gName],
        datasets: [{
                label: 'Logged',
                backgroundColor: '#4dc9f6',
                borderWidth: 1,
                data: [
                        lgdata
                ]
        }, {
                label: 'Resolved',
                backgroundColor: '#f67019',
                data: [
                        rsdata
                ]
        }, {
                label: 'Hold',
                backgroundColor: '#f6f019',
                data: [
                        hldata
                ]
        }, {
                label: 'Closed',
                backgroundColor: '#f6a0f9',
                data: [
                        cldata
                ]
        }]

    };

    var c = document.getElementById(cngraph);
    
    weeklygraph = new Chart(c,{
       type: 'bar',
       data: weeklyChart,
       options: {
                     scales: {
    yAxes: [{
      ticks: {
        beginAtZero: true,
        max:ulm
      }
    }]
  },

    elements: {
            bar: {
                    borderWidth: 2
            }
    },
    responsive: true,
    options: {
            legend: {
                    position:'right',
                    display:false
            },
            title: {
                    display: true,
                    text: 'Chart.js Horizontal Bar Chart'
            }
    },
    animation: {
        onComplete: function () {
            // render the value of the chart above the bar
            var ctx = this.chart.ctx;
            ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
            ctx.fillStyle = this.chart.config.options.defaultFontColor;
            ctx.textAlign = 'center';
            ctx.textBaseline = 'bottom';
            this.data.datasets.forEach(function (dataset) {
                for (var i = 0; i < dataset.data.length; i++) {
                    var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
                    ctx.fillText(dataset.data[i], model.x, model.y - 5);
                }
            });
        }}
    }
    });

}