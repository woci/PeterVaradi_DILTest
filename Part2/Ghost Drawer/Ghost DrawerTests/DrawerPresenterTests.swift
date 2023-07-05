//
//  DrawerPresenterTests.swift
//  Ghost DrawerTests
//
//  Created by Peter Varadi3 on 2023. 07. 05..
//

import XCTest

final class DrawerPresenterTests: XCTestCase {
    func testStartDrawing_DrawingExists() {
        let scheduler = MockScheduler()
        let pencilBlack = Pencil(color: .black, delay: 0)
        let presenter = DrawerPresenter(pencils: [pencilBlack], scheduler: scheduler)
        presenter.scheduler.delegate = presenter

        let sut = TestView(presenter: presenter)

        sut.presenter.startDrawing(position: .zero, timeStamp: 0, pencilIndex: 0)

        XCTAssertNotNil(sut.presenter.drawing)
        XCTAssert(sut.presenter.drawing! == Drawing(points: [Point(position: .zero, timestamp: 0)], pencil: pencilBlack))
    }

    func testUpdateDrawing_DrawingExists() {
        let scheduler = MockScheduler()
        let pencilBlack = Pencil(color: .black, delay: 0)
        let presenter = DrawerPresenter(drawing: Drawing(points: [Point(position: .zero, timestamp: 0)], pencil: pencilBlack), pencils: [pencilBlack], scheduler: scheduler)
        presenter.scheduler.delegate = presenter
        let sut = TestView(presenter: presenter)

        sut.presenter.updateDrawing(position: CGPoint(x: 1, y: 1), timeStamp: 1)

        XCTAssertNotNil(sut.presenter.drawing)
        XCTAssert(sut.presenter.drawing! == Drawing(points: [Point(position: .zero, timestamp: 0),
                                                             Point(position: CGPoint(x: 1, y: 1), timestamp: 1)],
                                                    pencil: pencilBlack))
    }

    func testUpdateDrawing_DrawingDoesntExists() {
        let scheduler = MockScheduler()
        let pencilBlack = Pencil(color: .black, delay: 0)
        let presenter = DrawerPresenter(pencils: [pencilBlack], scheduler: scheduler)
        presenter.scheduler.delegate = presenter
        let sut = TestView(presenter: presenter)

        sut.presenter.updateDrawing(position: CGPoint(x: 1, y: 1), timeStamp: 1)

        XCTAssertNil(sut.presenter.drawing)
    }

    func testFinishDrawing_DrawingExists() {
        let scheduler = MockScheduler()
        let pencilBlack = Pencil(color: .black, delay: 0)
        let presenter = DrawerPresenter(drawing: Drawing(points: [Point(position: .zero, timestamp: 0),
                                                                  Point(position: CGPoint(x: 1, y: 1), timestamp: 1)],
                                                         pencil: pencilBlack),
                                        pencils: [pencilBlack],
                                        scheduler: scheduler)
        presenter.scheduler.delegate = presenter
        let sut = TestView(presenter: presenter)
        sut.presenter.view = sut
        let renderExpectation = XCTestExpectation(description: "Should be called")
        sut.renderExpectation = renderExpectation
        sut.presenter.finishDrawing()

        wait(for: [renderExpectation], timeout: 0.5)
    }

    func testFinishDrawing_DrawingDoesntExists() {
        let scheduler = MockScheduler()
        let pencilBlack = Pencil(color: .black, delay: 0)
        let presenter = DrawerPresenter(pencils: [pencilBlack],
                                        scheduler: scheduler)
        presenter.scheduler.delegate = presenter
        let sut = TestView(presenter: presenter)
        sut.presenter.view = sut
        let renderExpectation = XCTestExpectation(description: "Should be called")
        renderExpectation.isInverted.toggle()
        sut.renderExpectation = renderExpectation
        sut.presenter.finishDrawing()

        wait(for: [renderExpectation], timeout: 0.5)
    }
}

class TestView: DrawerView {
    let presenter: DrawerPresenterService
    var renderExpectation: XCTestExpectation?

    init(presenter: DrawerPresenterService) {
        self.presenter = presenter
    }

    func render(scheduledPath: ScheduledPath) {
        renderExpectation?.fulfill()
    }
}

class MockScheduler: SchedulerService {
    func scheduleDrawing(drawing: Drawing) {
        drawing.points.forEach { point in
            let scheduledPath = ScheduledPath(from: point.position, to: point.position, color: drawing.pencil.color, renderInterval: 0)
            delegate?.draw(scheduledPath: scheduledPath)
        }
    }

    var delegate: SchedulerDelegate?
}
