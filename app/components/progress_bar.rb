# TODO: don't draw slider cell until song is played?

module UiComponents
    class ProgressBar
        include AppHelper

        def initialize
            @uiComponent = nil

            createUiComponent

            attachSubscribers
        end

        def attachSubscribers
            NSNotificationCenter.defaultCenter.addObserver(self,
                  selector: 'updateTotalDuration:',
                  name: 'audioManager:play',
                  object: nil
            )

            NSNotificationCenter.defaultCenter.addObserver(self,
                  selector: 'clearCurrentTime',
                  name: 'audioManager:stop',
                  object: nil
            )

            NSNotificationCenter.defaultCenter.addObserver(self,
                  selector: 'addUpdateCurrentTimeObserver',
                  name: 'audioManager:resume',
                  object: nil
            )

            addUpdateCurrentTimeObserver

            NSNotificationCenter.defaultCenter.addObserver(self,
                  selector: 'removeUpdateCurrentTimeObserver',
                  name: 'progressNsSlider:mouseDown',
                  object: nil
            )
        end

        def addUpdateCurrentTimeObserver
            removeUpdateCurrentTimeObserver

            NSNotificationCenter.defaultCenter.addObserver(self,
                  selector: 'updateCurrentTime:',
                  name: 'audioManager:startSendingPlayingSongInfo',
                  object: nil
            )
        end

        def removeUpdateCurrentTimeObserver
            NSNotificationCenter.defaultCenter.removeObserver(self,
                  name: 'audioManager:startSendingPlayingSongInfo',
                  object: nil
            )
        end

        def getUiComponent
            @uiComponent
        end

        def updateTotalDuration(sender)
            songDuration = sender.userInfo[:duration]

            p "total duration: " + songDuration.to_s

            getUiComponent.maxValue = songDuration
        end

        def clearCurrentTime
            getUiComponent.floatValue = 0.0
        end

        def updateCurrentTime(sender)
            currentTime = sender.userInfo[:currentTime]

            p "current time: " + currentTime.to_s

            getUiComponent.floatValue = currentTime
        end

        private

            def createUiComponent
                @uiComponent = ProgressNSSlider.alloc.initWithFrame(
                    [[10, 10], [100, 22]]
                ).tap do |slider|
                    slider.minValue = 0.0
                    slider.maxValue = 1.0
                    slider.translatesAutoresizingMaskIntoConstraints = false
                end
            end
    end
end