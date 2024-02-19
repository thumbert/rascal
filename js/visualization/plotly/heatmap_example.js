           
           let pause = 500;
            function delay(milliseconds) {
              return new Promise((resolve) => {
                setTimeout(resolve, milliseconds);
              });
            }
            
          async function animate() {
            let heatmap_example = document.getElementById("heatmap_example");
            let traces = [
              {
                  x: [
                    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
                    19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34,
                    35, 36,
                  ],
                  y: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
                  z: [
                    [
                      0, 0, 0, 0, 0, 0, 0, 2, 3, 4, 5, 6, 7, 7, 8, 9, 9, 8, 7, 6, 5,
                      4, 3, 3, 5, 5, 5, 5, 7, 7, 7, 5, 5, 5, 7, 7, 7, 7,
                    ],
                    [
                      0, 0, 1, 1, 0, 0, 2, 3, 4, 5, 6, 6, 7, 8, 8, 9, 9, 8, 7, 6, 5,
                      4, 3, 5, 5, 5, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
                    ],
                    [
                      0, 0, 0, 1, 1, 2, 3, 4, 5, 6, 6, 7, 7, 8, 9, 9, 8, 7, 7, 6, 6,
                      5, 4, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7, 7, 8, 7, 7,
                    ],
                    [
                      0, 0, 0, 0, 0, 2, 3, 4, 5, 6, 6, 7, 8, 8, 9, 9, 8, 7, 7, 6, 6,
                      5, 4, 3, 5, 5, 6, 6, 6, 8, 8, 8, 7, 7, 8, 7, 7, 7,
                    ],
                    [
                      1, 1, 0, 0, 0, 2, 3, 4, 5, 6, 7, 7, 7, 8, 9, 9, 9, 8, 7, 6, 5,
                      5, 4, 2, 4, 4, 6, 6, 6, 8, 8, 8, 8, 8, 8, 7, 7, 7,
                    ],
                    [
                      1, 1, 0, 0, 0, 0, 3, 4, 5, 6, 6, 6, 7, 7, 8, 9, 9, 8, 7, 6, 5,
                      4, 3, 2, 4, 4, 6, 6, 6, 8, 8, 8, 8, 8, 8, 7, 7, 7,
                    ],
                    [
                      2, 1, 1, 1, 1, 0, 2, 3, 4, 5, 6, 6, 7, 7, 8, 9, 8, 7, 7, 6, 5,
                      4, 2, 2, 4, 4, 4, 6, 6, 8, 8, 8, 8, 8, 7, 7, 7, 7,
                    ],
                    [
                      2, 2, 2, 2, 1, 0, 0, 2, 3, 3, 5, 6, 6, 7, 7, 8, 7, 7, 6, 5, 4,
                      3, 2, 4, 4, 4, 6, 6, 6, 8, 8, 8, 9, 9, 9, 7, 7, 7,
                    ],
                    [
                      2, 2, 2, 2, 1, 0, 0, 1, 1, 2, 3, 5, 6, 6, 7, 7, 7, 6, 5, 4, 3,
                      2, 2, 4, 4, 4, 6, 6, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7,
                    ],
                    [
                      2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 2, 3, 5, 6, 6, 6, 6, 5, 4, 3, 2,
                      2, 4, 4, 4, 6, 6, 6, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7,
                    ],
                    [
                      3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 3, 5, 5, 5, 5, 3, 3, 2, 2,
                      2, 4, 4, 6, 6, 6, 8, 8, 8, 8, 8, 8, 7, 7, 7, 8, 8,
                    ],
                    [
                      4, 4, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 1, 1, 2, 2,
                      4, 4, 4, 6, 6, 6, 8, 8, 8, 8, 8, 8, 7, 7, 7, 8, 8,
                    ],
                    [
                      5, 4, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
                      4, 4, 4, 6, 6, 6, 6, 6, 8, 8, 6, 8, 8, 7, 7, 7, 7,
                    ],
                  ],
                  type: "heatmap",
                },
                {
                  x: [0],
                  y: [0],
                  mode: "lines",
                  line: { color: "black", width: 3 },
                }
      ];

            let config =               {
                width: 1200,
                height: 500,
                xaxis: { constrain: "domain", zeroline: false, showline: false },
                yaxis: {
                  scaleanchor: "x",
                  range: [-1, 13],
                  zeroline: false,
                  showline: false,
                },
              };
            Plotly.newPlot(
              heatmap_example, traces,
              // [
              //   {
              //     x: [
              //       0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
              //       19, 20, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
              //       34, 35, 35, 35, 35, 35, 35, 35, 35, 35, 36, 37,
              //     ],
              //     y: [
              //       0, 0, 0, 1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 10, 10, 10, 9, 8, 7, 6,
              //       5, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 4, 5, 6, 7, 8, 9,
              //       10, 11, 12, 12,
              //     ],
              //     mode: "lines",
              //     line: { color: "black", width: 3 },
              //   },
              // ],
              config, { displaylogo: false, responsive: true }
            );

            //
            await delay(pause);
            traces[1] = {
              x: [0, 1],
              y: [0, 0],
              mode: "lines",
                  line: { color: "black", width: 3 },
            };
            Plotly.react(heatmap_example, traces, config, { displaylogo: false, responsive: true });
            //
            await delay(pause);
            traces[1] = {
              x: [0, 1, 2],
              y: [0, 0, 0],
              mode: "lines",
                  line: { color: "black", width: 3 },
            };
            Plotly.react(heatmap_example, traces, config, { displaylogo: false, responsive: true });
            //
            await delay(pause);
            traces[1] = {
              x: [0, 1, 2, 3],
              y: [0, 0, 0, 1],
              mode: "lines",
                  line: { color: "black", width: 3 },
            };
            Plotly.react(heatmap_example, traces, config, { displaylogo: false, responsive: true });
          }
          
          animate();




