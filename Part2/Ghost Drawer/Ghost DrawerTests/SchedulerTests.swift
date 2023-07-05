//
//  SchedulerTests.swift
//  Ghost DrawerTests
//
//  Created by Peter Varadi3 on 2023. 07. 05..
//

import XCTest

final class SchedulerTests: XCTestCase {
    func testSchedule_EmptyDrawing() {
        let drawing = Drawing(points: [], pencil: DummyPencil())
        let sut = Scheduler(timer: MockTimer())
        let testDelegate = TestSchedulerDelegate(scheduler: sut)
        testDelegate.scheduler.delegate = testDelegate

        let expectation = XCTestExpectation(description: "Should not be called")
        expectation.isInverted.toggle()
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSchedule_onePoint_calledOnce() {
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0)], pencil: MockPencil())
        let sut = Scheduler(timer: MockTimer())
        let testDelegate = TestSchedulerDelegate(scheduler: sut)
        testDelegate.scheduler.delegate = testDelegate

        let expectation = XCTestExpectation(description: "Should be called ONCE")
        expectation.expectedFulfillmentCount = 1
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSchedule_ThreePoints_calledTwice() {
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0),Point(position: .zero, timestamp: 1),Point(position: .zero, timestamp: 2)], pencil: MockPencil())
        let sut = Scheduler(timer: MockTimer())
        let testDelegate = TestSchedulerDelegate(scheduler: sut)
        testDelegate.scheduler.delegate = testDelegate

        let expectation = XCTestExpectation(description: "Should be called 3 times")
        expectation.expectedFulfillmentCount = 2
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSchedulFireTimerIntervals_ThreePoints() {
        let mockPencil = MockPencil()
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0),Point(position: .zero, timestamp: 1),Point(position: .zero, timestamp: 2)], pencil: mockPencil)

        var timerFireIntervals = [1 + mockPencil.delay, 2 + mockPencil.delay]
        let timerFireIntervalsExpectations = XCTestExpectation(description: "Should be empty")
        let sut = Scheduler(timer: MockFireTimer(asyncFireTimerInterval: { timerInterval in
            timerFireIntervals.removeAll(where: { $0 == timerInterval })
            if timerFireIntervals.isEmpty {
                timerFireIntervalsExpectations.fulfill()
            }
        }))

        let testDelegate = TestSchedulerDelegate(scheduler: sut)
        testDelegate.scheduler.delegate = testDelegate

        let expectation = XCTestExpectation(description: "Should be called 3 times")
        expectation.expectedFulfillmentCount = 2
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation, timerFireIntervalsExpectations], timeout: 0.5)
    }

    func testSchedule_ThreePoints() {
        let mockPencil = MockPencil()
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0),Point(position: .zero, timestamp: 1),Point(position: .zero, timestamp: 3)], pencil: mockPencil)

        let sut = Scheduler(timer: MockTimer())
        let testDelegate = TestSchedulerDelegate(scheduler: sut)
        testDelegate.scheduler.delegate = testDelegate

        let drawingExpectation = XCTestExpectation(description: "Should be called 3 times")
        drawingExpectation.expectedFulfillmentCount = 2
        let renderIntervalsExpectation = XCTestExpectation(description: "Should be called")
        testDelegate.isDrawingExpectation = drawingExpectation
        testDelegate.renderIntervalsExpectation = renderIntervalsExpectation
        testDelegate.expectedRenderIntervals = [1, 2]

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [drawingExpectation, renderIntervalsExpectation], timeout: 0.5)
    }
}

class TestSchedulerDelegate: SchedulerDelegate {
    var scheduler: SchedulerService
    var isDrawingExpectation: XCTestExpectation?
    var renderIntervalsExpectation: XCTestExpectation?
    var expectedRenderIntervals: [TimeInterval]?

    init(scheduler: SchedulerService) {
        self.scheduler = scheduler
    }

    func draw(scheduledPoint: ScheduledPoint) {
        isDrawingExpectation?.fulfill()
        self.expectedRenderIntervals?.removeAll(where: { $0 == scheduledPoint.renderInterval })
        if let expectedRenderIntervals = self.expectedRenderIntervals, expectedRenderIntervals.isEmpty {
            renderIntervalsExpectation?.fulfill()
        }
    }
}

struct DummyPencil: Drawable {
    var color: UIColor = .black
    var delay: TimeInterval = 0
}

struct MockPencil: Drawable {
    var color: UIColor = .black
    var delay: TimeInterval = 1
}

struct MockFireTimer: TimerService {
    var asyncFireTimerInterval: (TimeInterval) -> Void
    func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerService) -> Void) -> TimerService {
        asyncFireTimerInterval(withTimeInterval)
        block(self)
        return self
    }
}

struct MockTimer: TimerService {
    func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerService) -> Void) -> TimerService {
        block(self)
        return self
    }
}
