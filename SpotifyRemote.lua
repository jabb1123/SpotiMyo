scriptId = 'com.jabb1123.myfirstscript'

locked = true
toggleVolumeCon=false
myo.controlMouse(true)

function onForegroundWindowChange(app,title)
	myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	runningSpotify=TestForSpotify(title)
	return true
end

function onPoseEdge(pose, edge)
	myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
	pose = conditionallySwapWave(pose)
	if (edge == 'on') then
		if (pose == "thumbToPinky") then
			onThumbToPinky()
		elseif not locked then
			if runningSpotify then
				if (pose == "waveOut") then
					onWaveOut()
				elseif (pose == "waveIn") then
					onWaveIn()
				elseif (pose == "fist") then
					onFist()
				elseif (pose == "fingersSpread") then
					onFingersSpread()
				end
			end
		end
	end
end

function conditionallySwapWave(pose)
	if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

function TestForSpotify( title )
	if (string.find(title,"Spotify")) then
		myo.debug("Running Spotify")
    	return true
	else
	    return false
	end
end

function onFingersSpread()
	toggleVolumeCon= not toggleVolumeCon
	myo.vibrate("long")
	return toggleVolumeCon
end

function onFist()
	if toggleVolumeCon then
		myo.debug("Shuffle")
		myo.keyboard("s", "press","control")
		myo.vibrate("short")
	else
		myo.debug("Pause/Play")
		myo.keyboard("space", "press")
		myo.vibrate("short")
	end
end

function onWaveIn(  )
	if toggleVolumeCon then
		myo.debug("Volume Down")
		myo.keyboard("down_arrow", "press","control")
		myo.vibrate("short")
	else
		myo.debug("Last Song")
		myo.keyboard("left_arrow", "press","control")
		myo.vibrate("medium")
	end
end

function onWaveOut(  )
	if toggleVolumeCon then
		myo.debug("Volume Up")
		myo.keyboard("up_arrow", "press","control")
		myo.vibrate("short")
	else
		myo.debug("Next Song")
		myo.keyboard("right_arrow", "press","control")
		myo.vibrate("medium")
	end
end

function timeToLock()
	-- body
end

function onThumbToPinky( )
	locked = not locked
	myo.vibrate("short")
	if not locked then 
		myo.controlMouse(false)
		myo.debug("Unlocked")
		myo.vibrate("short")
	else
		myo.controlMouse(false)
		myo.debug("Locked")
	end
end