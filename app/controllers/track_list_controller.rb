class TrackListController
    include AppHelper

    def initialize(opts)
        @data = [
            { filePath: 'hahaha', length: '6:32' },
            { filePath: 'hahaha2', length: '7:32' },
            { filePath: 'hahaha3', length: '8:32' },
            { filePath: 'hahaha4', length: '9:32' },
            { filePath: 'hahaha5', length: '10:32' },
        ]

        @closeButton = opts[:closeButton]

        buildFileSelectButton

        buildScrollView
        buildTableView
    end

    private

        def buildFileSelectButton
            @fileSelectButton = NSButton.alloc.initWithFrame(
                [[10, 10], [100, 22]]
            ).tap do |button|
                button.translatesAutoresizingMaskIntoConstraints = false
                button.bezelStyle = NSShadowlessSquareBezelStyle
                button.buttonType = NSMomentaryChangeButton
                button.title = 'Select folder'
                # button.bordered = true
                # button.image = NSImage.imageNamed('img/circle')
                # p button.image
                # button.imagePosition = NSImageOnly
                button.target = self
                button.action = 'selectFolder:'
            end

            main_window.contentView.addSubview(@fileSelectButton)

            main_window.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(
                @fileSelectButton,
                attribute: NSLayoutAttributeBottom,
                relatedBy: NSLayoutRelationEqual,
                toItem: main_window.contentView,
                attribute: NSLayoutAttributeBottom,
                multiplier: 1.0,
                constant: -10.0
            ))

            main_window.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(
                @fileSelectButton,
                attribute: NSLayoutAttributeLeft,
                relatedBy: NSLayoutRelationEqual,
                toItem: main_window.contentView,
                attribute: NSLayoutAttributeLeft,
                multiplier: 1.0,
                constant: 10.0
            ))
        end

        def selectFolder(sender)
            p 'select folder'

            @data << { filePath: 'hahahanew', length: '1:32' }
            @data << { filePath: 'hahahanew', length: '2:32' }
            @data << { filePath: 'hahahanew', length: '3:32' }

            @tableView.reloadData
        end

        def buildScrollView
            @scrollView = NSScrollView.alloc.initWithFrame(
                [[0, 0], [480, 322]]
            ).tap do |scrollView|
                scrollView.translatesAutoresizingMaskIntoConstraints = false
                scrollView.hasVerticalScroller = true
            end

            main_window.contentView.addSubview(@scrollView)

            main_window.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(
                @scrollView,
                attribute: NSLayoutAttributeTop,
                relatedBy: NSLayoutRelationEqual,
                toItem: @closeButton,
                attribute: NSLayoutAttributeBottom,
                multiplier: 1.0,
                constant: 10.0
            ))

            main_window.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(
                @scrollView,
                attribute: NSLayoutAttributeBottom,
                relatedBy: NSLayoutRelationEqual,
                toItem: @fileSelectButton,
                attribute: NSLayoutAttributeTop,
                multiplier: 1.0,
                constant: -10.0
            ))

            main_window.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(
                @scrollView,
                attribute: NSLayoutAttributeLeft,
                relatedBy: NSLayoutRelationEqual,
                toItem: main_window.contentView,
                attribute: NSLayoutAttributeLeft,
                multiplier: 1.0,
                constant: 0.0
            ))

            main_window.contentView.addConstraint(NSLayoutConstraint.constraintWithItem(
                @scrollView,
                attribute: NSLayoutAttributeRight,
                relatedBy: NSLayoutRelationEqual,
                toItem: main_window.contentView,
                attribute: NSLayoutAttributeRight,
                multiplier: 1.0,
                constant: 0.0
            ))
        end

        def buildTableView
            @tableView = NSTableView.alloc.init.tap do |table|
                # table.usesAlternatingRowBackgroundColors = true
                table.backgroundColor = NSColor.colorWithCalibratedRed(28.0/255.0, green: 42.0/255.0, blue: 57.0/255.0, alpha: 255.0/255.0)
                table.rowHeight = 18.0
            end

            columnFilePath = NSTableColumn.alloc.initWithIdentifier("filePath")
            columnFilePath.editable = false
            columnFilePath.headerCell.setTitle("File Path")
            columnFilePath.width = 400
            @tableView.addTableColumn(columnFilePath)

            columnDate = NSTableColumn.alloc.initWithIdentifier("length")
            columnDate.editable = false
            columnDate.headerCell.setTitle("Length")
            columnDate.width = 400
            @tableView.addTableColumn(columnDate)

            @tableView.delegate = self
            @tableView.dataSource = self
            @tableView.autoresizingMask = NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin
            @tableView.target = self
            @tableView.doubleAction = :"doubleClickColumn:"

            @scrollView.setDocumentView(@tableView)
        end

        def tableView(aTableView, viewForTableColumn: aTableColumn, row: aRow)
            # Get an existing cell with the MyView identifier if it exists
            result = aTableView.makeViewWithIdentifier("SongListCellView", owner: self)

            # There is no existing cell to reuse so create a new one
            if (result.nil?)
                # Create the new NSTextField with a frame of the {0,0} with the width of the table.
                # Note that the height of the frame is not really relevant, because the row height will modify the height.
                result = NSTextField.alloc.initWithFrame(
                    [[0, 100], [0, 100]]
                ).tap do |textField|
                    textField.setSelectable(false)
                    textField.setBezeled(false)
                    textField.setDrawsBackground(false)
                    textField.setBordered(false)

                    textField.setTextColor(NSColor.colorWithCalibratedRed(188.0/255.0, green: 202.0/255.0, blue: 217.0/255.0, alpha: 255.0/255.0))
                end

                # The identifier of the NSTextField instance is set to MyView.
                # This allows the cell to be reused.
                result.identifier = "SongListCellView"
            end

            # result is now guaranteed to be valid, either as a reused cell
            # or as a new cell, so set the stringValue of the cell to the
            # nameArray value at row
            result.stringValue = @data[aRow]

            # Return the result
            return result
        end

        def tableView(aTableView, didAddRowView: rowView, forRow: row)
            if (row % 2 == 0)
                rowView.backgroundColor = NSColor.colorWithCalibratedRed(28.0/255.0, green: 42.0/255.0, blue: 57.0/255.0, alpha: 255.0/255.0)
            else
                rowView.backgroundColor = NSColor.colorWithCalibratedRed(44.0/255.0, green: 58.0/255.0, blue: 73.0/255.0, alpha: 255.0/255.0)
            end
        end

        def doubleClickColumn(sender)
            p 'click song'

            row = sender.clickedRow
            
            p @data[row]
        end

        def numberOfRowsInTableView(aTableView)
          @data.size
        end

        def tableView(aTableView, objectValueForTableColumn: aTableColumn, row: rowIndex)
            p aTableColumn

            case aTableColumn.identifier
                when 'filePath'
                    @data[rowIndex][:filePath]
                when 'length'
                    @data[rowIndex][:length]
            end
        end
end